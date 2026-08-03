"""
Reports API — all complex reporting queries for OrbX Nexus ERP.
All reports are filtered by financial year schema.
"""
from fastapi import APIRouter, Query
from sqlalchemy import text
from typing import Optional

from app.api.deps import CurrentUser, DBSession

router = APIRouter()


def s(fy: str) -> str:
    return f"fy_{fy}"


# ─────── Dashboard Summary ───────

@router.get("/dashboard-summary")
async def dashboard_summary(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    today_result = await db.execute(
        text(
            f"SELECT "
            f"  (SELECT COUNT(*) FROM {schema}.vouchers WHERE voucher_date = CURRENT_DATE) AS today_vouchers,"
            f"  (SELECT COALESCE(SUM(total_amount), 0) FROM {schema}.labour_bills WHERE is_paid = FALSE) AS pending_bills,"
            f"  (SELECT COUNT(*) FROM {schema}.stock_inward WHERE is_completed = FALSE) AS pending_inward,"
            f"  (SELECT COALESCE(SUM(quantity), 0) FROM {schema}.stock_inward WHERE inward_date = CURRENT_DATE) AS today_production"
        )
    )
    row = today_result.mappings().one()

    process_flow_result = await db.execute(
        text(
            f"SELECT "
            f"  TO_CHAR(tx_date, 'DD-Mon') AS day_label, "
            f"  tx_date AS day_date, "
            f"  SUM(inward_qty) AS inward_qty, "
            f"  SUM(inward_weight) AS inward_weight, "
            f"  SUM(outward_qty) AS outward_qty, "
            f"  SUM(outward_weight) AS outward_weight "
            f"FROM ( "
            f"  SELECT inward_date AS tx_date, COALESCE(quantity, 0) AS inward_qty, COALESCE(weight, 0) AS inward_weight, 0 AS outward_qty, 0 AS outward_weight "
            f"  FROM {schema}.stock_inward "
            f"  UNION ALL "
            f"  SELECT outward_date AS tx_date, 0 AS inward_qty, 0 AS inward_weight, COALESCE(quantity, 0) AS outward_qty, COALESCE(weight, 0) AS outward_weight "
            f"  FROM {schema}.stock_outward "
            f") sub "
            f"WHERE tx_date >= CURRENT_DATE - INTERVAL '30 days' "
            f"GROUP BY 1, 2 ORDER BY 2 ASC"
        )
    )
    process_chart = [
        {
            "day": str(r["day_label"]),
            "inward_qty": float(r["inward_qty"] or 0),
            "inward_weight": float(r["inward_weight"] or 0),
            "outward_qty": float(r["outward_qty"] or 0),
            "outward_weight": float(r["outward_weight"] or 0),
        }
        for r in process_flow_result.mappings().all()
    ]

    return {
        "today_vouchers": int(row["today_vouchers"] or 0),
        "pending_bills": float(row["pending_bills"] or 0),
        "pending_inward": int(row["pending_inward"] or 0),
        "today_production": float(row["today_production"] or 0),
        "process_chart": process_chart,
    }


# ─────── Day Book ───────

@router.get("/day-book")
async def day_book(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    from_date: str = Query(...), to_date: str = Query(...)
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"SELECT v.id, v.voucher_date::text, v.voucher_no, v.voucher_type, "
            f"l.name AS ledger_name, v.amount, v.narration "
            f"FROM {schema}.vouchers v "
            f"LEFT JOIN master.ledgers l ON l.id = v.ledger_id "
            f"WHERE v.voucher_date BETWEEN :fd AND :td "
            f"ORDER BY v.voucher_date, v.id"
        ),
        {"fd": from_date, "td": to_date}
    )
    return [dict(r) for r in result.mappings().all()]


# ─────── Ledger Account ───────

