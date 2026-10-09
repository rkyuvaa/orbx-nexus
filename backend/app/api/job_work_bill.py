from fastapi import APIRouter, HTTPException, Query
from sqlalchemy import text
from pydantic import BaseModel
from typing import Optional
import json

from app.api.deps import CurrentUser, DBSession

router = APIRouter()


def s(fy: str) -> str:
    return f"fy_{fy}"


class JobWorkBillLineIn(BaseModel):
    inward_id: int
    outward_id: int
    process_id: int
    process_name: str
    process_code: str | None = None
    process_rate: float
    uom_symbol: str | None = None
    billable_quantity: float
    process_amount: float
    # Snapshot of rate at time of billing (historical preservation)
    rate_snapshot: float


class JobWorkBillIn(BaseModel):
    bill_no: str | None = None
    bill_date: str
    ledger_id: int  # Customer/Company ledger
    lines: list[JobWorkBillLineIn]
    # Summaries
    total_process_charges: float = 0
    additional_charges: float = 0
    discount: float = 0
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


async def _ensure_tables(db: DBSession, schema: str):
    """Ensure job_work_bills and job_work_bill_lines tables exist."""
    await db.execute(text(f"""
        CREATE TABLE IF NOT EXISTS {schema}.job_work_bills (
            id SERIAL PRIMARY KEY,
            bill_no VARCHAR(50) UNIQUE NOT NULL,
            bill_date DATE NOT NULL,
            ledger_id INTEGER NOT NULL,
            total_process_charges NUMERIC(15,2) DEFAULT 0,
            additional_charges NUMERIC(15,2) DEFAULT 0,
            discount NUMERIC(15,2) DEFAULT 0,
            gst_percent NUMERIC(5,2) DEFAULT 0,
            gst_amount NUMERIC(15,2) DEFAULT 0,
            cgst_percent NUMERIC(5,2) DEFAULT 0,
            cgst_amount NUMERIC(15,2) DEFAULT 0,
            sgst_percent NUMERIC(5,2) DEFAULT 0,
            sgst_amount NUMERIC(15,2) DEFAULT 0,
            round_off NUMERIC(15,2) DEFAULT 0,
            net_amount NUMERIC(15,2) DEFAULT 0,
            total_amount NUMERIC(15,2) DEFAULT 0,
            narration TEXT,
            is_paid BOOLEAN DEFAULT FALSE,
            payment_status VARCHAR(20) DEFAULT 'UNPAID',
            paid_amount NUMERIC(15,2) DEFAULT 0,
            pending_amount NUMERIC(15,2) DEFAULT 0,
            payment_date DATE,
            created_by INTEGER,
            created_at TIMESTAMP DEFAULT NOW(),
            updated_at TIMESTAMP DEFAULT NOW()
        );
    """))
    await db.execute(text(f"""
        CREATE TABLE IF NOT EXISTS {schema}.job_work_bill_lines (
            id SERIAL PRIMARY KEY,
            bill_id INTEGER NOT NULL REFERENCES {schema}.job_work_bills(id) ON DELETE CASCADE,
            inward_id INTEGER NOT NULL,
            outward_id INTEGER NOT NULL,
            process_id INTEGER NOT NULL,
            process_name VARCHAR(200) NOT NULL,
            process_code VARCHAR(50),
            process_rate NUMERIC(15,4) NOT NULL,
            uom_symbol VARCHAR(20),
            billable_quantity NUMERIC(15,3) DEFAULT 0,
            process_amount NUMERIC(15,2) DEFAULT 0,
            rate_snapshot NUMERIC(15,4) NOT NULL,
            created_at TIMESTAMP DEFAULT NOW()
        );
    """))
    await db.execute(text(f"""
        CREATE TABLE IF NOT EXISTS {schema}.job_work_bill_payments (
            id SERIAL PRIMARY KEY,
            bill_id INTEGER NOT NULL REFERENCES {schema}.job_work_bills(id) ON DELETE CASCADE,
            payment_date DATE NOT NULL,
            payment_mode VARCHAR(50) DEFAULT 'Bank Transfer',
            amount NUMERIC(15,2) DEFAULT 0,
            notes TEXT,
            created_at TIMESTAMP DEFAULT NOW()
        );
    """))
    # Index for preventing duplicate billing of same inward
    await db.execute(text(f"""
        CREATE UNIQUE INDEX IF NOT EXISTS idx_{schema.replace('.','_')}_jwb_lines_inward_outward_process
        ON {schema}.job_work_bill_lines(inward_id, outward_id, process_id);
    """))


