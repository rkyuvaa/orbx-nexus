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


@router.get("/salary")
async def list_salary_vouchers(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    ledger_id: Optional[int] = None, month: Optional[int] = None, year: Optional[int] = None
):
    schema = s(fy)
    conds = ["1=1"]
    params: dict = {}
    if ledger_id:
        conds.append("ledger_id = :lid")
        params["lid"] = ledger_id
    if month:
        conds.append("month = :m")
        params["m"] = month
    if year:
        conds.append("year = :y")
        params["y"] = year
    result = await db.execute(
        text(f"SELECT * FROM {schema}.salary_vouchers WHERE {' AND '.join(conds)} ORDER BY voucher_date DESC"),
        params
    )
    return [dict(r) for r in result.mappings().all()]


@router.post("/salary", status_code=201)
async def create_salary_voucher(
    body: SalaryVoucherIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"INSERT INTO {schema}.salary_vouchers "
            f"(voucher_no, voucher_date, ledger_id, month, year, days_worked, basic_salary, "
            f"allowances, deductions, net_salary, narration, created_by) "
            f"VALUES (:vno, :vdate, :lid, :m, :y, :dw, :bs, :al, :ded, :ns, :narr, :cby) RETURNING id"
        ),
        {
            "vno": body.voucher_no, "vdate": body.voucher_date, "lid": body.ledger_id,
            "m": body.month, "y": body.year, "dw": body.days_worked,
            "bs": body.basic_salary, "al": body.allowances, "ded": body.deductions,
            "ns": body.net_salary, "narr": body.narration, "cby": current_user.id
        }
    )
    return {"id": result.scalar_one(), "message": "Salary voucher created"}


@router.delete("/salary/{vid}", status_code=204)
async def delete_salary_voucher(
    vid: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    await db.execute(text(f"DELETE FROM {s(fy)}.salary_vouchers WHERE id = :id"), {"id": vid})


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

