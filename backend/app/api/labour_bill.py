from fastapi import APIRouter, Query
from sqlalchemy import text
from pydantic import BaseModel
from typing import Optional

from app.api.deps import CurrentUser, DBSession

router = APIRouter()


class LabourBillIn(BaseModel):
    bill_no: str
    bill_date: str
    ledger_id: int
    inward_id: int | None = None
    product_id: int | None = None
    process_id: int | None = None
    quantity: float = 0
    rate: float = 0
    amount: float = 0
    gst_percent: float = 0
    gst_amount: float = 0
    cgst_percent: float = 0
    cgst_amount: float = 0
    sgst_percent: float = 0
    sgst_amount: float = 0
    round_off: float = 0
    net_amount: float = 0
    total_amount: float = 0
    narration: str | None = None
    items: list[dict] | None = None
    outward_ids: list[int] | None = None
    dispatch_through: str | None = None


def s(fy: str) -> str:
    return f"fy_{fy}"


@router.get("/")
async def list_labour_bills(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    from_date: Optional[str] = None, to_date: Optional[str] = None,
    ledger_id: Optional[int] = None, is_paid: Optional[bool] = None
):
    schema = s(fy)
    conds = ["1=1"]
    params: dict = {}
    if from_date:
        conds.append("bill_date >= :fd")
        params["fd"] = from_date
    if to_date:
        conds.append("bill_date <= :td")
        params["td"] = to_date
    if ledger_id:
        conds.append("ledger_id = :lid")
        params["lid"] = ledger_id
    if is_paid is not None:
        conds.append("is_paid = :ip")
        params["ip"] = is_paid
    result = await db.execute(
        text(f"SELECT * FROM {schema}.labour_bills WHERE {' AND '.join(conds)} ORDER BY bill_date DESC"),
        params
    )
    return [dict(r) for r in result.mappings().all()]


@router.post("/", status_code=201)
async def create_labour_bill(
    body: LabourBillIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    from app.services.sequences import generate_and_increment_sequence
    bill_no = await generate_and_increment_sequence(db, "labour_bill")
    import json
    items_json = json.dumps(body.items) if body.items else "[]"
    oids_json = json.dumps(body.outward_ids) if body.outward_ids else "[]"
    result = await db.execute(
        text(
            f"INSERT INTO {schema}.labour_bills "
            f"(bill_no, bill_date, ledger_id, inward_id, product_id, process_id, quantity, rate, "
            f"amount, gst_percent, gst_amount, cgst_percent, cgst_amount, sgst_percent, sgst_amount, round_off, net_amount, total_amount, narration, items, outward_ids, dispatch_through, created_by) "
            f"VALUES (:bno, :bdate, :lid, :iid, :pid, :prid, :qty, :rate, :amt, :gp, :ga, :cgp, :cga, :sgp, :sga, :ro, :namt, :ta, :narr, :items, :oids, :dt, :cby) "
            f"RETURNING id"
        ),
        {
            "bno": bill_no, "bdate": body.bill_date, "lid": body.ledger_id,
            "iid": body.inward_id, "pid": body.product_id, "prid": body.process_id,
            "qty": body.quantity, "rate": body.rate, "amt": body.amount,
            "gp": body.gst_percent, "ga": body.gst_amount,
            "cgp": body.cgst_percent, "cga": body.cgst_amount,
            "sgp": body.sgst_percent, "sga": body.sgst_amount,
            "ro": body.round_off, "namt": body.net_amount or body.total_amount,
            "ta": body.total_amount,
            "narr": body.narration, "items": items_json, "oids": oids_json, "dt": body.dispatch_through, "cby": current_user.id
        }
    )
    return {"id": result.scalar_one(), "message": "Labour bill created"}


@router.put("/{bill_id}")
async def update_labour_bill(
    bill_id: int, body: LabourBillIn, current_user: CurrentUser,
    db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    import json
    items_json = json.dumps(body.items) if body.items else "[]"
    oids_json = json.dumps(body.outward_ids) if body.outward_ids else "[]"
    await db.execute(
        text(
            f"UPDATE {schema}.labour_bills SET bill_no=:bno, bill_date=:bdate, ledger_id=:lid, "
            f"inward_id=:iid, product_id=:pid, process_id=:prid, quantity=:qty, rate=:rate, "
            f"amount=:amt, gst_percent=:gp, gst_amount=:ga, "
            f"cgst_percent=:cgp, cgst_amount=:cga, sgst_percent=:sgp, sgst_amount=:sga, "
            f"round_off=:ro, net_amount=:namt, total_amount=:ta, narration=:narr, "
            f"items=:items, outward_ids=:oids, dispatch_through=:dt, updated_at=NOW() WHERE id=:id"
        ),
        {
            "bno": body.bill_no, "bdate": body.bill_date, "lid": body.ledger_id,
            "iid": body.inward_id, "pid": body.product_id, "prid": body.process_id,
            "qty": body.quantity, "rate": body.rate, "amt": body.amount,
            "gp": body.gst_percent, "ga": body.gst_amount,
            "cgp": body.cgst_percent, "cga": body.cgst_amount,
            "sgp": body.sgst_percent, "sga": body.sgst_amount,
            "ro": body.round_off, "namt": body.net_amount or body.total_amount,
            "ta": body.total_amount,
            "narr": body.narration, "items": items_json, "oids": oids_json, "dt": body.dispatch_through, "id": bill_id
        }
    )
    return {"message": "Updated"}


@router.patch("/{bill_id}/mark-paid")
async def mark_paid(
    bill_id: int, payment_date: str, current_user: CurrentUser,
    db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await db.execute(
        text(
            f"UPDATE {schema}.labour_bills SET is_paid=TRUE, payment_date=:pdate, updated_at=NOW() WHERE id=:id"
        ),
        {"pdate": payment_date, "id": bill_id}
    )
    return {"message": "Marked as paid"}


@router.delete("/{bill_id}", status_code=204)
async def delete_labour_bill(
    bill_id: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    await db.execute(
        text(f"DELETE FROM {s(fy)}.labour_bills WHERE id = :id"), {"id": bill_id}
    )