@router.get("/eligible-inwards")
async def get_eligible_inwards(
    current_user: CurrentUser,
    db: DBSession,
    ledger_id: int = Query(...),
    fy: str = Query(default="2026_2027")
):
    """
    Returns Inward records for a given customer/ledger that:
    1. Belong to the given ledger (customer)
    2. Are FULLY outward-dispatched (balance qty = 0)
    3. Have NOT already been billed in job_work_bills
    """
    schema = s(fy)
    await _ensure_tables(db, schema)

    query = f"""
    WITH inward_list AS (
        SELECT si.id, si.inward_no, si.inward_date, si.ledger_id,
               si.product_id, si.process_id,
               si.quantity, si.total_weight, si.weight,
               si.serial_no, si.ref_no, si.ref_date,
               si.items, si.narration
        FROM {schema}.stock_inward si
        WHERE si.ledger_id = :lid
    ),
    inward_total_qty AS (
        -- For each inward, compute total received qty (header or sum of items)
        SELECT i.id AS inward_id,
            CASE
                WHEN jsonb_array_length(COALESCE(i.items, '[]'::jsonb)) > 0
                THEN (
                    SELECT COALESCE(SUM(COALESCE(NULLIF(item->>'quantity',''),'0')::numeric), 0)
                    FROM jsonb_array_elements(i.items) AS item
                    WHERE NULLIF(item->>'product_id','') IS NOT NULL
                )
                ELSE COALESCE(i.quantity, 0)
            END AS total_inward_qty
        FROM inward_list i
    ),
    outward_dispatched_qty AS (
        -- For each inward, compute total dispatched qty across all outward records
        SELECT
            inward_ref.inward_id,
            COALESCE(SUM(
                CASE
                    WHEN jsonb_array_length(COALESCE(so.items, '[]'::jsonb)) > 0
                    THEN (
                        SELECT COALESCE(SUM(COALESCE(NULLIF(o_item->>'quantity',''),'0')::numeric), 0)
                        FROM jsonb_array_elements(so.items) AS o_item
                        WHERE
                            NULLIF(o_item->>'inward_id','') IS NOT NULL
                            AND NULLIF(o_item->>'inward_id','')::int = inward_ref.inward_id
                            AND NULLIF(o_item->>'product_id','') IS NOT NULL
                    )
                    ELSE COALESCE(so.quantity, 0)
                END
            ), 0) AS dispatched_qty
        FROM (
            SELECT DISTINCT il.id AS inward_id
            FROM inward_list il
        ) inward_ref
        JOIN {schema}.stock_outward so ON (
            so.inward_id = inward_ref.inward_id
            OR (so.inward_ids IS NOT NULL AND jsonb_typeof(so.inward_ids)='array'
                AND inward_ref.inward_id::text = ANY(ARRAY(SELECT jsonb_array_elements_text(so.inward_ids))))
        )
        GROUP BY inward_ref.inward_id
    ),
    outward_count AS (
        SELECT
            inward_ref.inward_id,
            COUNT(DISTINCT so.id) AS outward_count
        FROM (
            SELECT DISTINCT il.id AS inward_id FROM inward_list il
        ) inward_ref
        JOIN {schema}.stock_outward so ON (
            so.inward_id = inward_ref.inward_id
            OR (so.inward_ids IS NOT NULL AND jsonb_typeof(so.inward_ids)='array'
                AND inward_ref.inward_id::text = ANY(ARRAY(SELECT jsonb_array_elements_text(so.inward_ids))))
        )
        GROUP BY inward_ref.inward_id
    ),
    already_billed AS (
        SELECT DISTINCT jbl.inward_id
        FROM {schema}.job_work_bill_lines jbl
        JOIN {schema}.job_work_bills jwb ON jwb.id = jbl.bill_id
        WHERE jwb.ledger_id = :lid
    )
    SELECT
        il.id,
        il.inward_no,
        il.inward_date::text,
        il.ledger_id,
        il.product_id,
        il.process_id,
        il.quantity,
        il.total_weight,
        il.weight,
        il.serial_no,
        il.ref_no,
        il.ref_date::text,
        il.items,
        il.narration,
        p.name AS product_name,
        p.product_code,
        itq.total_inward_qty,
        COALESCE(odq.dispatched_qty, 0) AS dispatched_qty,
        GREATEST(itq.total_inward_qty - COALESCE(odq.dispatched_qty, 0), 0) AS balance_qty,
        COALESCE(oc.outward_count, 0) AS outward_count
    FROM inward_list il
    JOIN inward_total_qty itq ON itq.inward_id = il.id
    LEFT JOIN outward_dispatched_qty odq ON odq.inward_id = il.id
    LEFT JOIN outward_count oc ON oc.inward_id = il.id
    LEFT JOIN master.products p ON p.id = il.product_id
    WHERE
        -- Fully dispatched: balance <= 0.001
        GREATEST(itq.total_inward_qty - COALESCE(odq.dispatched_qty, 0), 0) <= 0.001
        -- Has at least one outward
        AND COALESCE(oc.outward_count, 0) > 0
        -- Not already billed
        AND il.id NOT IN (SELECT inward_id FROM already_billed)
    ORDER BY il.inward_date DESC, il.inward_no DESC
    """
    result = await db.execute(text(query), {"lid": ledger_id})
    rows = []
    for r in result.mappings().all():
        row = dict(r)
        # Parse items JSON
        if isinstance(row.get("items"), str):
            try:
                row["items"] = json.loads(row["items"])
            except Exception:
                row["items"] = []
        rows.append(row)
    return rows


