import json
from fastapi import APIRouter, Query, Request
from sqlalchemy import text
from typing import Optional

from app.api.deps import CurrentUser, DBSession

router = APIRouter()


async def log_audit_event(
    db: DBSession,
    user_id: Optional[int],
    username: Optional[str],
    action: str,
    module: str,
    record_id: Optional[int] = None,
    old_values: Optional[dict] = None,
    new_values: Optional[dict] = None,
    ip_address: Optional[str] = None,
    fy: str = "2026_2027",
    request: Optional[Request] = None,
):
    """
    Writes an audit log entry into the active financial year schema's audit_logs table.
    """
    try:
        if request is not None:
            request.state.audit_logged = True
            if not ip_address and request.client:
                ip_address = request.client.host

        schema = f"fy_{fy}"
        await db.execute(
            text(
                f"INSERT INTO {schema}.audit_logs (user_id, username, action, module, record_id, old_values, new_values, ip_address) "
                f"VALUES (:uid, :uname, :action, :mod, :rid, :old_val, :new_val, :ip)"
            ),
            {
                "uid": user_id,
                "uname": username or "System",
                "action": action,
                "mod": module,
                "rid": record_id,
                "old_val": json.dumps(old_values) if old_values else None,
                "new_val": json.dumps(new_values) if new_values else None,
                "ip": ip_address,
            }
        )
    except Exception as e:
        print(f"[AUDIT LOG ERROR] Failed to write audit log: {e}")



@router.get("/")
async def get_audit_logs(
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
    module: Optional[str] = None,
    user_id: Optional[int] = None,
    limit: int = Query(default=100, le=500),
):
    schema = f"fy_{fy}"
    conds = ["1=1"]
    params: dict = {"limit": limit}
    if module:
        conds.append("module = :mod")
        params["mod"] = module
    if user_id:
        conds.append("user_id = :uid")
        params["uid"] = user_id
    result = await db.execute(
        text(
            f"SELECT * FROM {schema}.audit_logs WHERE {' AND '.join(conds)} "
            f"ORDER BY created_at DESC LIMIT :limit"
        ),
        params
    )
    return [dict(r) for r in result.mappings().all()]


@router.post("/log")
async def write_audit_log(
    current_user: CurrentUser,
    db: DBSession,
    request: Request,
    module: str = Query(...),
    action: str = Query(...),
    record_id: Optional[int] = Query(None),
    fy: str = Query(default="2026_2027"),
):
    ip_addr = request.client.host if request and request.client else None
    await log_audit_event(
        db=db,
        user_id=current_user.id,
        username=current_user.username,
        action=action,
        module=module,
        record_id=record_id,
        ip_address=ip_addr,
        fy=fy,
    )
    return {"message": "Logged"}