@router.get("/ledger-account")
async def ledger_account(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    ledger_id: int = Query(...), from_date: str = Query(...), to_date: str = Query(...)
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"SELECT v.voucher_date::text, v.voucher_no, v.voucher_type, "
            f"vl.dr_amount, vl.cr_amount, vl.narration "
            f"FROM {schema}.voucher_lines vl "
            f"JOIN {schema}.vouchers v ON v.id = vl.voucher_id "
            f"WHERE vl.ledger_id = :lid AND v.voucher_date BETWEEN :fd AND :td "
            f"ORDER BY v.voucher_date, v.id"
        ),
        {"lid": ledger_id, "fd": from_date, "td": to_date}
    )
    rows = [dict(r) for r in result.mappings().all()]
    total_dr = sum(float(r["dr_amount"] or 0) for r in rows)
    total_cr = sum(float(r["cr_amount"] or 0) for r in rows)
    return {"entries": rows, "total_dr": total_dr, "total_cr": total_cr, "balance": total_dr - total_cr}


# ─────── Inward Register ───────

@router.get("/inward-register")
async def inward_register(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    from_date: str = Query(...), to_date: str = Query(...)
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"SELECT si.id, si.inward_date::text, si.inward_no, "
            f"l.name AS ledger, COALESCE(NULLIF(si.serial_no, ''), '-') AS ref_no, "
            f"si.quantity, si.total_weight, si.is_completed "
            f"FROM {schema}.stock_inward si "
            f"LEFT JOIN master.ledgers l ON l.id = si.ledger_id "
            f"WHERE si.inward_date BETWEEN :fd AND :td ORDER BY si.inward_date, si.id"
        ),
        {"fd": from_date, "td": to_date}
    )
    return [dict(r) for r in result.mappings().all()]


# ─────── Outward Register ───────

@router.get("/outward-register")
async def outward_register(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    from_date: str = Query(...), to_date: str = Query(...)
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"SELECT so.id, so.outward_date::text, so.outward_no, "
            f"l.name AS ledger, "
            f"COALESCE("
            f"  (SELECT string_agg(COALESCE(NULLIF(si.serial_no, ''), si.inward_no), ', ' ORDER BY si.id) "
            f"   FROM {schema}.stock_inward si "
            f"   WHERE si.id IN (SELECT jsonb_array_elements_text(so.inward_ids)::int)), "
            f"  COALESCE(NULLIF(so.ref_no, ''), NULLIF(so.serial_no, ''), '-')"
            f") AS ref_no, "
            f"so.quantity, so.total_weight "
            f"FROM {schema}.stock_outward so "
            f"LEFT JOIN master.ledgers l ON l.id = so.ledger_id "
            f"WHERE so.outward_date BETWEEN :fd AND :td ORDER BY so.outward_date, so.id"
        ),
        {"fd": from_date, "td": to_date}
    )
    return [dict(r) for r in result.mappings().all()]


# ─────── Labour Bill Register ───────

@router.get("/labour-bill-register")
async def labour_bill_register(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    from_date: str = Query(...), to_date: str = Query(...)
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"SELECT lb.id, lb.bill_date::text, lb.bill_no, l.name AS ledger, "
            f"p.name AS product, pr.name AS process, lb.quantity, lb.rate, lb.amount, "
            f"lb.gst_percent, lb.gst_amount, lb.total_amount, lb.is_paid, lb.payment_date::text "
            f"FROM {schema}.labour_bills lb "
            f"LEFT JOIN master.ledgers l ON l.id = lb.ledger_id "
            f"LEFT JOIN master.products p ON p.id = lb.product_id "
            f"LEFT JOIN master.processes pr ON pr.id = lb.process_id "
            f"WHERE lb.bill_date BETWEEN :fd AND :td ORDER BY lb.bill_date, lb.id"
        ),
        {"fd": from_date, "td": to_date}
    )
    return [dict(r) for r in result.mappings().all()]


# ─────── Trial Balance ───────