@router.get("/inward-details/{inward_id}")
async def get_inward_bill_details(
    inward_id: int,
    ledger_id: int,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027")
):
    """
    Given an eligible inward, fetch:
    - Inward header info
    - All linked outward records (fully dispatched)
    - For each outward, resolve process_ids and match to Process Register
    - Fetch company_rate from Process Register as the billing rate
    - Return line items for bill preview
    """
    schema = s(fy)
    await _ensure_tables(db, schema)

    # 1. Fetch inward
    inw_res = await db.execute(
        text(f"SELECT * FROM {schema}.stock_inward WHERE id = :id AND ledger_id = :lid"),
        {"id": inward_id, "lid": ledger_id}
    )
    inward = inw_res.mappings().first()
    if not inward:
        raise HTTPException(status_code=404, detail="Inward not found or does not belong to this customer")
    inward_dict = dict(inward)
    if isinstance(inward_dict.get("items"), str):
        try:
            inward_dict["items"] = json.loads(inward_dict["items"])
        except Exception:
            inward_dict["items"] = []

    # 2. Fetch all linked outward records
    out_res = await db.execute(
        text(f"""
        SELECT so.*
        FROM {schema}.stock_outward so
        WHERE so.inward_id = :iid
           OR (so.inward_ids IS NOT NULL AND jsonb_typeof(so.inward_ids) = 'array'
               AND :iid_str = ANY(ARRAY(SELECT jsonb_array_elements_text(so.inward_ids))))
        ORDER BY so.outward_date ASC, so.id ASC
        """),
        {"iid": inward_id, "iid_str": str(inward_id)}
    )
    outwards = []
    for r in out_res.mappings().all():
        row = dict(r)
        for field in ["items", "inward_ids"]:
            if isinstance(row.get(field), str):
                try:
                    row[field] = json.loads(row[field])
                except Exception:
                    row[field] = []
        outwards.append(row)

    if not outwards:
        raise HTTPException(status_code=400, detail="This inward has no completed outward dispatches")

    # 3. Collect all process IDs from outwards
    # Process IDs can be comma-separated strings in process_id field, or in items[].process_id
    process_id_set = set()
    outward_line_map = []  # [{outward_id, process_ids, quantity}]

    for out in outwards:
        outward_process_ids = []
        # From items
        items = out.get("items") or []
        if isinstance(items, list) and len(items) > 0:
            for item in items:
                pid_raw = str(item.get("process_id", "")).strip()
                if pid_raw and pid_raw.isdigit():
                    process_id_set.add(int(pid_raw))
                    outward_process_ids.append({"process_id": int(pid_raw), "quantity": float(item.get("quantity") or item.get("total_weight") or 0), "outward_id": out["id"]})
        # From header process_id (comma-separated)
        if not outward_process_ids:
            pid_raw = str(out.get("process_id") or "").strip()
            if pid_raw:
                for part in pid_raw.split(","):
                    part = part.strip()
                    if part.isdigit():
                        pid = int(part)
                        process_id_set.add(pid)
                        qty = float(out.get("total_weight") or out.get("quantity") or 0)
                        outward_process_ids.append({"process_id": pid, "quantity": qty, "outward_id": out["id"]})

        for entry in outward_process_ids:
            outward_line_map.append(entry)

    if not process_id_set:
        raise HTTPException(status_code=400, detail="No processes found in the outward records for this inward")

    # 4. Fetch process master data for all process IDs
    pid_list = list(process_id_set)
    proc_res = await db.execute(
        text("SELECT id, name, process_code, company_rate, contractor_rate, gst_percent FROM master.processes WHERE id = ANY(:pids) AND is_active = TRUE"),
        {"pids": pid_list}
    )
    process_master = {}
    for r in proc_res.mappings().all():
        process_master[r["id"]] = dict(r)

    # 5. Build bill lines
    bill_lines = []
    missing_rates = []

    # Group by (outward_id, process_id) and sum quantities
    from collections import defaultdict
    grouped: dict = defaultdict(float)
    for entry in outward_line_map:
        key = (entry["outward_id"], entry["process_id"])
        grouped[key] += entry["quantity"]

    for (out_id, proc_id), qty in grouped.items():
        proc = process_master.get(proc_id)
        if not proc:
            missing_rates.append({"process_id": proc_id, "issue": "Process not found or inactive in Process Register"})
            continue
        rate = float(proc.get("company_rate") or 0)
        if rate == 0:
            missing_rates.append({"process_id": proc_id, "process_name": proc["name"], "issue": "Company rate is 0 in Process Register"})
        # Find outward no
        out_rec = next((o for o in outwards if o["id"] == out_id), {})
        outward_no = out_rec.get("outward_no", f"#{out_id}")
        bill_lines.append({
            "inward_id": inward_id,
            "inward_no": inward_dict.get("inward_no"),
            "inward_date": str(inward_dict.get("inward_date") or ""),
            "outward_id": out_id,
            "outward_no": outward_no,
            "outward_date": str(out_rec.get("outward_date") or ""),
            "process_id": proc_id,
            "process_name": proc["name"],
            "process_code": proc.get("process_code"),
            "process_rate": rate,
            "rate_snapshot": rate,
            "uom_symbol": None,
            "billable_quantity": qty,
            "process_amount": round(rate * qty, 2),
        })

    total_process_charges = round(sum(l["process_amount"] for l in bill_lines), 2)
    inward_dict["inward_date"] = str(inward_dict.get("inward_date") or "")
    inward_dict["ref_date"] = str(inward_dict.get("ref_date") or "") if inward_dict.get("ref_date") else None

    return {
        "inward": inward_dict,
        "outwards": [{"id": o["id"], "outward_no": o["outward_no"], "outward_date": str(o.get("outward_date") or "")} for o in outwards],
        "bill_lines": bill_lines,
        "total_process_charges": total_process_charges,
        "missing_rates": missing_rates,
    }


