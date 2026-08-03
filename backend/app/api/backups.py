import subprocess
import os
import datetime
from fastapi import APIRouter, HTTPException, UploadFile, File
from fastapi.responses import FileResponse
from pydantic import BaseModel

from app.api.deps import CurrentUser, DBSession
from app.core.config import settings
from app.db.session import engine

router = APIRouter()

BACKUP_DIR = "backups"


class BackupResult(BaseModel):
    filename: str
    created_at: str
    size_bytes: int


@router.get("/list", response_model=list[BackupResult])
async def list_backups(current_user: CurrentUser):
    if not os.path.exists(BACKUP_DIR):
        return []
    files = []
    for f in sorted(os.listdir(BACKUP_DIR), reverse=True):
        if f.endswith(".sql") or f.endswith(".dump"):
            path = os.path.join(BACKUP_DIR, f)
            stat = os.stat(path)
            files.append(BackupResult(
                filename=f,
                created_at=datetime.datetime.fromtimestamp(stat.st_mtime).isoformat(),
                size_bytes=stat.st_size
            ))
    return files


@router.get("/download/{filename}")
async def download_backup(filename: str, current_user: CurrentUser):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    filepath = os.path.join(BACKUP_DIR, filename)
    if not os.path.exists(filepath):
        raise HTTPException(status_code=404, detail="Backup file not found")
    return FileResponse(filepath, media_type="application/octet-stream", filename=filename)


@router.post("/create")
async def create_backup(current_user: CurrentUser):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")

    os.makedirs(BACKUP_DIR, exist_ok=True)
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"orbx_nexus_backup_{timestamp}.sql"
    filepath = os.path.join(BACKUP_DIR, filename)

    # Parse connection string
    db_url = settings.DATABASE_URL.replace("postgresql+psycopg://", "")
    try:
        userpass, rest = db_url.split("@")
        user, password = userpass.split(":")
        hostport, dbname = rest.split("/")
        if ":" in hostport:
            host, port = hostport.split(":")
        else:
            host, port = hostport, "5432"
    except Exception:
        raise HTTPException(status_code=500, detail="Could not parse DATABASE_URL for backup")

    env = os.environ.copy()
    env["PGPASSWORD"] = password

    try:
        result = subprocess.run(
            ["pg_dump", "-h", host, "-p", port, "-U", user, "-F", "p", "-f", filepath, dbname],
            env=env,
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            raise HTTPException(status_code=500, detail=f"Backup failed: {result.stderr}")
    except FileNotFoundError:
        # Fallback to Docker if pg_dump is not available on host
        result = subprocess.run(
            ["docker", "exec", "orbx_nexus_postgres", "pg_dump", "-U", user, "-F", "p", dbname],
            capture_output=True,
            text=False,
        )
        if result.returncode != 0:
            err = result.stderr.decode('utf-8', errors='ignore') if result.stderr else "Unknown error"
            raise HTTPException(status_code=500, detail=f"Backup failed (docker): {err}")
        with open(filepath, "wb") as f:
            f.write(result.stdout)

    stat = os.stat(filepath)
    return BackupResult(
        filename=filename,
        created_at=datetime.datetime.now().isoformat(),
        size_bytes=stat.st_size
    )


@router.post("/restore/{filename}")
async def restore_backup(filename: str, current_user: CurrentUser):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    filepath = os.path.join(BACKUP_DIR, filename)
    if not os.path.exists(filepath):
        raise HTTPException(status_code=404, detail="Backup file not found")

    # Parse connection string
    db_url = settings.DATABASE_URL.replace("postgresql+psycopg://", "")
    try:
        userpass, rest = db_url.split("@")
        user, password = userpass.split(":")
        hostport, dbname = rest.split("/")
        if ":" in hostport:
            host, port = hostport.split(":")
        else:
            host, port = hostport, "5432"
    except Exception:
        raise HTTPException(status_code=500, detail="Could not parse DATABASE_URL for restore")

    env = os.environ.copy()
    env["PGPASSWORD"] = password

    # Close active SQLAlchemy pooled connections in Uvicorn to prevent lock deadlocks
    await engine.dispose()

    try:
        # Terminate any other open sessions to orbx_nexus database
        subprocess.run(
            ["docker", "exec", "orbx_nexus_postgres", "psql", "-U", user, "-d", "postgres", "-c",
             f"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '{dbname}' AND pid <> pg_backend_pid();"],
            capture_output=True,
            timeout=10,
        )
    except Exception:
        pass

    try:
        result = subprocess.run(
            ["psql", "-h", host, "-p", port, "-U", user, "-d", dbname, "-f", filepath],
            env=env,
            capture_output=True,
            text=True,
            timeout=60,
        )
        if result.returncode != 0:
            raise HTTPException(status_code=500, detail=f"Restore failed: {result.stderr}")
    except (FileNotFoundError, subprocess.TimeoutExpired):
        # Fallback to Docker via docker cp and psql -f
        try:
            subprocess.run(
                ["docker", "cp", filepath, "orbx_nexus_postgres:/tmp/restore.sql"],
                check=True,
                timeout=30,
            )
            res = subprocess.run(
                ["docker", "exec", "orbx_nexus_postgres", "psql", "-U", user, "-d", dbname, "-f", "/tmp/restore.sql"],
                capture_output=True,
                text=True,
                timeout=60,
            )
            subprocess.run(
                ["docker", "exec", "orbx_nexus_postgres", "rm", "-f", "/tmp/restore.sql"],
                timeout=10,
            )
            if res.returncode != 0:
                raise HTTPException(status_code=500, detail=f"Restore failed (docker): {res.stderr}")
        except Exception as ex:
            if isinstance(ex, HTTPException):
                raise ex
            raise HTTPException(status_code=500, detail=f"Restore failed via docker: {str(ex)}")
    finally:
        await engine.dispose()

    return {"message": f"Successfully restored {filename}"}


@router.post("/upload-restore")
async def upload_and_restore(current_user: CurrentUser, file: UploadFile = File(...)):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    if not (file.filename.endswith(".sql") or file.filename.endswith(".dump")):
        raise HTTPException(status_code=400, detail="Only .sql or .dump files are supported")

    os.makedirs(BACKUP_DIR, exist_ok=True)
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    filepath = os.path.join(BACKUP_DIR, f"uploaded_{timestamp}_{file.filename}")
    
    content = await file.read()
    with open(filepath, "wb") as f:
        f.write(content)

    return await restore_backup(filename=os.path.basename(filepath), current_user=current_user)


@router.delete("/{filename}", status_code=204)
async def delete_backup(filename: str, current_user: CurrentUser):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    filepath = os.path.join(BACKUP_DIR, filename)
    if not os.path.exists(filepath):
        raise HTTPException(status_code=404, detail="Backup not found")
    os.remove(filepath)
