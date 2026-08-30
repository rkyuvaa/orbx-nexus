from fastapi import APIRouter, HTTPException, Query
from sqlalchemy import text
from pydantic import BaseModel
from typing import Optional

from app.api.deps import CurrentUser, DBSession, get_fy_schema
from app.api.audit import log_audit_event

router = APIRouter()


class VoucherLineIn(BaseModel):
    ledger_id: int
    dr_amount: float = 0
    cr_amount: float = 0
    narration: str | None = None


class VoucherIn(BaseModel):
    voucher_no: str
    voucher_type: str  # Payment, Receipt, Contra, Journal, Purchase
    voucher_date: str  # YYYY-MM-DD
    ledger_id: int
    amount: float
    narration: str | None = None
    ref_no: str | None = None
    lines: list[VoucherLineIn] = []


class VoucherOut(BaseModel):
    id: int
    voucher_no: str
    voucher_type: str
    voucher_date: str
    ledger_id: int
    amount: float
    narration: str | None = None
    ref_no: str | None = None


@router.get("/")
async def list_vouchers(
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
    voucher_type: Optional[str] = Query(None),
    from_date: Optional[str] = Query(None),
    to_date: Optional[str] = Query(None),
    ledger_id: Optional[int] = Query(None),
):
    schema = f"fy_{fy}"
    conditions = ["1=1"]
    params: dict = {}
    if voucher_type:
        conditions.append("voucher_type = :vtype")
        params["vtype"] = voucher_type
    if from_date:
        conditions.append("voucher_date >= :fdate")
        params["fdate"] = from_date
    if to_date:
        conditions.append("voucher_date <= :tdate")
        params["tdate"] = to_date
    if ledger_id:
        conditions.append("ledger_id = :lid")
        params["lid"] = ledger_id

    where = " AND ".join(conditions)
    sql = text(
        f"SELECT id, voucher_no, voucher_type, voucher_date::text, ledger_id, amount, narration, ref_no "
        f"FROM {schema}.vouchers WHERE {where} ORDER BY voucher_date DESC, id DESC"
    )
    result = await db.execute(sql, params)
    rows = result.mappings().all()
    return [dict(r) for r in rows]


@router.get("/{voucher_id}")
async def get_voucher(
    voucher_id: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = f"fy_{fy}"
    result = await db.execute(
        text(f"SELECT * FROM {schema}.vouchers WHERE id = :id"), {"id": voucher_id}
    )
    row = result.mappings().one_or_none()
    if not row:
        raise HTTPException(status_code=404, detail="Voucher not found")
    lines_result = await db.execute(
        text(f"SELECT * FROM {schema}.voucher_lines WHERE voucher_id = :vid"), {"vid": voucher_id}
    )
    lines = [dict(l) for l in lines_result.mappings().all()]
    return {**dict(row), "lines": lines}


@router.post("/", status_code=201)
async def create_voucher(
    body: VoucherIn,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
):
    schema = f"fy_{fy}"
    vtype = body.voucher_type.lower().replace(" ", "_").replace(".", "")
    seq_type = f"voucher_{vtype}"
    from app.services.sequences import generate_and_increment_sequence
    voucher_no = body.voucher_no if (body.voucher_no and body.voucher_no.strip()) else await generate_and_increment_sequence(db, seq_type)
    
    result = await db.execute(
        text(
            f"INSERT INTO {schema}.vouchers (voucher_no, voucher_type, voucher_date, ledger_id, amount, narration, ref_no, created_by) "
            f"VALUES (:vno, :vtype, :vdate, :lid, :amt, :narr, :ref, :cby) RETURNING id"
        ),
        {
            "vno": voucher_no,
            "vtype": body.voucher_type,
            "vdate": body.voucher_date,
            "lid": body.ledger_id,
            "amt": body.amount,
            "narr": body.narration,
            "ref": body.ref_no,
            "cby": current_user.id,
        },
    )
    voucher_id = result.scalar_one()
    for line in body.lines:
        await db.execute(
            text(
                f"INSERT INTO {schema}.voucher_lines (voucher_id, ledger_id, dr_amount, cr_amount, narration) "
                f"VALUES (:vid, :lid, :dr, :cr, :narr)"
            ),
            {
                "vid": voucher_id,
                "lid": line.ledger_id,
                "dr": line.dr_amount,
                "cr": line.cr_amount,
                "narr": line.narration,
            },
        )

    await log_audit_event(
        db=db,
        user_id=current_user.id,
        username=current_user.username,
        action="CREATE",
        module="vouchers",
        record_id=voucher_id,
        fy=fy,
    )
    return {"id": voucher_id, "message": "Voucher created"}


@router.put("/{voucher_id}")
async def update_voucher(
    voucher_id: int,
    body: VoucherIn,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
):
    schema = f"fy_{fy}"
    await db.execute(
        text(
            f"UPDATE {schema}.vouchers SET voucher_no=:vno, voucher_type=:vtype, voucher_date=:vdate, "
            f"ledger_id=:lid, amount=:amt, narration=:narr, ref_no=:ref, updated_at=NOW() WHERE id=:id"
        ),
        {
            "vno": body.voucher_no,
            "vtype": body.voucher_type,
            "vdate": body.voucher_date,
            "lid": body.ledger_id,
            "amt": body.amount,
            "narr": body.narration,
            "ref": body.ref_no,
            "id": voucher_id,
        },
    )
    await db.execute(
        text(f"DELETE FROM {schema}.voucher_lines WHERE voucher_id = :vid"), {"vid": voucher_id}
    )
    for line in body.lines:
        await db.execute(
            text(
                f"INSERT INTO {schema}.voucher_lines (voucher_id, ledger_id, dr_amount, cr_amount, narration) "
                f"VALUES (:vid, :lid, :dr, :cr, :narr)"
            ),
            {"vid": voucher_id, "lid": line.ledger_id, "dr": line.dr_amount, "cr": line.cr_amount, "narr": line.narration},
        )
    await log_audit_event(
        db=db,
        user_id=current_user.id,
        username=current_user.username,
        action="UPDATE",
        module="vouchers",
        record_id=voucher_id,
        fy=fy,
    )
    return {"message": "Updated"}


@router.delete("/{voucher_id}", status_code=204)
async def delete_voucher(
    voucher_id: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = f"fy_{fy}"
    await db.execute(
        text(f"DELETE FROM {schema}.vouchers WHERE id = :id"), {"id": voucher_id}
    )
    await log_audit_event(
        db=db,
        user_id=current_user.id,
        username=current_user.username,
        action="DELETE",
        module="vouchers",
        record_id=voucher_id,
        fy=fy,
    )

