from fastapi import APIRouter, Query
from sqlalchemy import text
from pydantic import BaseModel
from typing import Optional
import datetime

from app.api.deps import CurrentUser, DBSession

router = APIRouter()


def s(fy: str) -> str:
    return f"fy_{fy}"


class BiometricEntryIn(BaseModel):
    ledger_id: int
    entry_date: str
    punch_in: str | None = None
    punch_out: str | None = None
    hours_worked: float | None = None
    status: str = "Present"
    device_log_id: str | None = None


@router.get("/")
async def list_biometric_entries(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    from_date: Optional[str] = None, to_date: Optional[str] = None,
    ledger_id: Optional[int] = None
):
    schema = s(fy)
    conds = ["1=1"]
    params: dict = {}
    if from_date:
        conds.append("entry_date >= :fd")
        params["fd"] = from_date
    if to_date:
        conds.append("entry_date <= :td")
        params["td"] = to_date
    if ledger_id:
        conds.append("ledger_id = :lid")
        params["lid"] = ledger_id
    result = await db.execute(
        text(
            f"SELECT be.*, l.name AS ledger_name "
            f"FROM {schema}.biometric_entries be "
            f"LEFT JOIN master.ledgers l ON l.id = be.ledger_id "
            f"WHERE {' AND '.join(conds)} ORDER BY entry_date DESC, ledger_id"
        ),
        params
    )
    return [dict(r) for r in result.mappings().all()]


@router.post("/", status_code=201)
async def create_biometric_entry(
    body: BiometricEntryIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"INSERT INTO {schema}.biometric_entries "
            f"(ledger_id, entry_date, punch_in, punch_out, hours_worked, status, device_log_id) "
            f"VALUES (:lid, :edate, :pin, :pout, :hw, :status, :dlid) RETURNING id"
        ),
        {
            "lid": body.ledger_id, "edate": body.entry_date, "pin": body.punch_in,
            "pout": body.punch_out, "hw": body.hours_worked, "status": body.status,
            "dlid": body.device_log_id
        }
    )
    return {"id": result.scalar_one(), "message": "Entry created"}


@router.delete("/{entry_id}", status_code=204)
async def delete_biometric_entry(
    entry_id: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    await db.execute(
        text(f"DELETE FROM {s(fy)}.biometric_entries WHERE id = :id"), {"id": entry_id}
    )


@router.get("/attendance-summary")
async def attendance_summary(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    month: int = Query(...), year: int = Query(...)
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"SELECT l.id, l.name AS ledger, "
            f"COUNT(*) FILTER (WHERE be.status = 'Present') AS present_days, "
            f"COUNT(*) FILTER (WHERE be.status = 'Absent') AS absent_days, "
            f"COUNT(*) FILTER (WHERE be.status = 'Half Day') AS half_days, "
            f"COALESCE(SUM(be.hours_worked), 0) AS total_hours "
            f"FROM master.ledgers l "
            f"LEFT JOIN {schema}.biometric_entries be ON be.ledger_id = l.id "
            f"AND EXTRACT(MONTH FROM be.entry_date) = :m AND EXTRACT(YEAR FROM be.entry_date) = :y "
            f"WHERE l.ledger_type = 'Staff' AND l.is_active = TRUE "
            f"GROUP BY l.id, l.name ORDER BY l.name"
        ),
        {"m": month, "y": year}
    )
    return [dict(r) for r in result.mappings().all()]
