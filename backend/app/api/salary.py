import calendar
from fastapi import APIRouter, Query
from sqlalchemy import text
from pydantic import BaseModel
from typing import Optional

from app.api.deps import CurrentUser, DBSession

router = APIRouter()


def s(fy: str) -> str:
    return f"fy_{fy}"


class SalaryVoucherIn(BaseModel):
    voucher_no: str
    voucher_date: str
    ledger_id: int
    month: int
    year: int
    days_worked: float = 0
    basic_salary: float = 0
    per_day_salary: float = 0
    payable_amount: float = 0
    allowances: float = 0
    deductions: float = 0
    net_salary: float = 0
    narration: str | None = None


class AdvancePaymentIn(BaseModel):
    voucher_no: str
    voucher_date: str
    ledger_id: int
    payment_type: str  # Payment, Receipt
    ledger_type: str  # Staff, Contractor
    amount: float = 0
    narration: str | None = None


@router.get("/staff-attendance-stats")
async def get_staff_attendance_stats(
    current_user: CurrentUser, db: DBSession,
    ledger_id: int = Query(...),
    month: int = Query(...),
    year: int = Query(...),
    fy: str = Query(default="2026_2027")
):
    schema = s(fy)

    # Days in month
    try:
        _, days_in_month = calendar.monthrange(year, month)
    except Exception:
        days_in_month = 30

    # Ensure columns exist
    try:
        await db.execute(text("ALTER TABLE master.ledgers ADD COLUMN IF NOT EXISTS per_day_salary NUMERIC(15,2) DEFAULT 0"))
        await db.commit()
    except Exception:
        await db.rollback()

    # Query staff ledger details
    st_res = await db.execute(
        text("SELECT id, name, ledger_code, basic_salary, COALESCE(per_day_salary, 0) AS per_day_salary, hourly_rate, staff_category FROM master.ledgers WHERE id = :lid"),
        {"lid": ledger_id}
    )
    staff = st_res.mappings().first()
    if not staff:
        return {"error": "Staff member not found"}

    # Clean base name: strip " - (Staff Salary)", " - (Staff Advance)", etc.
    import re
    full_name = staff["name"] or ""
    clean_name = re.sub(r'[\s\-]*\((Staff|Contractor)[^\)]*\).*$', '', full_name, flags=re.IGNORECASE).strip()

    # Find all related ledger IDs for this staff member (e.g. Master record, Salary ledger, Advance ledger)
    rel_res = await db.execute(
        text("""
            SELECT id, name, basic_salary, per_day_salary, hourly_rate 
            FROM master.ledgers 
            WHERE id = :lid 
               OR TRIM(name) = :bname 
               OR TRIM(name) ILIKE :p1
               OR TRIM(name) ILIKE :p2
               OR TRIM(name) ILIKE :p3
        """),
        {
            "lid": ledger_id,
            "bname": clean_name,
            "p1": f"{clean_name} - (Staff%",
            "p2": f"{clean_name} (Staff%",
            "p3": f"{clean_name} - (Contractor%",
        }
    )
    rel_rows = rel_res.mappings().all()
    all_lids = list({r["id"] for r in rel_rows} | {ledger_id})

    # Query biometric entries for this staff in specified month/year across all linked ledger IDs
    att_res = await db.execute(
        text(
            f"SELECT "
            f"COUNT(*) FILTER (WHERE status ILIKE '%present%') AS present_days, "
            f"COUNT(*) FILTER (WHERE status ILIKE '%half%') AS half_days, "
            f"COUNT(*) FILTER (WHERE status ILIKE '%absent%') AS absent_days, "
            f"COUNT(*) FILTER (WHERE status ILIKE '%leave%') AS leave_days, "
            f"COALESCE(SUM(hours_worked), 0) AS total_hours, "
            f"COALESCE(SUM(ot_hours), 0) AS total_ot_hours "
            f"FROM {schema}.biometric_entries "
            f"WHERE ledger_id = ANY(:lids) "
            f"AND EXTRACT(MONTH FROM entry_date) = :m AND EXTRACT(YEAR FROM entry_date) = :y"
        ),
        {"lids": all_lids, "m": month, "y": year}
    )
    att = att_res.mappings().first()

    present_days = int(att["present_days"] or 0)
    half_days = int(att["half_days"] or 0)
    absent_days = int(att["absent_days"] or 0)
    leave_days = int(att["leave_days"] or 0)
    total_hours = float(att["total_hours"] or 0.0)
    total_ot_hours = float(att["total_ot_hours"] or 0.0)

    # Working days = Present + (0.5 * Half Day)
    working_days = round(present_days + (0.5 * half_days), 1)

    # Resolve per_day_salary and basic_salary across all related ledger records
    ledger_per_day = max([float(r["per_day_salary"] or 0) for r in rel_rows] + [float(staff["per_day_salary"] or 0), 0.0])
    basic_salary = max([float(r["basic_salary"] or 0) for r in rel_rows] + [float(staff["basic_salary"] or 0), 0.0])

    if ledger_per_day > 0:
        per_day_salary = round(ledger_per_day, 2)
    elif basic_salary > 0 and days_in_month > 0:
        per_day_salary = round(basic_salary / days_in_month, 2)
    else:
        per_day_salary = 0.0

    # Payable amount = working days * per day salary
    payable_amount = round(working_days * per_day_salary, 2)

    return {
        "ledger_id": ledger_id,
        "staff_name": staff["name"],
        "staff_code": staff["ledger_code"],
        "month": month,
        "year": year,
        "days_in_month": days_in_month,
        "present_days": present_days,
        "half_days": half_days,
        "absent_days": absent_days,
        "leave_days": leave_days,
        "working_days": working_days,
        "total_hours": total_hours,
        "total_ot_hours": total_ot_hours,
        "basic_salary": basic_salary,
        "per_day_salary": per_day_salary,
        "payable_amount": payable_amount
    }


