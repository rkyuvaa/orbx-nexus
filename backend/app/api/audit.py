from fastapi import APIRouter, Query
from sqlalchemy import text
from typing import Optional

from app.api.deps import CurrentUser, DBSession

router = APIRouter()


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
    module: str = Query(...),
    action: str = Query(...),
    record_id: Optional[int] = Query(None),
    fy: str = Query(default="2026_2027"),
):
    schema = f"fy_{fy}"
    await db.execute(
        text(
            f"INSERT INTO {schema}.audit_logs (user_id, username, action, module, record_id) "
            f"VALUES (:uid, :uname, :action, :mod, :rid)"
        ),
        {
            "uid": current_user.id, "uname": current_user.username,
            "action": action, "mod": module, "rid": record_id
        }
    )
    return {"message": "Logged"}