@router.get("/")
async def list_job_work_bills(
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
    ledger_id: Optional[int] = None,
    from_date: Optional[str] = None,
    to_date: Optional[str] = None,
    is_paid: Optional[bool] = None
):
    schema = s(fy)
    await _ensure_tables(db, schema)
    conds = ["1=1"]
    params: dict = {}
    if ledger_id:
        conds.append("jwb.ledger_id = :lid")
        params["lid"] = ledger_id
    if from_date:
        conds.append("jwb.bill_date >= :fd")
        params["fd"] = from_date
    if to_date:
        conds.append("jwb.bill_date <= :td")
        params["td"] = to_date
    if is_paid is not None:
        conds.append("jwb.is_paid = :ip")
        params["ip"] = is_paid

    result = await db.execute(
        text(f"""
        SELECT jwb.*,
               l.name AS customer_name,
               COALESCE((
                   SELECT COUNT(*) FROM {schema}.job_work_bill_lines jl WHERE jl.bill_id = jwb.id
               ), 0) AS line_count,
               COALESCE((
                   SELECT json_agg(json_build_object(
                       'id', jl.id, 'inward_id', jl.inward_id, 'outward_id', jl.outward_id,
                       'process_name', jl.process_name, 'process_code', jl.process_code,
                       'process_rate', jl.process_rate, 'billable_quantity', jl.billable_quantity,
                       'process_amount', jl.process_amount, 'uom_symbol', jl.uom_symbol,
                       'rate_snapshot', jl.rate_snapshot
                   ))
                   FROM {schema}.job_work_bill_lines jl WHERE jl.bill_id = jwb.id
               ), '[]'::json) AS lines
        FROM {schema}.job_work_bills jwb
        LEFT JOIN master.ledgers l ON l.id = jwb.ledger_id
        WHERE {' AND '.join(conds)}
        ORDER BY jwb.bill_date DESC, jwb.id DESC
        """),
        params
    )
    rows = []
    for r in result.mappings().all():
        row = dict(r)
        for f in ["lines"]:
            if isinstance(row.get(f), str):
                try:
                    row[f] = json.loads(row[f])
                except Exception:
                    row[f] = []
        rows.append(row)
    return rows


