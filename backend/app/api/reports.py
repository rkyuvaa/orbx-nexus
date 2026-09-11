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
            f"  (SELECT COALESCE(SUM(qty), 0) FROM ("
            f"     SELECT quantity AS qty FROM {schema}.stock_inward WHERE inward_date = CURRENT_DATE AND jsonb_array_length(COALESCE(items, '[]'::jsonb)) = 0"
            f"     UNION ALL "
            f"     SELECT (item->>'quantity')::numeric AS qty FROM {schema}.stock_inward, jsonb_array_elements(COALESCE(items, '[]'::jsonb)) AS item WHERE inward_date = CURRENT_DATE AND jsonb_array_length(COALESCE(items, '[]'::jsonb)) > 0"
            f"   ) t) AS today_production"
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
            f"  SELECT si.inward_date AS tx_date, si.quantity AS inward_qty, COALESCE(NULLIF(si.total_weight, 0), si.weight, 0) AS inward_weight, 0 AS outward_qty, 0 AS outward_weight FROM {schema}.stock_inward si WHERE jsonb_array_length(COALESCE(si.items, '[]'::jsonb)) = 0 "
            f"  UNION ALL "
            f"  SELECT si.inward_date AS tx_date, COALESCE((item->>'quantity')::numeric, 0) AS inward_qty, COALESCE((item->>'total_weight')::numeric, (item->>'weight')::numeric, 0) AS inward_weight, 0 AS outward_qty, 0 AS outward_weight FROM {schema}.stock_inward si, jsonb_array_elements(COALESCE(si.items, '[]'::jsonb)) AS item WHERE jsonb_array_length(COALESCE(si.items, '[]'::jsonb)) > 0 "
            f"  UNION ALL "
            f"  SELECT so.outward_date AS tx_date, 0 AS inward_qty, 0 AS inward_weight, so.quantity AS outward_qty, COALESCE(NULLIF(so.total_weight, 0), so.weight, 0) AS outward_weight FROM {schema}.stock_outward so WHERE jsonb_array_length(COALESCE(so.items, '[]'::jsonb)) = 0 "
            f"  UNION ALL "
            f"  SELECT so.outward_date AS tx_date, 0 AS inward_qty, 0 AS inward_weight, COALESCE((item->>'quantity')::numeric, 0) AS outward_qty, COALESCE((item->>'total_weight')::numeric, (item->>'weight')::numeric, 0) AS outward_weight FROM {schema}.stock_outward so, jsonb_array_elements(COALESCE(so.items, '[]'::jsonb)) AS item WHERE jsonb_array_length(COALESCE(so.items, '[]'::jsonb)) > 0 "
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

def _norm_date(d_str: str | None) -> str | None:
    if not d_str:
        return None
    d_str = str(d_str).strip()
    if not d_str:
        return None
    if "-" in d_str:
        parts = d_str.split("-")
        if len(parts) == 3:
            if len(parts[0]) == 2 and len(parts[2]) == 4:
                return f"{parts[2]}-{parts[1].zfill(2)}-{parts[0].zfill(2)}"
            elif len(parts[0]) == 4:
                return f"{parts[0]}-{parts[1].zfill(2)}-{parts[2].zfill(2)}"
    elif "/" in d_str:
        parts = d_str.split("/")
        if len(parts) == 3:
            if len(parts[0]) == 2 and len(parts[2]) == 4:
                return f"{parts[2]}-{parts[1].zfill(2)}-{parts[0].zfill(2)}"
            elif len(parts[0]) == 4:
                return f"{parts[0]}-{parts[1].zfill(2)}-{parts[2].zfill(2)}"
    return d_str


