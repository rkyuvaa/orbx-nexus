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
    pay_period_type: Optional[str] = "Monthly"
    from_date: Optional[str] = None
    to_date: Optional[str] = None
    pay_type: Optional[str] = "Daily"
    days_worked: float = 0
    total_hours: float = 0
    hourly_rate: float = 0
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
    from_date: Optional[str] = Query(default=None),
    to_date: Optional[str] = Query(default=None),
    pay_period_type: Optional[str] = Query(default="Monthly"),
    fy: str = Query(default="2026_2027")
):
    schema = s(fy)

    # Days in month / period
    try:
        _, days_in_month = calendar.monthrange(year, month)
    except Exception:
        days_in_month = 30

    is_weekly = pay_period_type == "Weekly" or bool(from_date and to_date)
    days_in_period = days_in_month
    if from_date and to_date:
        try:
            from datetime import datetime
            fd_obj = datetime.strptime(str(from_date)[:10], "%Y-%m-%d").date()
            td_obj = datetime.strptime(str(to_date)[:10], "%Y-%m-%d").date()
            days_in_period = max(1, (td_obj - fd_obj).days + 1)
        except Exception:
            days_in_period = 7 if is_weekly else days_in_month

    # Ensure columns exist
    try:
        await db.execute(text("ALTER TABLE master.ledgers ADD COLUMN IF NOT EXISTS per_day_salary NUMERIC(15,2) DEFAULT 0"))
        await db.execute(text("ALTER TABLE master.ledgers ADD COLUMN IF NOT EXISTS hourly_rate NUMERIC(15,2) DEFAULT 0"))
        await db.execute(text("ALTER TABLE master.ledgers ADD COLUMN IF NOT EXISTS staff_category VARCHAR(20) DEFAULT 'Staff'"))
        await db.commit()
    except Exception:
        await db.rollback()

    # Query staff ledger details
    st_res = await db.execute(
        text("SELECT id, name, ledger_code, basic_salary, COALESCE(per_day_salary, 0) AS per_day_salary, COALESCE(hourly_rate, 0) AS hourly_rate, staff_category FROM master.ledgers WHERE id = :lid"),
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
            SELECT id, name, basic_salary, per_day_salary, hourly_rate, staff_category 
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

    # Query advance payments and previous salary voucher deductions to calculate outstanding advance
    adv_res = await db.execute(
        text(
            f"SELECT "
            f"COALESCE(SUM(CASE WHEN payment_type = 'Payment' THEN amount ELSE 0 END), 0) AS advance_paid, "
            f"COALESCE(SUM(CASE WHEN payment_type = 'Receipt' THEN amount ELSE 0 END), 0) AS advance_received "
            f"FROM {schema}.advance_payments "
            f"WHERE ledger_id = ANY(:lids) AND ledger_type = 'Staff'"
        ),
        {"lids": all_lids}
    )
    adv_data = adv_res.mappings().first() or {"advance_paid": 0, "advance_received": 0}
    tot_adv_paid = float(adv_data["advance_paid"] or 0)
    tot_adv_rec = float(adv_data["advance_received"] or 0)

    ded_res = await db.execute(
        text(
            f"SELECT COALESCE(SUM(deductions), 0) AS total_deductions "
            f"FROM {schema}.salary_vouchers "
            f"WHERE ledger_id = ANY(:lids)"
        ),
        {"lids": all_lids}
    )
    tot_ded = float((ded_res.mappings().first() or {}).get("total_deductions") or 0)
    outstanding_advance = max(0.0, round(tot_adv_paid - tot_adv_rec - tot_ded, 2))

    # Query biometric entries for this staff in specified date range or month/year across all linked ledger IDs
    if from_date and to_date:
        date_cond = "AND entry_date >= CAST(:fdate AS DATE) AND entry_date <= CAST(:tdate AS DATE)"
        date_params = {"fdate": str(from_date)[:10], "tdate": str(to_date)[:10]}
    else:
        date_cond = "AND EXTRACT(MONTH FROM entry_date) = :m AND EXTRACT(YEAR FROM entry_date) = :y"
        date_params = {"m": month, "y": year}

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
            f"WHERE ledger_id = ANY(:lids) {date_cond}"
        ),
        {"lids": all_lids, **date_params}
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

    # Resolve per_day_salary, basic_salary, hourly_rate, and staff_category across all related ledger records
    ledger_per_day = max([float(r.get("per_day_salary") or 0) for r in rel_rows] + [float(staff.get("per_day_salary") or 0), 0.0])
    basic_salary = max([float(r.get("basic_salary") or 0) for r in rel_rows] + [float(staff.get("basic_salary") or 0), 0.0])
    hourly_rate = max([float(r.get("hourly_rate") or 0) for r in rel_rows] + [float(staff.get("hourly_rate") or 0), 0.0])

    staff_category = staff.get("staff_category") or "Staff"
    for r in rel_rows:
        if r.get("staff_category") == "Labour":
            staff_category = "Labour"

    is_hourly = staff_category == "Labour" or (hourly_rate > 0 and ledger_per_day == 0 and basic_salary == 0)

    if is_hourly:
        payable_amount = round(total_hours * hourly_rate, 2)
        per_day_salary = 0.0
    else:
        if ledger_per_day > 0:
            per_day_salary = round(ledger_per_day, 2)
        elif basic_salary > 0 and days_in_month > 0:
            per_day_salary = round(basic_salary / days_in_month, 2)
        else:
            per_day_salary = 0.0
        payable_amount = round(working_days * per_day_salary, 2)

    return {
        "ledger_id": ledger_id,
        "staff_name": staff["name"],
        "staff_code": staff["ledger_code"],
        "staff_category": staff_category,
        "is_hourly": is_hourly,
        "pay_type": "Hourly" if is_hourly else "Daily",
        "pay_period_type": "Weekly" if is_weekly else "Monthly",
        "from_date": from_date,
        "to_date": to_date,
        "days_in_period": days_in_period,
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
        "hourly_rate": hourly_rate,
        "payable_amount": payable_amount,
        "advance_balance": outstanding_advance,
        "advance_paid": tot_adv_paid,
        "advance_received": tot_adv_rec,
        "advance_deducted": tot_ded
    }


