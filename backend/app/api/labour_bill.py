from fastapi import APIRouter, Query, HTTPException
from sqlalchemy import text
from pydantic import BaseModel
from typing import Optional
import json

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


async def _validate_inwards_completed(
    db: DBSession, schema: str, inward_id: Optional[int], outward_ids: Optional[list[int]]
):
    inward_ids_to_check: set[int] = set()
    if inward_id:
        inward_ids_to_check.add(inward_id)

    if outward_ids and len(outward_ids) > 0:
        res = await db.execute(
            text(
                f"SELECT inward_id, inward_ids, items FROM {schema}.stock_outward "
                f"WHERE id = ANY(:oids)"
            ),
            {"oids": list(outward_ids)},
        )
        for row in res.mappings().all():
            if row.get("inward_id"):
                inward_ids_to_check.add(row["inward_id"])
            raw_iids = row.get("inward_ids")
            if raw_iids:
                if isinstance(raw_iids, list):
                    for i in raw_iids:
                        if isinstance(i, int):
                            inward_ids_to_check.add(i)
                elif isinstance(raw_iids, str):
                    try:
                        parsed = json.loads(raw_iids)
                        if isinstance(parsed, list):
                            for i in parsed:
                                if isinstance(i, int):
                                    inward_ids_to_check.add(i)
                    except Exception:
                        pass
            items = row.get("items")
            if items:
                if isinstance(items, list):
                    for it in items:
                        if isinstance(it, dict) and it.get("inward_id"):
                            try:
                                inward_ids_to_check.add(int(it["inward_id"]))
                            except Exception:
                                pass
                elif isinstance(items, str):
                    try:
                        parsed = json.loads(items)
                        if isinstance(parsed, list):
                            for it in parsed:
                                if isinstance(it, dict) and it.get("inward_id"):
                                    inward_ids_to_check.add(int(it["inward_id"]))
                    except Exception:
                        pass

    if not inward_ids_to_check:
        return

    for inw_id in inward_ids_to_check:
        inw_res = await db.execute(
            text(f"SELECT * FROM {schema}.stock_inward WHERE id = :id"),
            {"id": inw_id},
        )
        inw_row = inw_res.mappings().first()
        if not inw_row:
            continue
        inward_no = inw_row.get("inward_no") or f"#{inw_id}"

        # Calculate live balance quantity for this inward
        bal_res = await db.execute(
            text(f"""
            WITH i_lines AS (
              SELECT si.id AS inward_id,
                si.product_id AS hdr_product_id,
                si.process_id AS hdr_process_id,
                si.quantity AS hdr_qty,
                si.items AS hdr_items
              FROM {schema}.stock_inward si WHERE si.id = :iid
            ),
            in_lines AS (
              SELECT inward_id,
                hdr_product_id AS product_id,
                hdr_qty AS line_qty,
                hdr_process_id AS process_id
              FROM i_lines
              WHERE jsonb_array_length(COALESCE(hdr_items, '[]'::jsonb)) = 0
                AND hdr_product_id IS NOT NULL
              UNION ALL
              SELECT inward_id,
                NULLIF(item->>'product_id', '')::int AS product_id,
                COALESCE(NULLIF(item->>'quantity', ''), '0')::numeric AS line_qty,
                COALESCE(NULLIF(item->>'process_id', ''), hdr_process_id) AS process_id
              FROM i_lines,
                jsonb_array_elements(COALESCE(hdr_items, '[]'::jsonb)) AS item
              WHERE jsonb_array_length(COALESCE(hdr_items, '[]'::jsonb)) > 0
                AND NULLIF(item->>'product_id', '') IS NOT NULL
            ),
            out_dispatched AS (
              SELECT
                :iid AS inward_id,
                COALESCE(NULLIF(o_item->>'product_id', ''), NULLIF(so.product_id::text, ''))::int AS product_id,
                SUM(COALESCE(NULLIF(o_item->>'quantity', ''), NULLIF(so.quantity::text, ''), '0')::numeric) AS dispatched
              FROM {schema}.stock_outward so
              LEFT JOIN LATERAL jsonb_array_elements(
                CASE WHEN jsonb_array_length(COALESCE(so.items, '[]'::jsonb)) > 0
                  THEN so.items ELSE NULL END
              ) AS o_item ON TRUE
              WHERE (
                (
                  NULLIF(o_item->>'inward_id', '') IS NOT NULL 
                  AND (o_item->>'inward_id')::text = :iid_str
                )
                OR (
                  NULLIF(o_item->>'inward_id', '') IS NULL
                  AND (
                    so.inward_id = :iid
                    OR (so.inward_ids IS NOT NULL AND jsonb_typeof(so.inward_ids) = 'array' AND :iid_str = ANY(ARRAY(SELECT jsonb_array_elements_text(so.inward_ids))))
                  )
                )
              )
              AND COALESCE(NULLIF(o_item->>'product_id', ''), NULLIF(so.product_id::text, '')) IS NOT NULL
              GROUP BY 1, 2
            ),
            inward_balances AS (
              SELECT il.inward_id,
                SUM(GREATEST(il.line_qty - COALESCE(od.dispatched, 0), 0)) AS total_balance
              FROM in_lines il
              LEFT JOIN out_dispatched od ON od.inward_id = il.inward_id AND od.product_id = il.product_id
              GROUP BY il.inward_id
            )
            SELECT COALESCE(ib.total_balance, (SELECT COALESCE(SUM(line_qty), 0) FROM in_lines)) AS balance_qty,
              (SELECT COUNT(*) FROM out_dispatched) AS dispatched_count
            FROM {schema}.stock_inward si
            LEFT JOIN inward_balances ib ON ib.inward_id = si.id
            WHERE si.id = :iid
            """),
            {"iid": inw_id, "iid_str": str(inw_id)},
        )
        bal_row = bal_res.mappings().first()
        if not bal_row:
            raise HTTPException(
                status_code=400,
                detail=f"Inward voucher '{inward_no}' was not found in database.",
            )

        dispatched_cnt = float(bal_row.get("dispatched_count") or 0)
        bal_qty = float(bal_row.get("balance_qty") or 0)

        if dispatched_cnt == 0:
            raise HTTPException(
                status_code=400,
                detail=f"Inward voucher '{inward_no}' has no outward dispatches. Labour Bills can only be raised for fully completed inwards.",
            )

        if bal_qty > 0.0001:
            raise HTTPException(
                status_code=400,
                detail=f"Inward voucher '{inward_no}' is not fully completed (Remaining Balance Qty: {bal_qty:g}). Labour Bills can only be raised for fully completed inwards.",
            )


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