@router.get("/day-book")
async def day_book(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    from_date: str = Query(default=None), to_date: str = Query(default=None)
):
    schema = s(fy)
    fd = _norm_date(from_date)
    td = _norm_date(to_date)

    entries = []

    conds_mov = []
    params = {}
    if fd:
        conds_mov.append("m.movement_date >= CAST(:fd AS date)")
        params["fd"] = fd
    if td:
        conds_mov.append("m.movement_date <= CAST(:td AS date)")
        params["td"] = td

    where_mov = ("WHERE " + " AND ".join(conds_mov)) if conds_mov else ""

    # 1. Stock Movements (Inward Purchase & Outward)
    try:
        res_movements = await db.execute(
            text(
                f"SELECT m.id, m.movement_date::text AS voucher_date, m.movement_no AS voucher_no, "
                f"CASE WHEN m.movement_type = 'Inward' THEN 'Purchase' ELSE 'Outward' END AS voucher_type, "
                f"COALESCE(l.name, 'Unassigned Ledger') AS ledger_name, m.amount, "
                f"COALESCE(m.stock_item_name, 'Stock Movement') AS narration, "
                f"CASE WHEN m.movement_type = 'Inward' THEN 0 ELSE m.amount END AS dr_amount, "
                f"CASE WHEN m.movement_type = 'Inward' THEN m.amount ELSE 0 END AS cr_amount, "
                f"m.paid_amount, m.payment_date::text AS payment_date, m.payment_mode, m.payment_notes "
                f"FROM {schema}.stock_item_movements m "
                f"LEFT JOIN master.ledgers l ON l.id = m.ledger_id "
                f"{where_mov} "
                f"ORDER BY m.movement_date, m.id"
            ),
            params
        )
        for r in res_movements.mappings().all():
            d = dict(r)
            entries.append({
                "id": f"mov-{d['id']}",
                "voucher_date": d["voucher_date"],
                "voucher_no": d["voucher_no"],
                "voucher_type": d["voucher_type"],
                "ledger_name": d["ledger_name"],
                "particulars": d["narration"],
                "dr_amount": float(d["dr_amount"] or 0),
                "cr_amount": float(d["cr_amount"] or 0),
                "amount": float(d["amount"] or 0),
                "narration": d["narration"] or "",
            })

            # Add Supplier Payment entry if paid_amount > 0 and payment date is in range
            paid_amt = float(d["paid_amount"] or 0)
            p_date = d["payment_date"] or d["voucher_date"]
            if paid_amt > 0:
                in_range = True
                if fd and p_date < fd:
                    in_range = False
                if td and p_date > td:
                    in_range = False
                if in_range:
                    pmode = d["payment_mode"] or "Direct Payment"
                    pnotes = f" ({d['payment_notes']})" if d["payment_notes"] else ""
                    entries.append({
                        "id": f"pay-{d['id']}",
                        "voucher_date": p_date,
                        "voucher_no": f"PAY-{d['voucher_no']}",
                        "voucher_type": "Payment",
                        "ledger_name": d["ledger_name"],
                        "particulars": f"Payment via {pmode}{pnotes}",
                        "dr_amount": paid_amt,
                        "cr_amount": 0.0,
                        "amount": paid_amt,
                        "narration": f"Payment against {d['voucher_no']} ({pmode})",
                    })
    except Exception as e:
        print("Daybook error movements:", e)

    # 2. Vouchers (Payment, Receipt, Contra, Journal, Misc. Expenses)
    conds_v = []
    if fd:
        conds_v.append("v.voucher_date >= CAST(:fd AS date)")
    if td:
        conds_v.append("v.voucher_date <= CAST(:td AS date)")
    where_v = ("WHERE " + " AND ".join(conds_v)) if conds_v else ""

    try:
        res_vouchers = await db.execute(
            text(
                f"SELECT v.id, v.voucher_date::text, v.voucher_no, v.voucher_type, "
                f"COALESCE(l.name, 'General Ledger') AS ledger_name, v.amount, v.narration "
                f"FROM {schema}.vouchers v "
                f"LEFT JOIN master.ledgers l ON l.id = v.ledger_id "
                f"{where_v} "
                f"ORDER BY v.voucher_date, v.id"
            ),
            params
        )
        for r in res_vouchers.mappings().all():
            d = dict(r)
            vtype = d["voucher_type"]
            amt = float(d["amount"] or 0)
            dr = amt if vtype in ("Payment", "Misc. Expenses", "Contra") else 0.0
            cr = amt if vtype in ("Receipt", "Purchase", "Journal") else 0.0
            entries.append({
                "id": f"vouch-{d['id']}",
                "voucher_date": d["voucher_date"],
                "voucher_no": d["voucher_no"],
                "voucher_type": vtype,
                "ledger_name": d["ledger_name"],
                "particulars": d["narration"] or vtype,
                "dr_amount": dr,
                "cr_amount": cr,
                "amount": amt,
                "narration": d["narration"] or "",
            })
    except Exception as e:
        print("Daybook error vouchers:", e)

    # 3. Labour Bills
    conds_lb = []
    if fd:
        conds_lb.append("lb.bill_date >= CAST(:fd AS date)")
    if td:
        conds_lb.append("lb.bill_date <= CAST(:td AS date)")
    where_lb = ("WHERE " + " AND ".join(conds_lb)) if conds_lb else ""

    try:
        res_labour = await db.execute(
            text(
                f"SELECT lb.id, lb.bill_date::text AS voucher_date, lb.bill_no AS voucher_no, "
                f"'Labour Bill' AS voucher_type, COALESCE(l.name, 'Labour Party') AS ledger_name, "
                f"lb.total_amount AS amount, lb.notes AS narration "
                f"FROM {schema}.labour_bills lb "
                f"LEFT JOIN master.ledgers l ON l.id = lb.ledger_id "
                f"{where_lb} "
                f"ORDER BY lb.bill_date, lb.id"
            ),
            params
        )
        for r in res_labour.mappings().all():
            d = dict(r)
            amt = float(d["amount"] or 0)
            entries.append({
                "id": f"lb-{d['id']}",
                "voucher_date": d["voucher_date"],
                "voucher_no": d["voucher_no"],
                "voucher_type": "Labour Bill",
                "ledger_name": d["ledger_name"],
                "particulars": d["narration"] or "Labour Bill Entry",
                "dr_amount": 0.0,
                "cr_amount": amt,
                "amount": amt,
                "narration": d["narration"] or "",
            })
    except Exception as e:
        print("Daybook error labour:", e)

    # Sort all combined day book entries chronologically by voucher_date
    entries.sort(key=lambda x: (x["voucher_date"], str(x["id"])))

    return entries


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
        text(f"SELECT * FROM {schema}.stock_inward si WHERE {' AND '.join(conds)} ORDER BY si.inward_date ASC, si.id ASC"),
        params
    )
    inward_rows = inward_res.mappings().all()

    # 3. Fetch stock outward records up to as_of_date
    outward_res = await db.execute(
        text(f"SELECT * FROM {schema}.stock_outward WHERE outward_date <= :aod"),
        {"aod": as_of_date}
    )
    outward_rows = outward_res.mappings().all()

    inward_quantities = {}
    inward_item_list = []

    for si in inward_rows:
        si_dict = dict(si)
        inward_id = int(si_dict["id"])
        lid = si_dict.get("ledger_id")
        raw_items = si_dict.get("items")
        if isinstance(raw_items, str):
            try: raw_items = json.loads(raw_items)
            except Exception: raw_items = []

        unrolled_items = []
        if raw_items and isinstance(raw_items, list) and len(raw_items) > 0:
            for item in raw_items:
                unrolled_items.append({
                    "product_id": item.get("product_id"),
                    "quantity": float(item.get("quantity") or 0),
                    "weight": float(item.get("weight") or 0)
                })
        else:
            if si_dict.get("product_id") or float(si_dict.get("quantity") or 0) > 0:
                unrolled_items.append({
                    "product_id": si_dict.get("product_id"),
                    "quantity": float(si_dict.get("quantity") or 0),
                    "weight": float(si_dict.get("weight") or 0)
                })

        for item in unrolled_items:
            p_id = item["product_id"]
            if p_id:
                p_id = int(p_id)
                key = (inward_id, p_id)
                inward_quantities[key] = inward_quantities.get(key, 0.0) + item["quantity"]
                inward_item_list.append({
                    "inward_id": inward_id,
                    "inward_no": si_dict["inward_no"],
                    "inward_date": str(si_dict["inward_date"]),
                    "ref_no": si_dict.get("ref_no") or si_dict.get("serial_no") or "-",
                    "product_id": p_id,
                    "ledger_id": lid,
                    "quantity": item["quantity"],
                    "weight": item["weight"],
                })

    dispatched_pool = {}

    for so in outward_rows:
        so_dict = dict(so)
        inw_ids = []
        if so_dict.get("inward_id"):
            inw_ids.append(int(so_dict["inward_id"]))
        if so_dict.get("inward_ids"):
            raw_ids = so_dict["inward_ids"]
            if isinstance(raw_ids, str):
                try: raw_ids = json.loads(raw_ids)
                except Exception: raw_ids = []
            if isinstance(raw_ids, list):
                for x in raw_ids:
                    if x and int(x) not in inw_ids:
                        inw_ids.append(int(x))

        raw_items = so_dict.get("items")
        if isinstance(raw_items, str):
            try: raw_items = json.loads(raw_items)
            except Exception: raw_items = []

        outward_items = []
        if raw_items and isinstance(raw_items, list) and len(raw_items) > 0:
            for item in raw_items:
                outward_items.append({
                    "product_id": item.get("product_id") or so_dict.get("product_id"),
                    "quantity": float(item.get("quantity") or 0)
                })
        else:
            if so_dict.get("product_id") or float(so_dict.get("quantity") or 0) > 0:
                outward_items.append({
                    "product_id": so_dict.get("product_id"),
                    "quantity": float(so_dict.get("quantity") or 0)
                })

        for item in outward_items:
            p_id = item["product_id"]
            if not p_id:
                continue
            p_id = int(p_id)
            remaining_qty = item["quantity"]

            matching_inwards = [iid for iid in inw_ids if (iid, p_id) in inward_quantities]
            for iid in matching_inwards:
                if remaining_qty <= 0:
                    break
                inw_key = (iid, p_id)
                init_qty = inward_quantities.get(inw_key, 0.0)
                already_disp = dispatched_pool.get(inw_key, 0.0)
                avail_qty = max(0.0, init_qty - already_disp)
                if avail_qty > 0:
                    alloc = min(avail_qty, remaining_qty)
                    dispatched_pool[inw_key] = already_disp + alloc
                    remaining_qty -= alloc

            if remaining_qty > 0:
                for inw_item in inward_item_list:
                    if remaining_qty <= 0:
                        break
                    if inw_item["product_id"] == p_id:
                        if ledger_id and ledger_id > 0 and inw_item["ledger_id"] != ledger_id:
                            continue
                        inw_key = (inw_item["inward_id"], p_id)
                        init_qty = inward_quantities.get(inw_key, 0.0)
                        already_disp = dispatched_pool.get(inw_key, 0.0)
                        avail_qty = max(0.0, init_qty - already_disp)
                        if avail_qty > 0:
                            alloc = min(avail_qty, remaining_qty)
                            dispatched_pool[inw_key] = already_disp + alloc
                            remaining_qty -= alloc

    result_list = []
    remaining_dispatched = {k: v for k, v in dispatched_pool.items()}

    for item in inward_item_list:
        inward_id = item["inward_id"]
        p_id = item["product_id"]
        line_qty = item["quantity"]
        unit_weight = item["weight"]
        lid = item["ledger_id"]
        supplier_name = ledger_map.get(lid, "Unknown Supplier")

        pool_key = (inward_id, p_id)
        dispatched_to_subtract = 0.0
        if pool_key in remaining_dispatched:
            avail = remaining_dispatched[pool_key]
            sub = min(line_qty, avail)
            dispatched_to_subtract = sub
            remaining_dispatched[pool_key] = avail - sub

        balance_qty = max(0.0, line_qty - dispatched_to_subtract)
        if balance_qty > 0:
            p_name = product_map.get(p_id, f"Product #{p_id}")
            result_list.append({
                "inward_no": item["inward_no"],
                "inward_date": item["inward_date"],
                "ref_no": item["ref_no"],
                "product": p_name,
                "ledger_id": lid,
                "supplier_name": supplier_name,
                "balance_qty": balance_qty,
                "balance_weight": balance_qty * unit_weight,
            })

    return result_list


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