@router.get("/trial-balance")
async def trial_balance(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    as_of_date: str = Query(...)
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"SELECT l.id, l.name AS ledger, lg.name AS grp, "
            f"l.opening_balance, l.balance_type AS ob_type, "
            f"COALESCE(SUM(vl.dr_amount), 0) AS total_dr, "
            f"COALESCE(SUM(vl.cr_amount), 0) AS total_cr "
            f"FROM master.ledgers l "
            f"LEFT JOIN master.ledger_groups lg ON lg.id = l.group_id "
            f"LEFT JOIN {schema}.voucher_lines vl ON vl.ledger_id = l.id "
            f"LEFT JOIN {schema}.vouchers v ON v.id = vl.voucher_id AND v.voucher_date <= :aod "
            f"WHERE l.is_active = TRUE "
            f"GROUP BY l.id, l.name, lg.name, l.opening_balance, l.balance_type "
            f"ORDER BY lg.name, l.name"
        ),
        {"aod": as_of_date}
    )
    rows = []
    for r in result.mappings().all():
        ob = float(r["opening_balance"] or 0)
        dr = float(r["total_dr"] or 0) + (ob if r["ob_type"] == "Dr" else 0)
        cr = float(r["total_cr"] or 0) + (ob if r["ob_type"] == "Cr" else 0)
        rows.append({**dict(r), "closing_dr": dr if dr > cr else 0, "closing_cr": cr if cr > dr else 0})
    return rows


# ─────── Stock in Hand ───────

@router.get("/stock-in-hand")
async def stock_in_hand(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    as_of_date: str = Query(...),
    ledger_id: Optional[int] = Query(default=None)
):
    import json
    schema = s(fy)

    # 1. Fetch ledgers map and products map
    ledgers_res = await db.execute(text("SELECT id, name FROM master.ledgers"))
    ledger_map = {r["id"]: r["name"] for r in ledgers_res.mappings().all()}

    products_res = await db.execute(text("SELECT id, name FROM master.products"))
    product_map = {r["id"]: r["name"] for r in products_res.mappings().all()}

    # 2. Fetch stock inward records up to as_of_date
    conds = ["si.inward_date <= :aod"]
    params: dict = {"aod": as_of_date}
    if ledger_id and ledger_id > 0:
        conds.append("si.ledger_id = :lid")
        params["lid"] = ledger_id

    inward_res = await db.execute(
        text(f"SELECT * FROM {schema}.stock_inward si WHERE {' AND '.join(conds)} ORDER BY si.inward_date DESC, si.id DESC"),
        params
    )
    inward_rows = inward_res.mappings().all()

    # 3. Fetch stock outward records up to as_of_date
    outward_res = await db.execute(
        text(f"SELECT * FROM {schema}.stock_outward WHERE outward_date <= :aod"),
        {"aod": as_of_date}
    )
    outward_rows = outward_res.mappings().all()

    # Build dispatched map: (inward_id, product_id, process_id) -> total_dispatched
    dispatched_map: dict = {}
    for so in outward_rows:
        so_dict = dict(so)
        inw_ids = []
        if so_dict.get("inward_id"):
            inw_ids.append(so_dict["inward_id"])
        if so_dict.get("inward_ids"):
            raw_ids = so_dict["inward_ids"]
            if isinstance(raw_ids, str):
                try: raw_ids = json.loads(raw_ids)
                except Exception: raw_ids = []
            if isinstance(raw_ids, list):
                inw_ids.extend([int(x) for x in raw_ids if x])

        items = so_dict.get("items")
        if isinstance(items, str):
            try: items = json.loads(items)
            except Exception: items = []

        if items and isinstance(items, list) and len(items) > 0:
            for item in items:
                p_id = item.get("product_id") or so_dict.get("product_id")
                pr_id = item.get("process_id") or so_dict.get("process_id")
                qty = float(item.get("quantity") or 0)
                for iid in inw_ids:
                    key = (int(iid), int(p_id) if p_id else None, str(pr_id) if pr_id else None)
                    dispatched_map[key] = dispatched_map.get(key, 0.0) + qty
        else:
            p_id = so_dict.get("product_id")
            pr_id = so_dict.get("process_id")
            qty = float(so_dict.get("quantity") or 0)
            for iid in inw_ids:
                key = (int(iid), int(p_id) if p_id else None, str(pr_id) if pr_id else None)
                dispatched_map[key] = dispatched_map.get(key, 0.0) + qty

    # 4. Unroll inward line items and calculate balance
    result_list = []
    for si in inward_rows:
        si_dict = dict(si)
        inward_id = si_dict["id"]
        inward_no = si_dict["inward_no"]
        inward_date = str(si_dict["inward_date"])
        ref_no = si_dict.get("ref_no") or si_dict.get("serial_no") or "-"
        lid = si_dict.get("ledger_id")
        supplier_name = ledger_map.get(lid, "Unknown Supplier")

        raw_items = si_dict.get("items")
        if isinstance(raw_items, str):
            try: raw_items = json.loads(raw_items)
            except Exception: raw_items = []

        unrolled_items = []
        if raw_items and isinstance(raw_items, list) and len(raw_items) > 0:
            for item in raw_items:
                unrolled_items.append({
                    "product_id": item.get("product_id"),
                    "process_id": item.get("process_id"),
                    "quantity": float(item.get("quantity") or 0),
                    "weight": float(item.get("weight") or 0),
                })
        else:
            if si_dict.get("product_id") or float(si_dict.get("quantity") or 0) > 0:
                unrolled_items.append({
                    "product_id": si_dict.get("product_id"),
                    "process_id": si_dict.get("process_id"),
                    "quantity": float(si_dict.get("quantity") or 0),
                    "weight": float(si_dict.get("weight") or 0),
                })

        for item in unrolled_items:
            p_id = item["product_id"]
            pr_id = item["process_id"]
            line_qty = item["quantity"]
            unit_weight = item["weight"]

            key = (int(inward_id), int(p_id) if p_id else None, str(pr_id) if pr_id else None)
            dispatched = dispatched_map.get(key, 0.0)
            if dispatched == 0 and p_id:
                dispatched = dispatched_map.get((int(inward_id), int(p_id), None), 0.0)

            balance_qty = max(0.0, line_qty - dispatched)
            if balance_qty > 0:
                p_name = product_map.get(p_id, f"Product #{p_id}" if p_id else "General Item")
                result_list.append({
                    "inward_no": inward_no,
                    "inward_date": inward_date,
                    "ref_no": ref_no,
                    "product": p_name,
                    "ledger_id": lid,
                    "supplier_name": supplier_name,
                    "balance_qty": balance_qty,
                    "balance_weight": balance_qty * unit_weight,
                })

    return result_list
    return [dict(r) for r in result.mappings().all()]