@router.post("/", status_code=201)
async def create_job_work_bill(
    body: JobWorkBillIn,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await _ensure_tables(db, schema)

    # Re-validate: check inward belongs to ledger and is eligible
    if not body.lines:
        raise HTTPException(status_code=400, detail="Bill must have at least one process line")

    # Check for duplicate inward billing
    inward_ids = list({line.inward_id for line in body.lines})
    already_billed = await db.execute(
        text(f"""
        SELECT DISTINCT jbl.inward_id
        FROM {schema}.job_work_bill_lines jbl
        JOIN {schema}.job_work_bills jwb ON jwb.id = jbl.bill_id
        WHERE jbl.inward_id = ANY(:iids) AND jwb.ledger_id = :lid
        """),
        {"iids": inward_ids, "lid": body.ledger_id}
    )
    billed_ids = [r[0] for r in already_billed.fetchall()]
    if billed_ids:
        raise HTTPException(
            status_code=400,
            detail=f"Inward(s) {billed_ids} have already been billed for this customer"
        )

    # Validate all process rates exist
    missing = []
    for line in body.lines:
        proc_res = await db.execute(
            text("SELECT id, name, company_rate FROM master.processes WHERE id = :pid AND is_active = TRUE"),
            {"pid": line.process_id}
        )
        proc = proc_res.mappings().first()
        if not proc:
            missing.append(f"Process #{line.process_id} not found")
        elif float(proc["company_rate"] or 0) == 0:
            missing.append(f"Process '{proc['name']}' has no company rate configured")
    if missing:
        raise HTTPException(status_code=400, detail="Missing process rates: " + "; ".join(missing))

    # Generate bill number
    if body.bill_no and body.bill_no.strip():
        bill_no = body.bill_no.strip()
    else:
        from app.services.sequences import generate_and_increment_sequence
        bill_no = await generate_and_increment_sequence(db, "job_work_bill")
        for _ in range(50):
            dup = await db.execute(
                text(f"SELECT id FROM {schema}.job_work_bills WHERE bill_no = :bno"),
                {"bno": bill_no}
            )
            if not dup.scalar_one_or_none():
                break
            bill_no = await generate_and_increment_sequence(db, "job_work_bill")

    # Check dup manual bill_no
    dup = await db.execute(
        text(f"SELECT id FROM {schema}.job_work_bills WHERE bill_no = :bno"),
        {"bno": bill_no}
    )
    if dup.scalar_one_or_none():
        raise HTTPException(status_code=400, detail=f"Bill number '{bill_no}' already exists")

    # Insert bill header
    result = await db.execute(
        text(f"""
        INSERT INTO {schema}.job_work_bills
        (bill_no, bill_date, ledger_id, total_process_charges, additional_charges, discount,
         gst_percent, gst_amount, cgst_percent, cgst_amount, sgst_percent, sgst_amount,
         round_off, net_amount, total_amount, narration, pending_amount, created_by)
        VALUES (:bno, CAST(:bdate AS DATE), :lid, :tpc, :ac, :disc,
                :gp, :ga, :cgp, :cga, :sgp, :sga,
                :ro, :namt, :ta, :narr, :pending, :cby)
        RETURNING id
        """),
        {
            "bno": bill_no, "bdate": body.bill_date, "lid": body.ledger_id,
            "tpc": body.total_process_charges, "ac": body.additional_charges, "disc": body.discount,
            "gp": body.gst_percent, "ga": body.gst_amount,
            "cgp": body.cgst_percent, "cga": body.cgst_amount,
            "sgp": body.sgst_percent, "sga": body.sgst_amount,
            "ro": body.round_off, "namt": body.net_amount, "ta": body.total_amount,
            "narr": body.narration, "pending": body.total_amount, "cby": current_user.id
        }
    )
    bill_id = result.scalar_one()

    # Insert bill lines (with rate_snapshot for historical preservation)
    for line in body.lines:
        await db.execute(
            text(f"""
            INSERT INTO {schema}.job_work_bill_lines
            (bill_id, inward_id, outward_id, process_id, process_name, process_code,
             process_rate, uom_symbol, billable_quantity, process_amount, rate_snapshot)
            VALUES (:bid, :iid, :oid, :pid, :pname, :pcode,
                    :prate, :uom, :qty, :amt, :snap)
            """),
            {
                "bid": bill_id, "iid": line.inward_id, "oid": line.outward_id,
                "pid": line.process_id, "pname": line.process_name, "pcode": line.process_code,
                "prate": line.process_rate, "uom": line.uom_symbol,
                "qty": line.billable_quantity, "amt": line.process_amount,
                "snap": line.rate_snapshot
            }
        )

    return {"id": bill_id, "bill_no": bill_no, "message": "Job Work Bill created"}


@router.get("/{bill_id}")
async def get_job_work_bill(
    bill_id: int,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await _ensure_tables(db, schema)
    result = await db.execute(
        text(f"""
        SELECT jwb.*,
               l.name AS customer_name,
               l.address AS customer_address,
               l.city AS customer_city,
               l.state AS customer_state,
               l.pincode AS customer_pincode,
               l.gstin AS customer_gstin,
               COALESCE((
                   SELECT json_agg(json_build_object(
                       'id', jl.id, 'inward_id', jl.inward_id, 'outward_id', jl.outward_id,
                       'process_id', jl.process_id, 'process_name', jl.process_name,
                       'process_code', jl.process_code, 'process_rate', jl.process_rate,
                       'billable_quantity', jl.billable_quantity, 'process_amount', jl.process_amount,
                       'uom_symbol', jl.uom_symbol, 'rate_snapshot', jl.rate_snapshot
                   ) ORDER BY jl.id)
                   FROM {schema}.job_work_bill_lines jl WHERE jl.bill_id = jwb.id
               ), '[]'::json) AS lines
        FROM {schema}.job_work_bills jwb
        LEFT JOIN master.ledgers l ON l.id = jwb.ledger_id
        WHERE jwb.id = :id
        """),
        {"id": bill_id}
    )
    row = result.mappings().first()
    if not row:
        raise HTTPException(status_code=404, detail="Bill not found")
    bill = dict(row)
    if isinstance(bill.get("lines"), str):
        try:
            bill["lines"] = json.loads(bill["lines"])
        except Exception:
            bill["lines"] = []
    return bill


@router.delete("/{bill_id}", status_code=204)
async def delete_job_work_bill(
    bill_id: int,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await _ensure_tables(db, schema)
    # Lines cascade delete via FK
    await db.execute(
        text(f"DELETE FROM {schema}.job_work_bills WHERE id = :id"),
        {"id": bill_id}
    )


@router.post("/{bill_id}/record-payment", status_code=201)
async def record_payment(
    bill_id: int,
    payment_date: str,
    amount: float,
    payment_mode: str = "Bank Transfer",
    notes: Optional[str] = None,
    current_user: CurrentUser = None,
    db: DBSession = None,
    fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await _ensure_tables(db, schema)
    # Fetch bill
    bill_res = await db.execute(
        text(f"SELECT * FROM {schema}.job_work_bills WHERE id = :id"),
        {"id": bill_id}
    )
    bill = bill_res.mappings().first()
    if not bill:
        raise HTTPException(status_code=404, detail="Bill not found")
    bill_dict = dict(bill)
    current_paid = float(bill_dict.get("paid_amount") or 0)
    total = float(bill_dict.get("total_amount") or 0)
    new_paid = current_paid + amount
    new_pending = max(0.0, total - new_paid)
    status = "PAID" if new_pending <= 0.5 else "PARTIAL"
    is_paid = status == "PAID"

    await db.execute(
        text(f"""
        INSERT INTO {schema}.job_work_bill_payments (bill_id, payment_date, payment_mode, amount, notes)
        VALUES (:bid, CAST(:pdate AS DATE), :pmode, :amt, :notes)
        """),
        {"bid": bill_id, "pdate": payment_date, "pmode": payment_mode, "amt": amount, "notes": notes}
    )
    await db.execute(
        text(f"""
        UPDATE {schema}.job_work_bills SET
            paid_amount = :paid, pending_amount = :pending,
            payment_status = :pstatus, is_paid = :ispaid,
            payment_date = CAST(:pdate AS DATE), updated_at = NOW()
        WHERE id = :id
        """),
        {"paid": new_paid, "pending": new_pending, "pstatus": status, "ispaid": is_paid, "pdate": payment_date, "id": bill_id}
    )
    return {"message": "Payment recorded", "payment_status": status, "pending_amount": new_pending}


@router.patch("/{bill_id}/mark-paid")
async def mark_paid(
    bill_id: int,
    payment_date: str,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await _ensure_tables(db, schema)
    await db.execute(
        text(f"""
        UPDATE {schema}.job_work_bills SET is_paid=TRUE, payment_status='PAID',
        paid_amount=total_amount, pending_amount=0,
        payment_date=CAST(:pdate AS DATE), updated_at=NOW() WHERE id=:id
        """),
        {"pdate": payment_date, "id": bill_id}
    )
    return {"message": "Marked as paid"}