# ─────── Receivables (Labour Bills) ───────

@router.get("/receivables")
async def receivables(
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
    ledger_id: Optional[int] = Query(None),
):
    """
    Returns unpaid labour bills with aging buckets and per-ledger subtotals.
    Aging is calculated from bill_date to today.
    """
    schema = s(fy)
    ledger_filter = "AND lb.ledger_id = :lid" if ledger_id else ""
    params: dict = {}
    if ledger_id:
        params["lid"] = ledger_id

    result = await db.execute(
        text(
            f"SELECT "
            f"  lb.id, "
            f"  lb.bill_no, "
            f"  lb.bill_date::text, "
            f"  lb.ledger_id, "
            f"  l.name AS ledger_name, "
            f"  lb.total_amount, "
            f"  lb.net_amount, "
            f"  lb.narration, "
            f"  lb.dispatch_through, "
            f"  lb.is_paid, "
            f"  lb.payment_date::text, "
            f"  (CURRENT_DATE - lb.bill_date::date) AS days_outstanding "
            f"FROM {schema}.labour_bills lb "
            f"LEFT JOIN master.ledgers l ON l.id = lb.ledger_id "
            f"WHERE lb.is_paid = FALSE {ledger_filter} "
            f"ORDER BY l.name ASC, lb.bill_date ASC"
        ),
        params,
    )
    rows = [dict(r) for r in result.mappings().all()]

    # Compute aging bucket for each row
    for row in rows:
        days = int(row.get("days_outstanding") or 0)
        if days <= 30:
            row["aging_bucket"] = "0-30 days"
        elif days <= 60:
            row["aging_bucket"] = "31-60 days"
        elif days <= 90:
            row["aging_bucket"] = "61-90 days"
        else:
            row["aging_bucket"] = "90+ days"
        row["days_outstanding"] = days

    return rows