# ─────── Receivables / Payables ───────

@router.get("/receivables")
async def receivables(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    as_of_date: str = Query(...)
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"SELECT l.id, l.name AS ledger, lg.name AS grp, "
            f"COALESCE(SUM(vl.dr_amount), 0) - COALESCE(SUM(vl.cr_amount), 0) AS balance "
            f"FROM master.ledgers l "
            f"JOIN master.ledger_groups lg ON lg.id = l.group_id AND lg.group_type = 'Assets' "
            f"LEFT JOIN {schema}.voucher_lines vl ON vl.ledger_id = l.id "
            f"LEFT JOIN {schema}.vouchers v ON v.id = vl.voucher_id AND v.voucher_date <= :aod "
            f"GROUP BY l.id, l.name, lg.name "
            f"HAVING COALESCE(SUM(vl.dr_amount), 0) - COALESCE(SUM(vl.cr_amount), 0) > 0 "
            f"ORDER BY l.name"
        ),
        {"aod": as_of_date}
    )
    return [dict(r) for r in result.mappings().all()]


@router.get("/payables")
async def payables(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    as_of_date: str = Query(...)
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"SELECT l.id, l.name AS ledger, lg.name AS grp, "
            f"COALESCE(SUM(vl.cr_amount), 0) - COALESCE(SUM(vl.dr_amount), 0) AS balance "
            f"FROM master.ledgers l "
            f"JOIN master.ledger_groups lg ON lg.id = l.group_id AND lg.group_type = 'Liability' "
            f"LEFT JOIN {schema}.voucher_lines vl ON vl.ledger_id = l.id "
            f"LEFT JOIN {schema}.vouchers v ON v.id = vl.voucher_id AND v.voucher_date <= :aod "
            f"GROUP BY l.id, l.name, lg.name "
            f"HAVING COALESCE(SUM(vl.cr_amount), 0) - COALESCE(SUM(vl.dr_amount), 0) > 0 "
            f"ORDER BY l.name"
        ),
        {"aod": as_of_date}
    )
    return [dict(r) for r in result.mappings().all()]


# ─────── Monthly Report ───────

