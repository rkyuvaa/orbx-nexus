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
    freight_items: list[dict] | None = None


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
    freight_json = json.dumps(body.freight_items) if body.freight_items else "[]"
    result = await db.execute(
        text(
            f"INSERT INTO {schema}.labour_bills "
            f"(bill_no, bill_date, ledger_id, inward_id, product_id, process_id, quantity, rate, "
            f"amount, gst_percent, gst_amount, cgst_percent, cgst_amount, sgst_percent, sgst_amount, round_off, net_amount, total_amount, narration, items, outward_ids, dispatch_through, freight_items, created_by) "
            f"VALUES (:bno, :bdate, :lid, :iid, :pid, :prid, :qty, :rate, :amt, :gp, :ga, :cgp, :cga, :sgp, :sga, :ro, :namt, :ta, :narr, :items, :oids, :dt, :fright, :cby) "
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
            "narr": body.narration, "items": items_json, "oids": oids_json, "dt": body.dispatch_through, "fright": freight_json, "cby": current_user.id
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
    freight_json = json.dumps(body.freight_items) if body.freight_items else "[]"
    await db.execute(
        text(
            f"UPDATE {schema}.labour_bills SET bill_no=:bno, bill_date=:bdate, ledger_id=:lid, "
            f"inward_id=:iid, product_id=:pid, process_id=:prid, quantity=:qty, rate=:rate, "
            f"amount=:amt, gst_percent=:gp, gst_amount=:ga, "
            f"cgst_percent=:cgp, cgst_amount=:cga, sgst_percent=:sgp, sgst_amount=:sga, "
            f"round_off=:ro, net_amount=:namt, total_amount=:ta, narration=:narr, "
            f"items=:items, outward_ids=:oids, dispatch_through=:dt, freight_items=:fright, updated_at=NOW() WHERE id=:id"
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
            "narr": body.narration, "items": items_json, "oids": oids_json, "dt": body.dispatch_through, "fright": freight_json, "id": bill_id
        }
    )
    return {"message": "Updated"}


class LabourBillPaymentIn(BaseModel):
    payment_date: str
    payment_mode: str = "Bank Transfer"
    component: str = "PARTIAL" # "TAXABLE", "GST", "PARTIAL", "FULL"
    taxable_amount: float = 0
    gst_amount: float = 0
    tds_amount: float = 0
    net_paid_amount: float = 0
    notes: str | None = None


async def _ensure_payment_schema(db: DBSession, schema: str):
    try:
        await db.execute(text(f"""
            ALTER TABLE {schema}.labour_bills 
            ADD COLUMN IF NOT EXISTS paid_amount NUMERIC DEFAULT 0,
            ADD COLUMN IF NOT EXISTS pending_amount NUMERIC,
            ADD COLUMN IF NOT EXISTS taxable_paid BOOLEAN DEFAULT FALSE,
            ADD COLUMN IF NOT EXISTS gst_paid BOOLEAN DEFAULT FALSE,
            ADD COLUMN IF NOT EXISTS payment_status VARCHAR(20) DEFAULT 'UNPAID';
        """))

        await db.execute(text(f"""
            CREATE TABLE IF NOT EXISTS {schema}.labour_bill_payments (
                id SERIAL PRIMARY KEY,
                bill_id INTEGER NOT NULL REFERENCES {schema}.labour_bills(id) ON DELETE CASCADE,
                payment_date DATE NOT NULL,
                payment_mode VARCHAR(50) DEFAULT 'Bank Transfer',
                component VARCHAR(20) DEFAULT 'PARTIAL',
                taxable_amount NUMERIC DEFAULT 0,
                gst_amount NUMERIC DEFAULT 0,
                tds_amount NUMERIC DEFAULT 0,
                net_paid_amount NUMERIC DEFAULT 0,
                notes TEXT,
                created_at TIMESTAMP DEFAULT NOW()
            );
        """))
    except Exception as e:
        print("Error setting up payment schema:", e)


@router.patch("/{bill_id}/mark-paid")
async def mark_paid(
    bill_id: int, payment_date: str, current_user: CurrentUser,
    db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await _ensure_payment_schema(db, schema)
    await db.execute(
        text(
            f"UPDATE {schema}.labour_bills SET is_paid=TRUE, payment_status='PAID', payment_date=:pdate, updated_at=NOW() WHERE id=:id"
        ),
        {"pdate": payment_date, "id": bill_id}
    )
    return {"message": "Marked as paid"}


@router.post("/{bill_id}/record-payment")
async def record_bill_payment(
    bill_id: int,
    body: LabourBillPaymentIn,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await _ensure_payment_schema(db, schema)

    res = await db.execute(
        text(f"SELECT * FROM {schema}.labour_bills WHERE id = :id"),
        {"id": bill_id}
    )
    bill = res.mappings().first()
    if not bill:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="Labour bill not found")

    bill_dict = dict(bill)
    total_val = float(bill_dict.get("total_amount") or bill_dict.get("net_amount") or 0)
    current_paid = float(bill_dict.get("paid_amount") or 0)
    
    new_paid = current_paid + body.net_paid_amount
    new_pending = max(0.0, total_val - new_paid - body.tds_amount)

    taxable_val = float(bill_dict.get("amount") or total_val)
    gst_val = float(bill_dict.get("gst_amount") or 0)
    
    taxable_settled = bill_dict.get("taxable_paid") or (body.component in ("TAXABLE", "FULL")) or (new_paid >= taxable_val - body.tds_amount)
    gst_settled = bill_dict.get("gst_paid") or (body.component in ("GST", "FULL")) or (new_pending <= 1.0)
    
    status_str = "PAID" if (new_pending <= 1.0 or body.component == "FULL") else ("PARTIAL" if new_paid > 0 else "UNPAID")
    is_paid_bool = True if status_str == "PAID" else False

    await db.execute(
        text(f"""
            INSERT INTO {schema}.labour_bill_payments 
            (bill_id, payment_date, payment_mode, component, taxable_amount, gst_amount, tds_amount, net_paid_amount, notes)
            VALUES (:bid, :pdate, :pmode, :comp, :tamt, :gamt, :tds, :npamt, :notes)
        """),
        {
            "bid": bill_id,
            "pdate": body.payment_date,
            "pmode": body.payment_mode,
            "comp": body.component,
            "tamt": body.taxable_amount,
            "gamt": body.gst_amount,
            "tds": body.tds_amount,
            "npamt": body.net_paid_amount,
            "notes": body.notes,
        }
    )

    await db.execute(
        text(f"""
            UPDATE {schema}.labour_bills SET 
            paid_amount = :paid,
            pending_amount = :pending,
            taxable_paid = :tpaid,
            gst_paid = :gpaid,
            payment_status = :pstatus,
            is_paid = :ispaid,
            payment_date = :pdate,
            updated_at = NOW()
            WHERE id = :id
        """),
        {
            "paid": new_paid,
            "pending": new_pending,
            "tpaid": taxable_settled,
            "gpaid": gst_settled,
            "pstatus": status_str,
            "ispaid": is_paid_bool,
            "pdate": body.payment_date,
            "id": bill_id,
        }
    )
    return {"message": "Payment recorded successfully", "payment_status": status_str, "pending_amount": new_pending}


@router.get("/{bill_id}/payments")
async def list_bill_payments(
    bill_id: int,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await _ensure_payment_schema(db, schema)
    res = await db.execute(
        text(f"SELECT * FROM {schema}.labour_bill_payments WHERE bill_id = :bid ORDER BY payment_date DESC, id DESC"),
        {"bid": bill_id}
    )
    return [dict(r) for r in res.mappings().all()]


@router.delete("/{bill_id}", status_code=204)
async def delete_labour_bill(
    bill_id: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    await db.execute(
        text(f"DELETE FROM {s(fy)}.labour_bills WHERE id = :id"), {"id": bill_id}
    )