# ─────── Purchase Payables ───────

@router.get("/payables")
async def purchase_payables(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    from_date: str = Query(None), to_date: str = Query(None),
    ledger_id: int = Query(None),
):
    """Returns all Inward (Purchase) movements grouped to show outstanding payables per supplier."""
    schema = s(fy)
    conds = ["m.movement_type = 'Inward'"]
    params: dict = {}
    if from_date:
        conds.append("m.movement_date >= :fd")
        params["fd"] = from_date
    if to_date:
        conds.append("m.movement_date <= :td")
        params["td"] = to_date
    if ledger_id:
        conds.append("m.ledger_id = :lid")
        params["lid"] = ledger_id
    where = " AND ".join(conds)
    result = await db.execute(
        text(
            f"SELECT m.id, m.movement_no, m.movement_date::text, m.movement_type, "
            f"m.amount, m.ref_no, m.narration, "
            f"l.name AS supplier, "
            f"si.name AS stock_item_name, "
            f"m.quantity, m.rate, "
            f"u.symbol AS uom "
            f"FROM {schema}.stock_item_movements m "
            f"LEFT JOIN master.ledgers l ON l.id = m.ledger_id "
            f"LEFT JOIN master.stock_items si ON si.id = m.stock_item_id "
            f"LEFT JOIN master.units_of_measure u ON u.id = m.uom_id "
            f"WHERE {where} "
            f"ORDER BY m.movement_date DESC, m.id DESC"
        ),
        params,
    )
    return [dict(r) for r in result.mappings().all()]



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
        
    where_in_and = f"AND {' AND '.join(conds_in)}" if conds_in else ""
    where_out_and = f"AND {' AND '.join(conds_out)}" if conds_out else ""
    
    query = f"""
    WITH in_unrolled AS (
      SELECT 
        si.id,
        si.inward_date::text AS tx_date,
        si.inward_no AS voucher_no,
        COALESCE(NULLIF(si.ref_no, ''), NULLIF(si.serial_no, ''), '-') AS ref_no,
        si.ledger_id,
        si.quantity AS qty,
        COALESCE(NULLIF(si.total_weight, 0), si.weight, 0) AS wt
      FROM {schema}.stock_inward si
      WHERE jsonb_array_length(COALESCE(si.items, '[]'::jsonb)) = 0 {where_in_and}
      UNION ALL
      SELECT 
        si.id,
        si.inward_date::text AS tx_date,
        si.inward_no AS voucher_no,
        COALESCE(NULLIF(si.ref_no, ''), NULLIF(si.serial_no, ''), '-') AS ref_no,
        si.ledger_id,
        COALESCE((item->>'quantity')::numeric, 0) AS qty,
        COALESCE((item->>'total_weight')::numeric, (item->>'weight')::numeric, 0) AS wt
      FROM {schema}.stock_inward si,
        jsonb_array_elements(COALESCE(si.items, '[]'::jsonb)) AS item
      WHERE jsonb_array_length(COALESCE(si.items, '[]'::jsonb)) > 0 {where_in_and}
    ),
    in_grouped AS (
      SELECT 
        id, tx_date, voucher_no, ref_no, ledger_id,
        SUM(qty) AS inward_qty,
        SUM(wt) AS inward_weight,
        0::numeric AS outward_qty,
        0::numeric AS outward_weight
      FROM in_unrolled
      GROUP BY id, tx_date, voucher_no, ref_no, ledger_id
    ),
    out_unrolled AS (
      SELECT 
        so.id,
        so.outward_date::text AS tx_date,
        so.outward_no AS voucher_no,
        COALESCE(NULLIF(so.ref_no, ''), NULLIF(so.serial_no, ''), '-') AS ref_no,
        so.ledger_id,
        so.quantity AS qty,
        COALESCE(NULLIF(so.total_weight, 0), so.weight, 0) AS wt
      FROM {schema}.stock_outward so
      WHERE jsonb_array_length(COALESCE(so.items, '[]'::jsonb)) = 0 {where_out_and}
      UNION ALL
      SELECT 
        so.id,
        so.outward_date::text AS tx_date,
        so.outward_no AS voucher_no,
        COALESCE(NULLIF(so.ref_no, ''), NULLIF(so.serial_no, ''), '-') AS ref_no,
        so.ledger_id,
        COALESCE((item->>'quantity')::numeric, 0) AS qty,
        COALESCE((item->>'total_weight')::numeric, (item->>'weight')::numeric, 0) AS wt
      FROM {schema}.stock_outward so,
        jsonb_array_elements(COALESCE(so.items, '[]'::jsonb)) AS item
      WHERE jsonb_array_length(COALESCE(so.items, '[]'::jsonb)) > 0 {where_out_and}
    ),
    out_grouped AS (
      SELECT 
        id, tx_date, voucher_no, ref_no, ledger_id,
        0::numeric AS inward_qty,
        0::numeric AS inward_weight,
        SUM(qty) AS outward_qty,
        SUM(wt) AS outward_weight
      FROM out_unrolled
      GROUP BY id, tx_date, voucher_no, ref_no, ledger_id
    )
    SELECT 
      g.tx_date, g.voucher_no, g.ref_no,
      COALESCE(l.name, '-') AS particulars,
      g.inward_qty, g.inward_weight,
      g.outward_qty, g.outward_weight
    FROM (
      SELECT * FROM in_grouped
      UNION ALL
      SELECT * FROM out_grouped
    ) g
    LEFT JOIN master.ledgers l ON l.id = g.ledger_id
    ORDER BY g.tx_date ASC, g.voucher_no ASC
    """
    
    result = await db.execute(text(query), params)
    return [dict(r) for r in result.mappings().all()]