@router.get("/monthly-report")
async def monthly_report(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    month: int = Query(...), year: int = Query(...)
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"SELECT voucher_type, SUM(amount) AS total "
            f"FROM {schema}.vouchers "
            f"WHERE EXTRACT(MONTH FROM voucher_date) = :m AND EXTRACT(YEAR FROM voucher_date) = :y "
            f"GROUP BY voucher_type"
        ),
        {"m": month, "y": year}
    )
    return [dict(r) for r in result.mappings().all()]


# ─────── Pending Bills ───────

@router.get("/pending-bills")
async def pending_bills(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"SELECT lb.id, lb.bill_date::text, lb.bill_no, l.name AS ledger, "
            f"lb.total_amount, lb.narration "
            f"FROM {schema}.labour_bills lb "
            f"LEFT JOIN master.ledgers l ON l.id = lb.ledger_id "
            f"WHERE lb.is_paid = FALSE ORDER BY lb.bill_date"
        )
    )
    return [dict(r) for r in result.mappings().all()]


# ─────── Staff Salary Account ───────

@router.get("/staff-salary-account")
async def staff_salary_account(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    ledger_id: Optional[int] = Query(None), month: Optional[int] = Query(None), year: Optional[int] = Query(None)
):
    schema = s(fy)
    conds = ["l.ledger_type = 'Staff'"]
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
            f"SELECT sv.*, l.name AS ledger_name "
            f"FROM {schema}.salary_vouchers sv "
            f"JOIN master.ledgers l ON l.id = sv.ledger_id "
            f"WHERE {' AND '.join(conds)} ORDER BY sv.voucher_date DESC"
        ),
        params
    )
    return [dict(r) for r in result.mappings().all()]


# ─────── EB Consumption ───────

@router.get("/eb-consumption")
async def eb_consumption(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    from_date: str = Query(...), to_date: str = Query(...)
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"SELECT reading_date::text, meter_no, previous_reading, current_reading, "
            f"units_consumed, rate_per_unit, amount FROM {schema}.eb_readings "
            f"WHERE reading_date BETWEEN :fd AND :td ORDER BY reading_date"
        ),
        {"fd": from_date, "td": to_date}
    )
    rows = [dict(r) for r in result.mappings().all()]
    total_units = sum(float(r["units_consumed"] or 0) for r in rows)
    total_amount = sum(float(r["amount"] or 0) for r in rows)
    return {"entries": rows, "total_units": total_units, "total_amount": total_amount}


# ─────── Stock Summary ───────

@router.get("/stock-summary")
async def stock_summary(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    from_date: str = Query(None), to_date: str = Query(None)
):
    schema = s(fy)
    conds_in = []
    conds_out = []
    params = {}
    
    if from_date:
        conds_in.append("si.inward_date >= :fd")
        conds_out.append("so.outward_date >= :fd")
        params["fd"] = from_date
    if to_date:
        conds_in.append("si.inward_date <= :td")
        conds_out.append("so.outward_date <= :td")
        params["td"] = to_date
        
    where_in = f"WHERE {' AND '.join(conds_in)}" if conds_in else ""
    where_out = f"WHERE {' AND '.join(conds_out)}" if conds_out else ""
    
    query = f"""
    SELECT 
      inward_date::text AS tx_date,
      inward_no AS voucher_no,
      COALESCE(NULLIF(ref_no, ''), NULLIF(serial_no, ''), '-') AS ref_no,
      l.name AS particulars,
      quantity AS inward_qty,
      weight AS inward_weight,
      0::numeric AS outward_qty,
      0::numeric AS outward_weight
    FROM {schema}.stock_inward si
    LEFT JOIN master.ledgers l ON l.id = si.ledger_id
    {where_in}

    UNION ALL

    SELECT 
      outward_date::text AS tx_date,
      outward_no AS voucher_no,
      COALESCE(NULLIF(ref_no, ''), NULLIF(serial_no, ''), '-') AS ref_no,
      l.name AS particulars,
      0::numeric AS inward_qty,
      0::numeric AS inward_weight,
      quantity AS outward_qty,
      weight AS outward_weight
    FROM {schema}.stock_outward so
    LEFT JOIN master.ledgers l ON l.id = so.ledger_id
    {where_out}

    ORDER BY tx_date ASC, voucher_no ASC
    """
    
    result = await db.execute(text(query), params)
    return [dict(r) for r in result.mappings().all()]