async def ensure_salary_voucher_columns(db: DBSession, schema: str):
    try:
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS per_day_salary NUMERIC(15,2) DEFAULT 0"))
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS payable_amount NUMERIC(15,2) DEFAULT 0"))
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS total_hours NUMERIC(15,2) DEFAULT 0"))
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS hourly_rate NUMERIC(15,2) DEFAULT 0"))
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS pay_type VARCHAR(20) DEFAULT 'Daily'"))
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS pay_period_type VARCHAR(20) DEFAULT 'Monthly'"))
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS from_date DATE"))
        await db.execute(text(f"ALTER TABLE {schema}.salary_vouchers ADD COLUMN IF NOT EXISTS to_date DATE"))
        await db.commit()
    except Exception:
        await db.rollback()


@router.get("/salary")
async def list_salary_vouchers(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    ledger_id: Optional[int] = None, month: Optional[int] = None, year: Optional[int] = None
):
    schema = s(fy)
    await ensure_salary_voucher_columns(db, schema)

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
    await ensure_salary_voucher_columns(db, schema)

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

    pay_type = body.pay_type or ("Hourly" if body.hourly_rate > 0 and body.total_hours > 0 and body.per_day_salary == 0 else "Daily")
    if pay_type == "Hourly":
        payable = body.payable_amount if body.payable_amount else round(body.total_hours * body.hourly_rate, 2)
    else:
        payable = body.payable_amount if body.payable_amount else round(body.days_worked * body.per_day_salary, 2)

    net_sal = body.net_salary if body.net_salary else round(payable + body.allowances - body.deductions, 2)

    result = await db.execute(
        text(
            f"INSERT INTO {schema}.salary_vouchers "
            f"(voucher_no, voucher_date, ledger_id, month, year, pay_period_type, from_date, to_date, pay_type, days_worked, total_hours, hourly_rate, basic_salary, "
            f"per_day_salary, payable_amount, allowances, deductions, net_salary, narration, created_by) "
            f"VALUES (:vno, CAST(:vdate AS DATE), :lid, :m, :y, :ppt, CAST(:fdate AS DATE), CAST(:tdate AS DATE), :pt, :dw, :th, :hr, :bs, :pds, :pa, :al, :ded, :ns, :narr, :cby) RETURNING id"
        ),
        {
            "vno": vno, "vdate": body.voucher_date, "lid": body.ledger_id,
            "m": body.month, "y": body.year,
            "ppt": body.pay_period_type or "Monthly",
            "fdate": body.from_date, "tdate": body.to_date,
            "pt": pay_type, "dw": body.days_worked,
            "th": body.total_hours, "hr": body.hourly_rate,
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
    await ensure_salary_voucher_columns(db, schema)

    pay_type = body.pay_type or ("Hourly" if body.hourly_rate > 0 and body.total_hours > 0 and body.per_day_salary == 0 else "Daily")
    if pay_type == "Hourly":
        payable = body.payable_amount if body.payable_amount else round(body.total_hours * body.hourly_rate, 2)
    else:
        payable = body.payable_amount if body.payable_amount else round(body.days_worked * body.per_day_salary, 2)

    net_sal = body.net_salary if body.net_salary else round(payable + body.allowances - body.deductions, 2)

    await db.execute(
        text(
            f"UPDATE {schema}.salary_vouchers "
            f"SET voucher_date = CAST(:vdate AS DATE), ledger_id = :lid, "
            f"month = :m, year = :y, pay_period_type = :ppt, "
            f"from_date = CAST(:fdate AS DATE), to_date = CAST(:tdate AS DATE), "
            f"pay_type = :pt, days_worked = :dw, "
            f"total_hours = :th, hourly_rate = :hr, basic_salary = :bs, "
            f"per_day_salary = :pds, payable_amount = :pa, allowances = :al, "
            f"deductions = :ded, net_salary = :ns, narration = :narr, updated_at = NOW() "
            f"WHERE id = :id"
        ),
        {
            "vdate": body.voucher_date, "lid": body.ledger_id,
            "m": body.month, "y": body.year,
            "ppt": body.pay_period_type or "Monthly",
            "fdate": body.from_date, "tdate": body.to_date,
            "pt": pay_type, "dw": body.days_worked,
            "th": body.total_hours, "hr": body.hourly_rate,
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
        conds.append("ap.ledger_type = :lt")
        params["lt"] = ledger_type
    if payment_type:
        conds.append("ap.payment_type = :pt")
        params["pt"] = payment_type
    if ledger_id:
        conds.append("ap.ledger_id = :lid")
        params["lid"] = ledger_id
    query = f"""
        SELECT 
            ap.*,
            l.name AS ledger_name,
            l.name AS staff_name,
            l.ledger_code,
            l.ledger_code AS staff_code,
            l.designation,
            l.department
        FROM {schema}.advance_payments ap
        LEFT JOIN master.ledgers l ON l.id = ap.ledger_id
        WHERE {' AND '.join(conds)}
        ORDER BY ap.voucher_date DESC, ap.id DESC
    """
    result = await db.execute(text(query), params)
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
    await db.commit()
    return {"id": result.scalar_one(), "voucher_no": vno, "message": "Advance entry created"}


@router.put("/advances/{vid}")
async def update_advance(
    vid: int, body: AdvancePaymentIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await db.execute(
        text(
            f"UPDATE {schema}.advance_payments "
            f"SET voucher_date = CAST(:vdate AS DATE), ledger_id = :lid, "
            f"amount = :amt, narration = :narr, updated_at = NOW() "
            f"WHERE id = :id"
        ),
        {
            "vdate": body.voucher_date, "lid": body.ledger_id,
            "amt": body.amount, "narr": body.narration, "id": vid
        }
    )
    await db.commit()
    return {"message": "Advance entry updated"}


@router.delete("/advances/{vid}", status_code=204)
async def delete_advance(
    vid: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    await db.execute(text(f"DELETE FROM {s(fy)}.advance_payments WHERE id = :id"), {"id": vid})
    await db.commit()


@router.get("/balance-summary")
async def staff_balance_summary(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    """
    Returns one consolidated row per active Staff ledger with:
      - opening_balance / balance_type
      - advance_paid      (Advance Payment entries)
      - advance_received  (Advance Receipt entries)
      - salary_payable    (Total gross payable from Salary Vouchers)
      - salary_deductions (Total deductions / advances recovered from Salary Vouchers)
      - net_salary        (Total net salary from Salary Vouchers)
      - advance_balance   = advance_paid - advance_received - salary_deductions
      - current_balance   = Net balance between company and staff
    """
    schema = s(fy)
    query = f"""
    SELECT
        l.id AS ledger_id,
        l.name AS staff_name,
        l.ledger_code AS staff_code,
        l.designation,
        l.department,
        l.staff_category,
        COALESCE(l.basic_salary, 0) AS basic_salary,
        COALESCE(l.per_day_salary, 0) AS per_day_salary,
        COALESCE(l.hourly_rate, 0) AS hourly_rate,
        COALESCE(l.opening_balance, 0) AS opening_balance,
        COALESCE(l.balance_type, 'Dr') AS balance_type,
        COALESCE(ap.advance_paid, 0) AS advance_paid,
        COALESCE(ap.advance_received, 0) AS advance_received,
        COALESCE(sv.salary_payable, 0) AS salary_payable,
        COALESCE(sv.salary_deductions, 0) AS salary_deductions,
        COALESCE(sv.net_salary, 0) AS net_salary,
        (
            COALESCE(ap.advance_paid, 0)
            - COALESCE(ap.advance_received, 0)
            - COALESCE(sv.salary_deductions, 0)
        ) AS advance_balance,
        (
            (CASE WHEN l.balance_type = 'Cr' THEN COALESCE(l.opening_balance, 0) ELSE -COALESCE(l.opening_balance, 0) END)
            + COALESCE(sv.net_salary, 0)
            - (COALESCE(ap.advance_paid, 0) - COALESCE(ap.advance_received, 0) - COALESCE(sv.salary_deductions, 0))
        ) AS current_balance
    FROM master.ledgers l
    LEFT JOIN master.ledger_groups lg ON lg.id = l.group_id
    LEFT JOIN LATERAL (
        SELECT
            SUM(CASE WHEN payment_type = 'Payment' THEN amount ELSE 0 END) AS advance_paid,
            SUM(CASE WHEN payment_type = 'Receipt' THEN amount ELSE 0 END) AS advance_received
        FROM {schema}.advance_payments
        WHERE (ledger_id = l.id OR ledger_id IN (
            SELECT id FROM master.ledgers WHERE TRIM(name) = TRIM(l.name) OR TRIM(name) ILIKE TRIM(l.name) || ' - (Staff%'
        )) AND ledger_type = 'Staff'
    ) ap ON TRUE
    LEFT JOIN LATERAL (
        SELECT
            SUM(COALESCE(payable_amount, 0)) AS salary_payable,
            SUM(COALESCE(deductions, 0)) AS salary_deductions,
            SUM(COALESCE(net_salary, 0)) AS net_salary
        FROM {schema}.salary_vouchers
        WHERE (ledger_id = l.id OR ledger_id IN (
            SELECT id FROM master.ledgers WHERE TRIM(name) = TRIM(l.name) OR TRIM(name) ILIKE TRIM(l.name) || ' - (Staff%'
        ))
    ) sv ON TRUE
    WHERE (l.ledger_type = 'Staff' OR lg.name LIKE '%Staff%' OR lg.name LIKE '%Salary%' OR l.name LIKE '%(Staff%')
      AND (l.is_active = TRUE OR l.is_active IS NULL)
      AND l.name NOT ILIKE '%(Staff Advance)%'
      AND l.name NOT ILIKE '%(Contractor Advance)%'
    ORDER BY l.name
    """
    result = await db.execute(text(query))
    rows = []
    for r in result.mappings().all():
        row = dict(r)
        row["opening_balance"]   = float(row["opening_balance"]   or 0)
        row["advance_paid"]      = float(row["advance_paid"]      or 0)
        row["advance_received"]  = float(row["advance_received"]  or 0)
        row["salary_payable"]    = float(row["salary_payable"]    or 0)
        row["salary_deductions"] = float(row["salary_deductions"] or 0)
        row["net_salary"]        = float(row["net_salary"]        or 0)
        row["advance_balance"]   = float(row["advance_balance"]   or 0)
        row["current_balance"]   = float(row["current_balance"]   or 0)
        rows.append(row)
    return rows


@router.get("/transactions")
async def staff_transactions(
    current_user: CurrentUser, db: DBSession, ledger_id: int = Query(...), fy: str = Query(default="2026_2027")
):
    """
    Returns unified chronological transaction records (Opening Balance, Advance Payments, Advance Receipts, Salary Vouchers)
    with running balance for a given staff member.
    """
    schema = s(fy)

    # 0. Fetch Ledger Opening Balance & name
    l_res = await db.execute(
        text("SELECT id, name, ledger_code, opening_balance, balance_type FROM master.ledgers WHERE id = :lid"),
        {"lid": ledger_id}
    )
    l_row = l_res.mappings().first()
    if not l_row:
        return []
    ob_val = float(l_row.get("opening_balance") or 0)
    ob_type = l_row.get("balance_type") or "Dr"

    # Find all related ledger IDs
    import re
    full_name = l_row["name"] or ""
    clean_name = re.sub(r'[\s\-]*\((Staff|Contractor)[^\)]*\).*$', '', full_name, flags=re.IGNORECASE).strip()
    rel_res = await db.execute(
        text("""
            SELECT id FROM master.ledgers 
            WHERE id = :lid 
               OR TRIM(name) = :bname 
               OR TRIM(name) ILIKE :p1
               OR TRIM(name) ILIKE :p2
        """),
        {"lid": ledger_id, "bname": clean_name, "p1": f"{clean_name} - (Staff%", "p2": f"{clean_name} (Staff%"}
    )
    all_lids = list({r["id"] for r in rel_res.mappings().all()} | {ledger_id})

    # 1. Fetch Advance entries (Payment = Dr [Cash to staff], Receipt = Cr [Repaid by staff])
    adv_query = f"""
    SELECT 
        a.id,
        a.voucher_no AS doc_no,
        a.voucher_date::text AS date,
        a.created_at::text AS created_at,
        CASE WHEN a.payment_type = 'Payment' THEN 'Advance Payment' ELSE 'Advance Receipt' END AS category,
        a.amount,
        a.narration,
        CASE WHEN a.payment_type = 'Payment' THEN 'Dr' ELSE 'Cr' END AS dr_cr
    FROM {schema}.advance_payments a
    WHERE a.ledger_id = ANY(:lids) AND a.ledger_type = 'Staff'
    """
    adv_res = await db.execute(text(adv_query), {"lids": all_lids})
    adv_rows = []
    for r in adv_res.mappings().all():
        row = dict(r)
        row["amount"] = float(row["amount"] or 0)
        row["created_at"] = row["created_at"] or ""
        adv_rows.append(row)

    # 2. Fetch Salary Vouchers (Net Salary Payable = Cr [Liability to staff], Deductions = Dr [Advance settled])
    sal_query = f"""
    SELECT
        s.id,
        s.voucher_no AS doc_no,
        s.voucher_date::text AS date,
        s.created_at::text AS created_at,
        'Salary Voucher' AS category,
        COALESCE(s.net_salary, 0) AS amount,
        COALESCE(s.deductions, 0) AS deductions,
        COALESCE(s.payable_amount, 0) AS gross_payable,
        s.narration,
        'Cr' AS dr_cr
    FROM {schema}.salary_vouchers s
    WHERE s.ledger_id = ANY(:lids)
    """
    sal_res = await db.execute(text(sal_query), {"lids": all_lids})
    sal_rows = []
    for r in sal_res.mappings().all():
        row = dict(r)
        row["amount"] = float(row["amount"] or 0)
        row["created_at"] = row["created_at"] or ""
        sal_rows.append(row)

    # Sort ASC chronologically
    all_txs = sorted(adv_rows + sal_rows, key=lambda x: (x["date"], x["created_at"], x["id"]))

    # Initial balance: Cr is company liability (+), Dr is staff debt / advance (-)
    running_bal = ob_val if ob_type == "Cr" else -ob_val
    tx_list = []

    if ob_val > 0:
        tx_list.append({
            "id": 0,
            "date": "-",
            "doc_no": "OPENING",
            "category": "Opening Balance",
            "amount": ob_val,
            "dr_cr": ob_type,
            "narration": "Opening Balance",
            "running_balance": running_bal,
            "bal_type": "Cr" if running_bal >= 0 else "Dr"
        })

    for tx in all_txs:
        # Cr increases company liability to staff (+), Dr decreases it / staff owes company (-)
        if tx["dr_cr"] == "Cr":
            running_bal += tx["amount"]
        else:
            running_bal -= tx["amount"]

        tx_list.append({
            **tx,
            "running_balance": running_bal,
            "bal_type": "Cr" if running_bal >= 0 else "Dr"
        })

    return tx_list

