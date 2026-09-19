from fastapi import APIRouter, Query, HTTPException
from sqlalchemy import text
from pydantic import BaseModel
from typing import Optional

from app.api.deps import CurrentUser, DBSession

router = APIRouter()


# ─── Payroll Config ────────────────────────────────────────────────────────────

class PayrollConfigIn(BaseModel):
    # Biometric machine
    device_name: Optional[str] = ""
    device_ip: Optional[str] = ""
    device_port: Optional[int] = 4370
    device_protocol: Optional[str] = "ZKTeco"
    auto_sync: Optional[bool] = False

    # Shift timings
    shift_name: Optional[str] = "General Shift"
    shift_start: Optional[str] = "09:00"
    shift_end: Optional[str] = "18:00"
    ot_after_hours: Optional[float] = 8.0
    grace_minutes: Optional[int] = 15

    # Week off: comma-separated day numbers (0=Sun, 1=Mon, ..., 6=Sat)
    week_off_days: Optional[str] = "0"

    # Working days per month (for per-day salary calc fallback)
    working_days_per_month: Optional[int] = 26


@router.get("")
@router.get("/")
async def get_payroll_config(current_user: CurrentUser, db: DBSession):
    """Fetch the single payroll configuration row."""
    await _ensure_tables(db)

    result = await db.execute(
        text("SELECT * FROM master.payroll_config ORDER BY id LIMIT 1")
    )
    row = result.mappings().first()
    if not row:
        return {
            "id": None,
            "device_name": "",
            "device_ip": "",
            "device_port": 4370,
            "device_protocol": "ZKTeco",
            "auto_sync": False,
            "shift_name": "General Shift",
            "shift_start": "09:00",
            "shift_end": "18:00",
            "ot_after_hours": 8.0,
            "grace_minutes": 15,
            "week_off_days": "0",
            "working_days_per_month": 26,
        }
    data = dict(row)
    # Normalize formats for frontend
    if data.get("shift_start") and len(str(data["shift_start"])) > 5:
        data["shift_start"] = str(data["shift_start"])[:5]
    if data.get("shift_end") and len(str(data["shift_end"])) > 5:
        data["shift_end"] = str(data["shift_end"])[:5]
    if data.get("ot_after_hours") is not None:
        data["ot_after_hours"] = float(data["ot_after_hours"])
    if data.get("week_off_days") is None:
        data["week_off_days"] = ""
    return data


@router.put("")
@router.put("/")
async def upsert_payroll_config(body: PayrollConfigIn, current_user: CurrentUser, db: DBSession):
    """Create or update the payroll configuration."""
    await _ensure_tables(db)

    try:
        result = await db.execute(text("SELECT id FROM master.payroll_config ORDER BY id LIMIT 1"))
        existing = result.scalar_one_or_none()

        data = body.model_dump()
        if existing:
            await db.execute(
                text("""
                    UPDATE master.payroll_config SET
                        device_name = :device_name,
                        device_ip = :device_ip,
                        device_port = :device_port,
                        device_protocol = :device_protocol,
                        auto_sync = :auto_sync,
                        shift_name = :shift_name,
                        shift_start = :shift_start,
                        shift_end = :shift_end,
                        ot_after_hours = :ot_after_hours,
                        grace_minutes = :grace_minutes,
                        week_off_days = :week_off_days,
                        working_days_per_month = :working_days_per_month,
                        updated_at = NOW()
                    WHERE id = :id
                """),
                {**data, "id": existing}
            )
        else:
            await db.execute(
                text("""
                    INSERT INTO master.payroll_config
                        (device_name, device_ip, device_port, device_protocol, auto_sync,
                         shift_name, shift_start, shift_end, ot_after_hours, grace_minutes,
                         week_off_days, working_days_per_month)
                    VALUES
                        (:device_name, :device_ip, :device_port, :device_protocol, :auto_sync,
                         :shift_name, :shift_start, :shift_end, :ot_after_hours, :grace_minutes,
                         :week_off_days, :working_days_per_month)
                """),
                data
            )
        await db.flush()
        return {"message": "Payroll configuration saved successfully"}
    except Exception as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=f"Failed to save payroll configuration: {str(e)}")


# ─── Holidays ──────────────────────────────────────────────────────────────────

class HolidayIn(BaseModel):
    holiday_date: str   # YYYY-MM-DD
    holiday_name: str
    description: Optional[str] = None


@router.get("/holidays")
async def list_holidays(current_user: CurrentUser, db: DBSession, year: Optional[int] = None):
    """List all holidays, optionally filtered by year."""
    await _ensure_tables(db)
    if year:
        result = await db.execute(
            text("SELECT id, holiday_date::text, holiday_name, description FROM master.payroll_holidays WHERE EXTRACT(YEAR FROM holiday_date) = :y ORDER BY holiday_date"),
            {"y": year}
        )
    else:
        result = await db.execute(
            text("SELECT id, holiday_date::text, holiday_name, description FROM master.payroll_holidays ORDER BY holiday_date")
        )
    return [dict(r) for r in result.mappings().all()]


@router.post("/holidays", status_code=201)
async def add_holiday(body: HolidayIn, current_user: CurrentUser, db: DBSession):
    """Add a new holiday."""
    await _ensure_tables(db)
    try:
        result = await db.execute(
            text("""
                INSERT INTO master.payroll_holidays (holiday_date, holiday_name, description)
                VALUES (CAST(:holiday_date AS date), :holiday_name, :description)
                RETURNING id, holiday_date::text, holiday_name, description
            """),
            body.model_dump()
        )
        await db.flush()
        return dict(result.mappings().first())
    except Exception as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=f"Failed to add holiday: {str(e)}")


@router.delete("/holidays/{holiday_id}", status_code=204)
async def delete_holiday(holiday_id: int, current_user: CurrentUser, db: DBSession):
    """Remove a holiday."""
    await _ensure_tables(db)
    await db.execute(
        text("DELETE FROM master.payroll_holidays WHERE id = :id"),
        {"id": holiday_id}
    )
    await db.flush()


# ─── Internal helper ───────────────────────────────────────────────────────────

async def _ensure_tables(db: DBSession):
    """Create payroll config tables if they do not exist yet."""
    try:
        await db.execute(text("""
            CREATE TABLE IF NOT EXISTS master.payroll_config (
                id SERIAL PRIMARY KEY,
                device_name VARCHAR(200),
                device_ip VARCHAR(100),
                device_port INTEGER DEFAULT 4370,
                device_protocol VARCHAR(50) DEFAULT 'ZKTeco',
                auto_sync BOOLEAN DEFAULT FALSE,
                shift_name VARCHAR(100) DEFAULT 'General Shift',
                shift_start VARCHAR(10) DEFAULT '09:00',
                shift_end VARCHAR(10) DEFAULT '18:00',
                ot_after_hours NUMERIC(5,2) DEFAULT 8.0,
                grace_minutes INTEGER DEFAULT 15,
                week_off_days VARCHAR(50) DEFAULT '0',
                working_days_per_month INTEGER DEFAULT 26,
                created_at TIMESTAMP DEFAULT NOW(),
                updated_at TIMESTAMP DEFAULT NOW()
            )
        """))
        await db.execute(text("""
            CREATE TABLE IF NOT EXISTS master.payroll_holidays (
                id SERIAL PRIMARY KEY,
                holiday_date DATE NOT NULL,
                holiday_name VARCHAR(200) NOT NULL,
                description TEXT,
                created_at TIMESTAMP DEFAULT NOW()
            )
        """))
        await db.flush()
    except Exception:
        pass