@router.get("/salary")
async def list_salary_vouchers(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    ledger_id: Optional[int] = None, month: Optional[int] = None, year: Optional[int] = None
):
    schema = s(fy)
    try:
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS per_day_salary NUMERIC(15,2) DEFAULT 0"))
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS payable_amount NUMERIC(15,2) DEFAULT 0"))
        await db.commit()
    except Exception:
        await db.rollback()

    conds = ["1=1"]
    params: dict = {}
    if ledger_id:
        conds.append("sv.ledger_id = :lid")
        params["lid"] = ledger_id
    if month:
        conds.append("sv.month = :m")
        params["m"] = month
    if year:
        conds.append("sv.year = :y")
        params["y"] = year
    result = await db.execute(
        text(
            f"SELECT sv.*, l.name AS staff_name, l.ledger_code AS staff_code, "
            f"l.designation, l.department "
            f"FROM {schema}.salary_vouchers sv "
            f"LEFT JOIN master.ledgers l ON l.id = sv.ledger_id "
            f"WHERE {' AND '.join(conds)} ORDER BY sv.voucher_date DESC, sv.id DESC"
        ),
        params
    )
    return [dict(r) for r in result.mappings().all()]


@router.post("/salary", status_code=201)
async def create_salary_voucher(
    body: SalaryVoucherIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    try:
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS per_day_salary NUMERIC(15,2) DEFAULT 0"))
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS payable_amount NUMERIC(15,2) DEFAULT 0"))
        await db.commit()
    except Exception:
        await db.rollback()

    vno = body.voucher_no
    from app.services.sequences import generate_and_increment_sequence
    if not vno:
        vno = await generate_and_increment_sequence(db, "salary_voucher")
    else:
        await generate_and_increment_sequence(db, "salary_voucher")

    while True:
        chk = await db.execute(text(f"SELECT id FROM {schema}.salary_vouchers WHERE voucher_no = :vno"), {"vno": vno})
        if not chk.scalar_one_or_none():
            break
        vno = await generate_and_increment_sequence(db, "salary_voucher")

    payable = body.payable_amount if body.payable_amount else round(body.days_worked * body.per_day_salary, 2)
    net_sal = body.net_salary if body.net_salary else round(payable + body.allowances - body.deductions, 2)

    result = await db.execute(
        text(
            f"INSERT INTO {schema}.salary_vouchers "
            f"(voucher_no, voucher_date, ledger_id, month, year, days_worked, basic_salary, "
            f"per_day_salary, payable_amount, allowances, deductions, net_salary, narration, created_by) "
            f"VALUES (:vno, CAST(:vdate AS DATE), :lid, :m, :y, :dw, :bs, :pds, :pa, :al, :ded, :ns, :narr, :cby) RETURNING id"
        ),
        {
            "vno": vno, "vdate": body.voucher_date, "lid": body.ledger_id,
            "m": body.month, "y": body.year, "dw": body.days_worked,
            "bs": body.basic_salary, "pds": body.per_day_salary, "pa": payable,
            "al": body.allowances, "ded": body.deductions,
            "ns": net_sal, "narr": body.narration, "cby": current_user.id
        }
    )
    await db.commit()
    return {"id": result.scalar_one(), "voucher_no": vno, "message": "Salary voucher created"}


@router.put("/salary/{vid}")
async def update_salary_voucher(
    vid: int, body: SalaryVoucherIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    try:
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS per_day_salary NUMERIC(15,2) DEFAULT 0"))
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS payable_amount NUMERIC(15,2) DEFAULT 0"))
        await db.commit()
    except Exception:
        await db.rollback()

    payable = body.payable_amount if body.payable_amount else round(body.days_worked * body.per_day_salary, 2)
    net_sal = body.net_salary if body.net_salary else round(payable + body.allowances - body.deductions, 2)

    await db.execute(
        text(
            f"UPDATE {schema}.salary_vouchers "
            f"SET voucher_date = CAST(:vdate AS DATE), ledger_id = :lid, "
            f"month = :m, year = :y, days_worked = :dw, basic_salary = :bs, "
            f"per_day_salary = :pds, payable_amount = :pa, allowances = :al, "
            f"deductions = :ded, net_salary = :ns, narration = :narr, updated_at = NOW() "
            f"WHERE id = :id"
        ),
        {
            "vdate": body.voucher_date, "lid": body.ledger_id,
            "m": body.month, "y": body.year, "dw": body.days_worked,
            "bs": body.basic_salary, "pds": body.per_day_salary, "pa": payable,
            "al": body.allowances, "ded": body.deductions,
            "ns": net_sal, "narr": body.narration, "id": vid
        }
    )
    await db.commit()
    return {"message": "Salary voucher updated"}


@router.delete("/salary/{vid}", status_code=204)
async def delete_salary_voucher(
    vid: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    await db.execute(text(f"DELETE FROM {s(fy)}.salary_vouchers WHERE id = :id"), {"id": vid})
    await db.commit()


@router.get("/advances")
async def list_advances(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    ledger_type: Optional[str] = None, payment_type: Optional[str] = None,
    ledger_id: Optional[int] = None
):
    schema = s(fy)
    conds = ["1=1"]
    params: dict = {}
    if ledger_type:
        conds.append("ledger_type = :lt")
        params["lt"] = ledger_type
    if payment_type:
        conds.append("payment_type = :pt")
        params["pt"] = payment_type
    if ledger_id:
        conds.append("ledger_id = :lid")
        params["lid"] = ledger_id
    result = await db.execute(
        text(f"SELECT * FROM {schema}.advance_payments WHERE {' AND '.join(conds)} ORDER BY voucher_date DESC"),
        params
    )
    return [dict(r) for r in result.mappings().all()]


@router.post("/advances", status_code=201)
async def create_advance(
    body: AdvancePaymentIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    vno = body.voucher_no
    ltype = (body.ledger_type or "staff").lower()
    ptype = (body.payment_type or "payment").lower()
    seq_type = f"job_work_advance_{ptype}" if ltype == "contractor" else f"staff_advance_{ptype}"

    from app.services.sequences import generate_and_increment_sequence
    if not vno:
        vno = await generate_and_increment_sequence(db, seq_type)
    else:
        await generate_and_increment_sequence(db, seq_type)

    while True:
        chk = await db.execute(text(f"SELECT id FROM {schema}.advance_payments WHERE voucher_no = :vno"), {"vno": vno})
        if not chk.scalar_one_or_none():
            break
        vno = await generate_and_increment_sequence(db, seq_type)

    result = await db.execute(
        text(
            f"INSERT INTO {schema}.advance_payments "
            f"(voucher_no, voucher_date, ledger_id, payment_type, ledger_type, amount, narration, created_by) "
            f"VALUES (:vno, CAST(:vdate AS DATE), :lid, :pt, :lt, :amt, :narr, :cby) RETURNING id"
        ),
        {
            "vno": vno, "vdate": body.voucher_date, "lid": body.ledger_id,
            "pt": body.payment_type, "lt": body.ledger_type, "amt": body.amount,
            "narr": body.narration, "cby": current_user.id
        }
    )
    return {"id": result.scalar_one(), "message": "Advance entry created"}


@router.put("/advances/{vid}")
async def update_advance(
    vid: int, body: AdvancePaymentIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await db.execute(
        text(
            f"UPDATE {schema}.advance_payments "
            f"SET voucher_date = CAST(:vdate AS DATE), ledger_id = :lid, "
            f"amount = :amt, narration = :narr "
            f"WHERE id = :id"
        ),
        {
            "vdate": body.voucher_date, "lid": body.ledger_id,
            "amt": body.amount, "narr": body.narration, "id": vid
        }
    )
    return {"message": "Advance entry updated"}


@router.delete("/advances/{vid}", status_code=204)
async def delete_advance(
    vid: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    await db.execute(text(f"DELETE FROM {s(fy)}.advance_payments WHERE id = :id"), {"id": vid})

