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
            f"COUNT(*) FILTER (WHERE be.status = 'On Leave') AS leave_days, "
            f"COALESCE(SUM(be.hours_worked), 0) AS total_hours "
            f"FROM master.ledgers l "
            f"LEFT JOIN {schema}.biometric_entries be ON be.ledger_id = l.id "
            f"AND EXTRACT(MONTH FROM be.entry_date) = :m AND EXTRACT(YEAR FROM be.entry_date) = :y "
            f"WHERE (l.ledger_type = 'Staff' OR l.group_id IN (SELECT id FROM master.ledger_groups WHERE name LIKE '%Staff%' OR name LIKE '%Salary%')) AND l.is_active = TRUE "
            f"GROUP BY l.id, l.name ORDER BY l.name"
        ),
        {"m": month, "y": year}
    )
    return [dict(r) for r in result.mappings().all()]


class DailyAttendanceItem(BaseModel):
    ledger_id: int
    status: str = "Present"
    punch_in: Optional[str] = "09:00"
    punch_out: Optional[str] = "18:00"
    hours_worked: Optional[float] = 8.0
    ot_hours: Optional[float] = 0.0
    remarks: Optional[str] = None

class DailyAttendanceBulkIn(BaseModel):
    entry_date: str
    entries: list[DailyAttendanceItem]


@router.get("/daily-staff")
async def get_daily_staff_attendance(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    entry_date: str = Query(...)
):
    schema = s(fy)
    try:
        await db.execute(text(f"ALTER TABLE {schema}.biometric_entries ADD COLUMN IF NOT EXISTS ot_hours numeric(5,2) DEFAULT 0"))
    except Exception:
        pass

    result = await db.execute(
        text(
            f"SELECT l.id AS ledger_id, l.name AS staff_name, l.code AS staff_code, "
            f"be.id AS entry_id, "
            f"COALESCE(be.status, 'Present') AS status, "
            f"COALESCE(be.punch_in::text, '09:00') AS punch_in, "
            f"COALESCE(be.punch_out::text, '18:00') AS punch_out, "
            f"COALESCE(be.hours_worked, 8.0) AS hours_worked, "
            f"COALESCE(be.ot_hours, 0.0) AS ot_hours, "
            f"be.device_log_id AS remarks "
            f"FROM master.ledgers l "
            f"LEFT JOIN master.ledger_groups lg ON lg.id = l.group_id "
            f"LEFT JOIN {schema}.biometric_entries be ON be.ledger_id = l.id AND be.entry_date = :edate "
            f"WHERE (l.ledger_type = 'Staff' OR lg.name LIKE '%Staff%' OR lg.name LIKE '%Salary%') AND l.is_active = TRUE "
            f"ORDER BY l.name ASC"
        ),
        {"edate": entry_date}
    )
    return [dict(r) for r in result.mappings().all()]


@router.post("/daily-bulk", status_code=200)
async def save_daily_staff_attendance_bulk(
    body: DailyAttendanceBulkIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    try:
        await db.execute(text(f"ALTER TABLE {schema}.biometric_entries ADD COLUMN IF NOT EXISTS ot_hours numeric(5,2) DEFAULT 0"))
    except Exception:
        pass

    for entry in body.entries:
        await db.execute(
            text(f"DELETE FROM {schema}.biometric_entries WHERE ledger_id = :lid AND entry_date = :edate"),
            {"lid": entry.ledger_id, "edate": body.entry_date}
        )
        # Parse time safely
        pin = entry.punch_in if entry.punch_in and len(entry.punch_in) == 5 else ("09:00" if entry.status in ["Present", "Half Day"] else None)
        pout = entry.punch_out if entry.punch_out and len(entry.punch_out) == 5 else ("18:00" if entry.status == "Present" else None)
        hw = entry.hours_worked if entry.status != "Absent" else 0.0
        
        await db.execute(
            text(
                f"INSERT INTO {schema}.biometric_entries "
                f"(ledger_id, entry_date, punch_in, punch_out, hours_worked, status, ot_hours, device_log_id) "
                f"VALUES (:lid, :edate, :pin::time, :pout::time, :hw, :status, :ot, :remarks)"
            ),
            {
                "lid": entry.ledger_id, "edate": body.entry_date,
                "pin": pin, "pout": pout,
                "hw": hw, "status": entry.status,
                "ot": entry.ot_hours or 0.0, "remarks": entry.remarks
            }
        )
    return {"message": f"Saved attendance for {len(body.entries)} staff members on {body.entry_date}"}
