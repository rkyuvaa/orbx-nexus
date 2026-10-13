import asyncio
import subprocess
import os
import datetime
from fastapi import APIRouter, HTTPException, UploadFile, File
from fastapi.responses import FileResponse
from pydantic import BaseModel
from sqlalchemy import text

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
            try:
                stat = os.stat(path)
                files.append(
                    BackupResult(
                        filename=f,
                        created_at=datetime.datetime.fromtimestamp(stat.st_mtime).isoformat(),
                        size_bytes=stat.st_size,
                    )
                )
            except Exception:
                continue
    return files


@router.get("/download/{filename}")
async def download_backup(filename: str, current_user: CurrentUser):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    filepath = os.path.join(BACKUP_DIR, filename)
    if not os.path.exists(filepath):
        raise HTTPException(status_code=404, detail="Backup file not found")
    return FileResponse(filepath, media_type="application/octet-stream", filename=filename)


def parse_db_url(url: str):
    db_url = url.replace("postgresql+psycopg://", "").replace("postgresql://", "")
    try:
        userpass, rest = db_url.split("@")
        user, password = userpass.split(":")
        hostport, dbname = rest.split("/")
        dbname = dbname.split("?")[0]
        if ":" in hostport:
            host, port = hostport.split(":")
        else:
            host, port = hostport, "5432"
        return user, password, host, port, dbname
    except Exception:
        return "orbx", "orbx_secret", "postgres", "5432", "orbx_nexus"


@router.post("/create")
async def create_backup(current_user: CurrentUser):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")

    os.makedirs(BACKUP_DIR, exist_ok=True)
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"orbx_nexus_backup_{timestamp}.sql"
    filepath = os.path.join(BACKUP_DIR, filename)

    user, password, host, port, dbname = parse_db_url(settings.DATABASE_URL)
    env = os.environ.copy()
    env["PGPASSWORD"] = password

    cmd = ["pg_dump", "-h", host, "-p", str(port), "-U", user, "-F", "p", "-f", filepath, dbname]
    proc = await asyncio.create_subprocess_exec(
        *cmd,
        env=env,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    stdout, stderr = await proc.communicate()
    if proc.returncode != 0:
        err = stderr.decode("utf-8", errors="ignore") if stderr else "Unknown error"
        raise HTTPException(status_code=500, detail=f"Backup failed: {err}")

    stat = os.stat(filepath)
    return BackupResult(
        filename=filename,
        created_at=datetime.datetime.now().isoformat(),
        size_bytes=stat.st_size,
    )


@router.post("/restore/{filename}")
async def restore_backup(filename: str, current_user: CurrentUser):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    filepath = os.path.join(BACKUP_DIR, filename)
    if not os.path.exists(filepath):
        raise HTTPException(status_code=404, detail="Backup file not found")

    user, password, host, port, dbname = parse_db_url(settings.DATABASE_URL)
    env = os.environ.copy()
    env["PGPASSWORD"] = password

    # Disconnect idle client connections so restore doesn't encounter lock wait timeouts
    try:
        async with engine.begin() as conn:
            await conn.execute(text(f"""
                SELECT pg_terminate_backend(pid) 
                FROM pg_stat_activity 
                WHERE datname = '{dbname}' 
                  AND pid <> pg_backend_pid();
            """))
    except Exception as e:
        print(f"[RESTORE] Note on terminating active connections: {e}")

    await engine.dispose()

    # Detect if binary pg_dump or plain SQL text
    is_binary = False
    try:
        with open(filepath, "rb") as f:
            header = f.read(5)
            if header.startswith(b"PGDMP"):
                is_binary = True
    except Exception:
        pass

    if is_binary:
        cmd = [
            "pg_restore",
            "-h", host,
            "-p", str(port),
            "-U", user,
            "-d", dbname,
            "--clean",
            "--if-exists",
            "--no-owner",
            filepath,
        ]
    else:
        cmd = [
            "psql",
            "-h", host,
            "-p", str(port),
            "-U", user,
            "-d", dbname,
            "-f", filepath,
        ]

    proc = await asyncio.create_subprocess_exec(
        *cmd,
        env=env,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    stdout, stderr = await proc.communicate()
    stderr_text = stderr.decode("utf-8", errors="ignore") if stderr else ""

    if proc.returncode != 0:
        fatal_keywords = ["could not connect", "password authentication failed", "fatal:", "terminating connection"]
        if any(kw in stderr_text.lower() for kw in fatal_keywords):
            raise HTTPException(status_code=500, detail=f"Database restore failed: {stderr_text[:500]}")
        print(f"[RESTORE] Non-fatal restore notice: {stderr_text[:500]}")

    # Re-verify and ensure master schema after restore
    try:
        from app.db.schema_manager import ensure_master_schema
        await ensure_master_schema(engine)
    except Exception as ex:
        print(f"[RESTORE] Post-restore schema sync notice: {ex}")

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

    # Stream chunks to prevent RAM overflow on large database files
    with open(filepath, "wb") as f:
        while chunk := await file.read(1024 * 1024):
            f.write(chunk)

    return await restore_backup(filename=os.path.basename(filepath), current_user=current_user)


@router.delete("/{filename}", status_code=204)
async def delete_backup(filename: str, current_user: CurrentUser):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    filepath = os.path.join(BACKUP_DIR, filename)
    if not os.path.exists(filepath):
        raise HTTPException(status_code=404, detail="Backup not found")
    os.remove(filepath)
