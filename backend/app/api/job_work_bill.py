from fastapi import APIRouter, HTTPException, Query
from sqlalchemy import text
from pydantic import BaseModel
from typing import Optional, Any
import json
import logging

from app.api.deps import CurrentUser, DBSession

logger = logging.getLogger(__name__)

router = APIRouter()


def s(fy: str) -> str:
    return f"fy_{fy}"


class JobWorkBillIn(BaseModel):
    bill_no: Optional[str] = None
    bill_date: str
    ledger_id: int
    inward_id: Optional[int] = None
    inward_ids: Optional[list[Any]] = None
    outward_ids: Optional[list[Any]] = None
    product_id: Optional[int] = None
    process_id: Optional[int] = None
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
    narration: Optional[str] = None
    dispatch_through: Optional[str] = None
    items: Optional[list[dict]] = None
    freight_items: Optional[list[dict]] = None


async def _ensure_tables(db: DBSession, schema: str):
    """Ensure job_work_bills and supporting tables exist in the FY schema with all required columns."""
    await db.execute(text(f"""
        CREATE TABLE IF NOT EXISTS {schema}.job_work_bills (
            id SERIAL PRIMARY KEY,
            bill_no VARCHAR(50) UNIQUE NOT NULL,
            bill_date DATE NOT NULL,
            ledger_id INTEGER NOT NULL,
            inward_id INTEGER,
            inward_ids JSONB DEFAULT '[]'::jsonb,
            outward_ids JSONB DEFAULT '[]'::jsonb,
            product_id INTEGER,
            process_id INTEGER,
            quantity NUMERIC(15,3) DEFAULT 0,
            rate NUMERIC(15,2) DEFAULT 0,
            amount NUMERIC(15,2) DEFAULT 0,
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
            dispatch_through VARCHAR(255),
            items JSONB DEFAULT '[]'::jsonb,
            freight_items JSONB DEFAULT '[]'::jsonb,
            is_paid BOOLEAN DEFAULT FALSE,
            payment_status VARCHAR(20) DEFAULT 'UNPAID',
            paid_amount NUMERIC(15,2) DEFAULT 0,
            pending_amount NUMERIC(15,2) DEFAULT 0,
            payment_date DATE,
            created_by INTEGER,
            created_at TIMESTAMP DEFAULT NOW(),
            updated_at TIMESTAMP DEFAULT NOW()
        );
        CREATE TABLE IF NOT EXISTS {schema}.job_work_bill_lines (
            id SERIAL PRIMARY KEY,
            bill_id INTEGER NOT NULL REFERENCES {schema}.job_work_bills(id) ON DELETE CASCADE,
            inward_id INTEGER,
            outward_id INTEGER,
            process_id INTEGER,
            process_name VARCHAR(200),
            process_code VARCHAR(50),
            process_rate NUMERIC(15,4) DEFAULT 0,
            uom_symbol VARCHAR(20),
            billable_quantity NUMERIC(15,3) DEFAULT 0,
            process_amount NUMERIC(15,2) DEFAULT 0,
            rate_snapshot NUMERIC(15,4) DEFAULT 0,
            created_at TIMESTAMP DEFAULT NOW()
        );
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

    # Add columns if table was created in an earlier migration
    alter_cols = [
        "inward_id INTEGER",
        "inward_ids JSONB DEFAULT '[]'::jsonb",
        "outward_ids JSONB DEFAULT '[]'::jsonb",
        "product_id INTEGER",
        "process_id INTEGER",
        "quantity NUMERIC(15,3) DEFAULT 0",
        "rate NUMERIC(15,2) DEFAULT 0",
        "amount NUMERIC(15,2) DEFAULT 0",
        "gst_percent NUMERIC(5,2) DEFAULT 0",
        "gst_amount NUMERIC(15,2) DEFAULT 0",
        "cgst_percent NUMERIC(5,2) DEFAULT 0",
        "cgst_amount NUMERIC(15,2) DEFAULT 0",
        "sgst_percent NUMERIC(5,2) DEFAULT 0",
        "sgst_amount NUMERIC(15,2) DEFAULT 0",
        "round_off NUMERIC(15,2) DEFAULT 0",
        "net_amount NUMERIC(15,2) DEFAULT 0",
        "total_amount NUMERIC(15,2) DEFAULT 0",
        "narration TEXT",
        "dispatch_through VARCHAR(255)",
        "items JSONB DEFAULT '[]'::jsonb",
        "freight_items JSONB DEFAULT '[]'::jsonb",
        "is_paid BOOLEAN DEFAULT FALSE",
        "payment_status VARCHAR(20) DEFAULT 'UNPAID'",
        "paid_amount NUMERIC(15,2) DEFAULT 0",
        "pending_amount NUMERIC(15,2) DEFAULT 0",
        "payment_date DATE",
        "created_by INTEGER",
        "created_at TIMESTAMP DEFAULT NOW()",
        "updated_at TIMESTAMP DEFAULT NOW()"
    ]
    for col in alter_cols:
        try:
            await db.execute(text(f"ALTER TABLE {schema}.job_work_bills ADD COLUMN IF NOT EXISTS {col}"))
        except Exception:
            pass

    # Ensure job_work_bill_lines constraints are non-blocking
    try:
        await db.execute(text(f"""
            ALTER TABLE {schema}.job_work_bill_lines ALTER COLUMN inward_id DROP NOT NULL;
            ALTER TABLE {schema}.job_work_bill_lines ALTER COLUMN outward_id DROP NOT NULL;
            ALTER TABLE {schema}.job_work_bill_lines ALTER COLUMN process_rate DROP NOT NULL;
            ALTER TABLE {schema}.job_work_bill_lines ALTER COLUMN rate_snapshot DROP NOT NULL;
            DROP INDEX IF EXISTS {schema}.idx_{schema.replace('.','_')}_jwb_lines_inward_outward_process;
            DROP INDEX IF EXISTS idx_{schema.replace('.','_')}_jwb_lines_inward_outward_process;
        """))
    except Exception:
        pass


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
               l.name AS customer_name
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
        for f in ["items", "freight_items", "inward_ids", "outward_ids"]:
            if isinstance(row.get(f), str):
                try:
                    row[f] = json.loads(row[f])
                except Exception:
                    row[f] = []
        rows.append(row)
    return rows


@router.get("/eligible-inwards")
async def get_eligible_inwards(
    current_user: CurrentUser,
    db: DBSession,
    ledger_id: int = Query(...),
    fy: str = Query(default="2026_2027"),
    exclude_bill_id: Optional[int] = None
):
    """
    Returns Inward records for a given customer that:
    1. Belong to the given ledger (customer)
    2. Are FULLY completed through outward dispatches (balance qty <= 0.001)
    3. Have at least one completed outward transaction
    4. Have NOT already been billed in any Job Work Bill
    """
    schema = s(fy)
    await _ensure_tables(db, schema)

    exclude_sql = "AND jwb.id != :ex_bid" if exclude_bill_id else ""
    exclude_params = {"ex_bid": exclude_bill_id} if exclude_bill_id else {}

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
            COUNT(DISTINCT so.id) AS outward_count,
            string_agg(DISTINCT so.outward_no, ', ') AS outward_nos
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
        WHERE jwb.ledger_id = :lid {exclude_sql} AND jbl.inward_id IS NOT NULL
        UNION
        SELECT DISTINCT (elem)::int
        FROM {schema}.job_work_bills jwb,
             jsonb_array_elements_text(CASE WHEN jsonb_typeof(COALESCE(jwb.inward_ids, '[]'::jsonb)) = 'array' THEN jwb.inward_ids ELSE '[]'::jsonb END) AS elem
        WHERE jwb.ledger_id = :lid {exclude_sql} AND elem ~ '^[0-9]+$'
        UNION
        SELECT DISTINCT jwb.inward_id
        FROM {schema}.job_work_bills jwb
        WHERE jwb.ledger_id = :lid {exclude_sql} AND jwb.inward_id IS NOT NULL
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
        COALESCE(oc.outward_count, 0) AS outward_count,
        COALESCE(oc.outward_nos, '') AS outward_nos
    FROM inward_list il
    JOIN inward_total_qty itq ON itq.inward_id = il.id
    LEFT JOIN outward_dispatched_qty odq ON odq.inward_id = il.id
    LEFT JOIN outward_count oc ON oc.inward_id = il.id
    LEFT JOIN master.products p ON p.id = il.product_id
    WHERE
        -- Strictly fully completed: balance <= 0.001
        GREATEST(itq.total_inward_qty - COALESCE(odq.dispatched_qty, 0), 0) <= 0.001
        -- Has at least one completed outward
        AND COALESCE(oc.outward_count, 0) > 0
        -- Has NOT already been billed
        AND il.id NOT IN (SELECT inward_id FROM already_billed WHERE inward_id IS NOT NULL)
    ORDER BY il.inward_date DESC, il.inward_no DESC
    """
    params = {"lid": ledger_id, **exclude_params}
    result = await db.execute(text(query), params)
    rows = []
    for r in result.mappings().all():
        row = dict(r)
        if isinstance(row.get("items"), str):
            try:
                row["items"] = json.loads(row["items"])
            except Exception:
                row["items"] = []
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

    if not body.items or len(body.items) == 0:
        raise HTTPException(status_code=400, detail="Job Work Bill must have at least one bill line item.")

    # Validate that inward(s) belong to selected ledger and are not already billed
    raw_inward_ids = body.inward_ids or ([body.inward_id] if body.inward_id else [])
    clean_inward_ids = [int(x) for x in raw_inward_ids if str(x).isdigit()]

    if clean_inward_ids:
        inw_check = await db.execute(
            text(f"""
            SELECT id, inward_no, ledger_id FROM {schema}.stock_inward
            WHERE id = ANY(:iids)
            """),
            {"iids": clean_inward_ids}
        )
        inw_rows = inw_check.mappings().all()
        for inw in inw_rows:
            if inw["ledger_id"] != body.ledger_id:
                raise HTTPException(
                    status_code=400,
                    detail=f"Inward '{inw['inward_no']}' belongs to a different company."
                )

        # Check duplicate billing
        already_billed = await db.execute(
            text(f"""
            SELECT jwb.bill_no, jwb.inward_id, jwb.inward_ids
            FROM {schema}.job_work_bills jwb
            WHERE jwb.ledger_id = :lid
              AND (
                jwb.inward_id = ANY(:iids)
                OR (
                    jwb.inward_ids IS NOT NULL
                    AND jsonb_typeof(jwb.inward_ids) = 'array'
                    AND EXISTS (
                        SELECT 1 FROM jsonb_array_elements_text(jwb.inward_ids) elem
                        WHERE elem ~ '^[0-9]+$' AND elem::int = ANY(:iids)
                    )
                )
              )
            """),
            {"iids": clean_inward_ids, "lid": body.ledger_id}
        )
        dup_bill = already_billed.mappings().first()
        if dup_bill:
            raise HTTPException(
                status_code=400,
                detail=f"One or more selected Inwards have already been billed in Job Work Bill '{dup_bill['bill_no']}'."
            )

    # Validate Process Register pricing
    missing_rates = []
    for it in body.items:
        pid = it.get("process_id")
        if not pid or not str(pid).isdigit():
            continue
        p_res = await db.execute(
            text("SELECT id, name, company_rate, process_ids, process_code FROM master.processes WHERE id = :pid AND is_active = TRUE"),
            {"pid": int(pid)}
        )
        proc = p_res.mappings().first()
        if not proc:
            missing_rates.append(f"Process ID {pid} not found in master")
        else:
            crate = float(proc["company_rate"] or 0)
            # If rate is 0, check if it's a group process with component rates
            if crate <= 0 and proc.get("process_ids"):
                cids = [int(x.strip()) for x in str(proc["process_ids"]).split(",") if x.strip().isdigit()]
                if cids:
                    cres = await db.execute(text("SELECT SUM(company_rate) FROM master.processes WHERE id = ANY(:cids)"), {"cids": cids})
                    crate = float(cres.scalar() or 0)
            if crate <= 0:
                missing_rates.append(f"Process '{proc['name']}' has no active company rate in Process Register")

    if missing_rates:
        raise HTTPException(
            status_code=400,
            detail="Process Register pricing validation failed: " + "; ".join(missing_rates)
        )

    # Generate or validate bill_no
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

    dup_chk = await db.execute(
        text(f"SELECT id FROM {schema}.job_work_bills WHERE bill_no = :bno"),
        {"bno": bill_no}
    )
    if dup_chk.scalar_one_or_none():
        raise HTTPException(status_code=400, detail=f"Bill Number '{bill_no}' already exists.")

    items_json = json.dumps(body.items or [])
    freight_json = json.dumps(body.freight_items or [])
    inward_ids_json = json.dumps(clean_inward_ids)
    clean_outward_ids = [int(x) for x in (body.outward_ids or []) if str(x).isdigit()]
    outward_ids_json = json.dumps(clean_outward_ids)

    primary_inward_id = clean_inward_ids[0] if clean_inward_ids else None
    primary_prod_id = body.product_id or (body.items[0].get("product_id") if body.items else None)
    primary_proc_id = body.process_id or (body.items[0].get("process_id") if body.items else None)

    try:
        res = await db.execute(
            text(f"""
            INSERT INTO {schema}.job_work_bills
            (bill_no, bill_date, ledger_id, inward_id, inward_ids, outward_ids,
             product_id, process_id, quantity, rate, amount,
             gst_percent, gst_amount, cgst_percent, cgst_amount, sgst_percent, sgst_amount,
             round_off, net_amount, total_amount, narration, dispatch_through,
             items, freight_items, pending_amount, created_by)
            VALUES (:bno, CAST(:bdate AS DATE), :lid, :iid, :iids, :oids,
                    :pid, :prid, :qty, :rate, :amt,
                    :gp, :ga, :cgp, :cga, :sgp, :sga,
                    :ro, :namt, :ta, :narr, :dt,
                    :items, :fitems, :ta, :cby)
            RETURNING id
            """),
            {
                "bno": bill_no, "bdate": body.bill_date, "lid": body.ledger_id,
                "iid": primary_inward_id, "iids": inward_ids_json, "oids": outward_ids_json,
                "pid": int(primary_prod_id) if (primary_prod_id and str(primary_prod_id).isdigit()) else None,
                "prid": int(primary_proc_id) if (primary_proc_id and str(primary_proc_id).isdigit()) else None,
                "qty": body.quantity, "rate": body.rate, "amt": body.amount,
                "gp": body.gst_percent, "ga": body.gst_amount,
                "cgp": body.cgst_percent, "cga": body.cgst_amount,
                "sgp": body.sgst_percent, "sga": body.sgst_amount,
                "ro": body.round_off, "namt": body.net_amount or body.total_amount, "ta": body.total_amount,
                "narr": body.narration, "dt": body.dispatch_through,
                "items": items_json, "fitems": freight_json, "cby": current_user.id if current_user else None
            }
        )
        bill_id = res.scalar_one()
    except Exception as e:
        logger.exception("Failed to insert into job_work_bills")
        raise HTTPException(status_code=500, detail=f"Database error creating Job Work Bill: {str(e)}")

    # Insert individual snapshot lines for audit and historical immutability
    for it in (body.items or []):
        pid = it.get("process_id")
        if not pid or not str(pid).isdigit():
            continue
        try:
            p_res = await db.execute(
                text("SELECT name, process_code, company_rate FROM master.processes WHERE id = :pid"),
                {"pid": int(pid)}
            )
            proc_data = p_res.mappings().first()
            pname = proc_data["name"] if proc_data else "Process"
            pcode = proc_data.get("process_code") if proc_data else None
            rate_snap = float(it.get("rate") or (proc_data["company_rate"] if proc_data else 0))

            await db.execute(
                text(f"""
                INSERT INTO {schema}.job_work_bill_lines
                (bill_id, inward_id, outward_id, process_id, process_name, process_code,
                 process_rate, billable_quantity, process_amount, rate_snapshot)
                VALUES (:bid, :iid, :oid, :pid, :pname, :pcode,
                        :prate, :bqty, :pamt, :snap)
                """),
                {
                    "bid": bill_id, "iid": primary_inward_id,
                    "oid": clean_outward_ids[0] if clean_outward_ids else None,
                    "pid": int(pid), "pname": pname, "pcode": pcode,
                    "prate": rate_snap, "bqty": float(it.get("quantity") or 0),
                    "pamt": float(it.get("amount") or 0), "snap": rate_snap
                }
            )
        except Exception:
            pass

    return {"id": bill_id, "bill_no": bill_no, "message": "Job Work Bill created successfully."}


@router.put("/{bill_id}")
async def update_job_work_bill(
    bill_id: int,
    body: JobWorkBillIn,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    await _ensure_tables(db, schema)

    raw_inward_ids = body.inward_ids or ([body.inward_id] if body.inward_id else [])
    clean_inward_ids = [int(x) for x in raw_inward_ids if str(x).isdigit()]
    items_json = json.dumps(body.items or [])
    freight_json = json.dumps(body.freight_items or [])
    inward_ids_json = json.dumps(clean_inward_ids)
    clean_outward_ids = [int(x) for x in (body.outward_ids or []) if str(x).isdigit()]
    outward_ids_json = json.dumps(clean_outward_ids)

    primary_inward_id = clean_inward_ids[0] if clean_inward_ids else None
    primary_prod_id = body.product_id or (body.items[0].get("product_id") if body.items else None)
    primary_proc_id = body.process_id or (body.items[0].get("process_id") if body.items else None)

    await db.execute(
        text(f"""
        UPDATE {schema}.job_work_bills SET
            bill_no = :bno, bill_date = CAST(:bdate AS DATE), ledger_id = :lid,
            inward_id = :iid, inward_ids = :iids, outward_ids = :oids,
            product_id = :pid, process_id = :prid, quantity = :qty, rate = :rate, amount = :amt,
            gst_percent = :gp, gst_amount = :ga, cgst_percent = :cgp, cgst_amount = :cga,
            sgst_percent = :sgp, sgst_amount = :sga, round_off = :ro, net_amount = :namt,
            total_amount = :ta, narration = :narr, dispatch_through = :dt,
            items = :items, freight_items = :fitems, updated_at = NOW()
        WHERE id = :id
        """),
        {
            "bno": body.bill_no, "bdate": body.bill_date, "lid": body.ledger_id,
            "iid": primary_inward_id, "iids": inward_ids_json, "oids": outward_ids_json,
            "pid": int(primary_prod_id) if (primary_prod_id and str(primary_prod_id).isdigit()) else None,
            "prid": int(primary_proc_id) if (primary_proc_id and str(primary_proc_id).isdigit()) else None,
            "qty": body.quantity, "rate": body.rate, "amt": body.amount,
            "gp": body.gst_percent, "ga": body.gst_amount,
            "cgp": body.cgst_percent, "cga": body.cgst_amount,
            "sgp": body.sgst_percent, "sga": body.sgst_amount,
            "ro": body.round_off, "namt": body.net_amount or body.total_amount, "ta": body.total_amount,
            "narr": body.narration, "dt": body.dispatch_through,
            "items": items_json, "fitems": freight_json, "id": bill_id
        }
    )

    # Refresh lines
    await db.execute(text(f"DELETE FROM {schema}.job_work_bill_lines WHERE bill_id = :bid"), {"bid": bill_id})
    for it in (body.items or []):
        pid = it.get("process_id")
        if not pid or not str(pid).isdigit():
            continue
        try:
            p_res = await db.execute(
                text("SELECT name, process_code, company_rate FROM master.processes WHERE id = :pid"),
                {"pid": int(pid)}
            )
            proc_data = p_res.mappings().first()
            pname = proc_data["name"] if proc_data else "Process"
            pcode = proc_data.get("process_code") if proc_data else None
            rate_snap = float(it.get("rate") or (proc_data["company_rate"] if proc_data else 0))

            await db.execute(
                text(f"""
                INSERT INTO {schema}.job_work_bill_lines
                (bill_id, inward_id, outward_id, process_id, process_name, process_code,
                 process_rate, billable_quantity, process_amount, rate_snapshot)
                VALUES (:bid, :iid, :oid, :pid, :pname, :pcode,
                        :prate, :bqty, :pamt, :snap)
                """),
                {
                    "bid": bill_id, "iid": primary_inward_id,
                    "oid": clean_outward_ids[0] if clean_outward_ids else None,
                    "pid": int(pid), "pname": pname, "pcode": pcode,
                    "prate": rate_snap, "bqty": float(it.get("quantity") or 0),
                    "pamt": float(it.get("amount") or 0), "snap": rate_snap
                }
            )
        except Exception:
            pass

    return {"message": "Job Work Bill updated successfully"}


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
               l.gstin AS customer_gstin
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
    for f in ["items", "freight_items", "inward_ids", "outward_ids"]:
        if isinstance(bill.get(f), str):
            try:
                bill[f] = json.loads(bill[f])
            except Exception:
                bill[f] = []
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
    await db.execute(
        text(f"DELETE FROM {schema}.job_work_bills WHERE id = :id"),
        {"id": bill_id}
    )


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
        UPDATE {schema}.job_work_bills SET
            is_paid = TRUE, payment_status = 'PAID',
            paid_amount = total_amount, pending_amount = 0,
            payment_date = CAST(:pdate AS DATE), updated_at = NOW()
        WHERE id = :id
        """),
        {"pdate": payment_date, "id": bill_id}
    )
    return {"message": "Marked as paid"}