async def _resolve_bill_weight(db: DBSession, body_quantity: float, items: list[dict] | None) -> float:
    if not items or len(items) == 0:
        return body_quantity

    proc_ids = [it.get("process_id") for it in items if it.get("process_id")]
    if proc_ids:
        numeric_pids = [int(p) for p in proc_ids if str(p).isdigit()]
        if numeric_pids:
            res = await db.execute(
                text("SELECT id, name, process_code FROM master.processes WHERE id = ANY(:pids)"),
                {"pids": numeric_pids}
            )
            proc_rows = res.mappings().all()
            shot_ids = {
                r["id"] for r in proc_rows
                if "shot" in (r["name"] or "").lower() or "shot" in (r["process_code"] or "").lower()
            }
            shot_weight = sum(
                float(it.get("quantity") or 0)
                for it in items
                if it.get("process_id") and int(it["process_id"]) in shot_ids
            )
            if shot_weight > 0:
                return shot_weight

    first_qty = float(items[0].get("quantity") or 0)
    if first_qty > 0:
        return first_qty
    return body_quantity


@router.post("/", status_code=201)
async def create_labour_bill(
    body: LabourBillIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await _validate_inwards_completed(db, schema, body.inward_id, body.outward_ids)
    
    if body.bill_no and body.bill_no.strip():
        bill_no = body.bill_no.strip()
    else:
        from app.services.sequences import generate_and_increment_sequence
        bill_no = await generate_and_increment_sequence(db, "labour_bill")

    # Check for duplicate bill_no
    dup_res = await db.execute(
        text(f"SELECT id FROM {schema}.labour_bills WHERE bill_no = :bno"),
        {"bno": bill_no}
    )
    if dup_res.mappings().first():
        if not (body.bill_no and body.bill_no.strip()):
            from app.services.sequences import generate_and_increment_sequence
            for _ in range(50):
                bill_no = await generate_and_increment_sequence(db, "labour_bill")
                check = await db.execute(
                    text(f"SELECT id FROM {schema}.labour_bills WHERE bill_no = :bno"),
                    {"bno": bill_no}
                )
                if not check.mappings().first():
                    break
            else:
                raise HTTPException(
                    status_code=400,
                    detail=f"Labour Bill number '{bill_no}' already exists in database. Please update Document Numbering settings."
                )
        else:
            raise HTTPException(
                status_code=400,
                detail=f"Labour Bill number '{bill_no}' already exists in database. Please verify or update Document Numbering settings."
            )

    items_json = json.dumps(body.items) if body.items else "[]"
    oids_json = json.dumps(body.outward_ids) if body.outward_ids else "[]"
    freight_json = json.dumps(body.freight_items) if body.freight_items else "[]"
    bill_qty = await _resolve_bill_weight(db, body.quantity, body.items)
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
            "qty": bill_qty, "rate": body.rate, "amt": body.amount,
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
    await _validate_inwards_completed(db, schema, body.inward_id, body.outward_ids)
    items_json = json.dumps(body.items) if body.items else "[]"
    oids_json = json.dumps(body.outward_ids) if body.outward_ids else "[]"
    freight_json = json.dumps(body.freight_items) if body.freight_items else "[]"
    bill_qty = await _resolve_bill_weight(db, body.quantity, body.items)
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
            "qty": bill_qty, "rate": body.rate, "amt": body.amount,
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


class EditLabourBillIn(BaseModel):
    bill_no: Optional[str] = None
    bill_date: Optional[str] = None
    taxable_amount: Optional[float] = None
    gst_amount: Optional[float] = None
    total_amount: Optional[float] = None
    narration: Optional[str] = None


@router.patch("/{bill_id}/edit-bill")
async def edit_bill_details(
    bill_id: int,
    body: EditLabourBillIn,
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
    bno = body.bill_no or bill_dict.get("bill_no")
    bdate = body.bill_date or str(bill_dict.get("bill_date"))
    tax_amt = body.taxable_amount if body.taxable_amount is not None else float(bill_dict.get("amount") or 0)
    gst_amt = body.gst_amount if body.gst_amount is not None else float(bill_dict.get("gst_amount") or 0)
    tot_amt = body.total_amount if body.total_amount is not None else float(bill_dict.get("total_amount") or tax_amt + gst_amt)
    narr = body.narration if body.narration is not None else bill_dict.get("narration")

    paid_amt = float(bill_dict.get("paid_amount") or 0)
    new_pending = max(0.0, tot_amt - paid_amt)
    pstatus = "PAID" if new_pending <= 1.0 else ("PARTIAL" if paid_amt > 0 else "UNPAID")
    is_paid_bool = True if pstatus == "PAID" else False

    await db.execute(
        text(f"""
            UPDATE {schema}.labour_bills SET
            bill_no = :bno,
            bill_date = :bdate,
            amount = :amt,
            gst_amount = :gamt,
            total_amount = :tamt,
            net_amount = :tamt,
            pending_amount = :pending,
            payment_status = :pstatus,
            is_paid = :ispaid,
            narration = :narr,
            updated_at = NOW()
            WHERE id = :id
        """),
        {
            "bno": bno,
            "bdate": bdate,
            "amt": tax_amt,
            "gamt": gst_amt,
            "tamt": tot_amt,
            "pending": new_pending,
            "pstatus": pstatus,
            "ispaid": is_paid_bool,
            "narr": narr,
            "id": bill_id,
        }
    )
    return {"message": "Bill updated successfully", "payment_status": pstatus, "pending_amount": new_pending}


@router.put("/{bill_id}/payments/{payment_id}")
async def update_bill_payment(
    bill_id: int,
    payment_id: int,
    body: LabourBillPaymentIn,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await _ensure_payment_schema(db, schema)

    await db.execute(
        text(f"""
            UPDATE {schema}.labour_bill_payments SET
            payment_date = :pdate,
            payment_mode = :pmode,
            component = :comp,
            taxable_amount = :tamt,
            gst_amount = :gamt,
            tds_amount = :tds,
            net_paid_amount = :npamt,
            notes = :notes
            WHERE id = :pid AND bill_id = :bid
        """),
        {
            "pdate": body.payment_date,
            "pmode": body.payment_mode,
            "comp": body.component,
            "tamt": body.taxable_amount,
            "gamt": body.gst_amount,
            "tds": body.tds_amount,
            "npamt": body.net_paid_amount,
            "notes": body.notes,
            "pid": payment_id,
            "bid": bill_id,
        }
    )

    res = await db.execute(
        text(f"SELECT COALESCE(SUM(net_paid_amount), 0) AS total_paid, COALESCE(SUM(tds_amount), 0) AS total_tds FROM {schema}.labour_bill_payments WHERE bill_id = :bid"),
        {"bid": bill_id}
    )
    row = res.mappings().first()
    sum_paid = float(row.get("total_paid") or 0)
    sum_tds = float(row.get("total_tds") or 0)

    res_bill = await db.execute(
        text(f"SELECT * FROM {schema}.labour_bills WHERE id = :id"),
        {"id": bill_id}
    )
    bill = res_bill.mappings().first()
    if bill:
        bill_dict = dict(bill)
        tot = float(bill_dict.get("total_amount") or 0)
        taxable_val = float(bill_dict.get("amount") or tot)
        new_pending = max(0.0, tot - sum_paid - sum_tds)
        pstatus = "PAID" if new_pending <= 1.0 else ("PARTIAL" if sum_paid > 0 else "UNPAID")
        is_paid_bool = True if pstatus == "PAID" else False
        tpaid = sum_paid >= taxable_val - sum_tds

        await db.execute(
            text(f"""
                UPDATE {schema}.labour_bills SET
                paid_amount = :paid,
                pending_amount = :pending,
                taxable_paid = :tpaid,
                gst_paid = :ispaid,
                payment_status = :pstatus,
                is_paid = :ispaid,
                payment_date = :pdate,
                updated_at = NOW()
                WHERE id = :id
            """),
            {
                "paid": sum_paid,
                "pending": new_pending,
                "tpaid": tpaid,
                "pstatus": pstatus,
                "ispaid": is_paid_bool,
                "pdate": body.payment_date,
                "id": bill_id,
            }
        )
    return {"message": "Payment record updated successfully", "payment_status": pstatus, "pending_amount": new_pending}


@router.delete("/{bill_id}/payments/{payment_id}")
async def delete_bill_payment(
    bill_id: int,
    payment_id: int,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await _ensure_payment_schema(db, schema)

    await db.execute(
        text(f"DELETE FROM {schema}.labour_bill_payments WHERE id = :pid AND bill_id = :bid"),
        {"pid": payment_id, "bid": bill_id}
    )

    res = await db.execute(
        text(f"SELECT COALESCE(SUM(net_paid_amount), 0) AS total_paid, COALESCE(SUM(tds_amount), 0) AS total_tds FROM {schema}.labour_bill_payments WHERE bill_id = :bid"),
        {"bid": bill_id}
    )
    row = res.mappings().first()
    sum_paid = float(row.get("total_paid") or 0)
    sum_tds = float(row.get("total_tds") or 0)

    res_bill = await db.execute(
        text(f"SELECT * FROM {schema}.labour_bills WHERE id = :id"),
        {"id": bill_id}
    )
    bill = res_bill.mappings().first()
    if bill:
        bill_dict = dict(bill)
        tot = float(bill_dict.get("total_amount") or 0)
        taxable_val = float(bill_dict.get("amount") or tot)
        new_pending = max(0.0, tot - sum_paid - sum_tds)
        pstatus = "PAID" if new_pending <= 1.0 else ("PARTIAL" if sum_paid > 0 else "UNPAID")
        is_paid_bool = True if pstatus == "PAID" else False
        tpaid = sum_paid >= taxable_val - sum_tds

        await db.execute(
            text(f"""
                UPDATE {schema}.labour_bills SET
                paid_amount = :paid,
                pending_amount = :pending,
                taxable_paid = :tpaid,
                gst_paid = :ispaid,
                payment_status = :pstatus,
                is_paid = :ispaid,
                updated_at = NOW()
                WHERE id = :id
            """),
            {
                "paid": sum_paid,
                "pending": new_pending,
                "tpaid": tpaid,
                "pstatus": pstatus,
                "ispaid": is_paid_bool,
                "id": bill_id,
            }
        )
    return {"message": "Payment record deleted and bill balance recalculated"}


@router.post("/{bill_id}/reset-payment")
async def reset_bill_payment(
    bill_id: int,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await _ensure_payment_schema(db, schema)

    await db.execute(
        text(f"DELETE FROM {schema}.labour_bill_payments WHERE bill_id = :bid"),
        {"bid": bill_id}
    )

    res = await db.execute(
        text(f"SELECT * FROM {schema}.labour_bills WHERE id = :id"),
        {"id": bill_id}
    )
    bill = res.mappings().first()
    if not bill:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="Labour bill not found")

    bill_dict = dict(bill)
    tot = float(bill_dict.get("total_amount") or bill_dict.get("net_amount") or 0)

    await db.execute(
        text(f"""
            UPDATE {schema}.labour_bills SET
            paid_amount = 0,
            pending_amount = :tot,
            taxable_paid = FALSE,
            gst_paid = FALSE,
            payment_status = 'UNPAID',
            is_paid = FALSE,
            payment_date = NULL,
            updated_at = NOW()
            WHERE id = :id
        """),
        {"tot": tot, "id": bill_id}
    )
    return {"message": "Bill payment reset back to Pending successfully", "payment_status": "UNPAID", "pending_amount": tot}


@router.delete("/{bill_id}", status_code=204)
async def delete_labour_bill(
    bill_id: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    await db.execute(
        text(f"DELETE FROM {s(fy)}.labour_bills WHERE id = :id"), {"id": bill_id}
    )
