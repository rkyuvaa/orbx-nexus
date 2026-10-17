"""
Inventory Stock Service — Centralized stock calculation & supplier attribution logic.
Single source of truth for stock calculations across OrbX Nexus ERP.

Rule:
Stock in Hand = Total Valid Inward Quantity − Total Valid Outward Quantity
- Inward: Confirmed and completed inward transactions increasing stock.
- Outward: Confirmed and completed outward transactions decreasing stock.
- Exclude draft, cancelled, rejected, and void transactions.
- Strict Supplier Isolation: Outward transactions attributable to Supplier A
  must NEVER deduct from Inwards of Supplier B.
"""
import json
from typing import Optional
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession


def compute_stock_in_hand_balances(
    inward_rows: list[dict],
    outward_rows: list[dict],
    ledger_map: dict[int, str],
    product_map: dict[int, str],
    inward_to_supplier: Optional[dict[int, int]] = None,
    filter_ledger_id: Optional[int] = None,
) -> list[dict]:
    """
    Computes stock in hand balances per inward line item with strict supplier attribution.
    Can be run synchronously in memory or as part of database queries.
    """
    if inward_to_supplier is None:
        inward_to_supplier = {}
    
    # Populate / supplement inward_to_supplier from inward_rows
    for r in inward_rows:
        iid = r.get("id")
        lid = r.get("ledger_id")
        if iid is not None and lid is not None:
            inward_to_supplier[int(iid)] = int(lid)

    inward_quantities: dict[tuple[int, int], float] = {}
    inward_item_list: list[dict] = []

    # 1. Unroll Inward line items
    for si_dict in inward_rows:
        # Exclude cancelled / draft transactions
        status = str(si_dict.get("status") or "").strip().lower()
        if status in ("draft", "cancelled", "canceled", "rejected", "void"):
            continue
        if si_dict.get("is_cancelled") is True:
            continue

        inward_id = int(si_dict["id"])
        lid = si_dict.get("ledger_id")
        if lid is not None:
            lid = int(lid)

        # If a supplier filter is active, skip inwards belonging to other suppliers
        if filter_ledger_id and lid != filter_ledger_id:
            continue

        raw_items = si_dict.get("items")
        if isinstance(raw_items, str):
            try:
                raw_items = json.loads(raw_items)
            except Exception:
                raw_items = []

        unrolled_items = []
        if raw_items and isinstance(raw_items, list) and len(raw_items) > 0:
            for item in raw_items:
                it_status = str(item.get("status") or "").strip().lower()
                if it_status in ("draft", "cancelled", "canceled", "rejected", "void"):
                    continue
                p_id = item.get("product_id")
                if p_id:
                    unrolled_items.append({
                        "product_id": int(p_id),
                        "quantity": float(item.get("quantity") or 0),
                        "weight": float(item.get("weight") or 0),
                    })
        else:
            if si_dict.get("product_id") or float(si_dict.get("quantity") or 0) > 0:
                p_id = si_dict.get("product_id")
                if p_id:
                    unrolled_items.append({
                        "product_id": int(p_id),
                        "quantity": float(si_dict.get("quantity") or 0),
                        "weight": float(si_dict.get("weight") or 0),
                    })

        for item in unrolled_items:
            p_id = item["product_id"]
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

    # Map: (inward_id, product_id) -> total dispatched quantity deducted
    dispatched_pool: dict[tuple[int, int], float] = {}

    # 2. Process Outward records
    for so_dict in outward_rows:
        # Exclude cancelled / draft transactions
        status = str(so_dict.get("status") or "").strip().lower()
        if status in ("draft", "cancelled", "canceled", "rejected", "void"):
            continue
        if so_dict.get("is_cancelled") is True:
            continue

        so_ledger_id = so_dict.get("ledger_id")
        if so_ledger_id is not None:
            so_ledger_id = int(so_ledger_id)

        inw_ids: list[int] = []
        if so_dict.get("inward_id"):
            inw_ids.append(int(so_dict["inward_id"]))
        if so_dict.get("inward_ids"):
            raw_ids = so_dict["inward_ids"]
            if isinstance(raw_ids, str):
                try:
                    raw_ids = json.loads(raw_ids)
                except Exception:
                    raw_ids = []
            if isinstance(raw_ids, list):
                for x in raw_ids:
                    if x is not None and str(x).isdigit():
                        xi = int(x)
                        if xi not in inw_ids:
                            inw_ids.append(xi)

        raw_items = so_dict.get("items")
        if isinstance(raw_items, str):
            try:
                raw_items = json.loads(raw_items)
            except Exception:
                raw_items = []

        outward_items = []
        if raw_items and isinstance(raw_items, list) and len(raw_items) > 0:
            for item in raw_items:
                it_status = str(item.get("status") or "").strip().lower()
                if it_status in ("draft", "cancelled", "canceled", "rejected", "void"):
                    continue
                p_id = item.get("product_id") or so_dict.get("product_id")
                if not p_id:
                    continue
                item_inw_id = item.get("inward_id") or so_dict.get("inward_id")
                outward_items.append({
                    "product_id": int(p_id),
                    "quantity": float(item.get("quantity") or 0),
                    "inward_id": int(item_inw_id) if item_inw_id else None,
                })
        else:
            if so_dict.get("product_id") or float(so_dict.get("quantity") or 0) > 0:
                p_id = so_dict.get("product_id")
                if p_id:
                    outward_items.append({
                        "product_id": int(p_id),
                        "quantity": float(so_dict.get("quantity") or 0),
                        "inward_id": int(so_dict["inward_id"]) if so_dict.get("inward_id") else None,
                    })

        for item in outward_items:
            p_id = item["product_id"]
            rem_qty = item["quantity"]
            if rem_qty <= 0:
                continue
            item_inw = item.get("inward_id")

            # Determine the owning supplier for this outward line item:
            # 1. Prefer specific inward's ledger_id if referenced
            # 2. Or header-level inward_ids' ledger_id
            # 3. Fallback to outward header ledger_id
            item_supplier = None
            if item_inw and item_inw in inward_to_supplier:
                item_supplier = inward_to_supplier[item_inw]
            elif inw_ids:
                for iid in inw_ids:
                    if iid in inward_to_supplier:
                        item_supplier = inward_to_supplier[iid]
                        break
            if item_supplier is None:
                item_supplier = so_ledger_id

            # If user filtered by a specific supplier, skip dispatches belonging to other suppliers
            if filter_ledger_id and item_supplier != filter_ledger_id:
                continue

            # Candidate inwards MUST belong to the SAME supplier!
            candidate_inwards: list[int] = []

            # Priority 1: Exact line-level inward_id
            if (
                item_inw
                and (item_inw, p_id) in inward_quantities
                and inward_to_supplier.get(item_inw) == item_supplier
            ):
                candidate_inwards.append(item_inw)

            # Priority 2: Header-level inward_ids
            for iid in inw_ids:
                if (
                    iid not in candidate_inwards
                    and (iid, p_id) in inward_quantities
                    and inward_to_supplier.get(iid) == item_supplier
                ):
                    candidate_inwards.append(iid)

            # Priority 3: Other inwards of the SAME supplier and product (FIFO chronological)
            for (iid, pid) in inward_quantities.keys():
                if (
                    pid == p_id
                    and iid not in candidate_inwards
                    and inward_to_supplier.get(iid) == item_supplier
                ):
                    candidate_inwards.append(iid)

            # Allocate remaining quantity across valid candidate inwards of this supplier
            for iid in candidate_inwards:
                if rem_qty <= 0:
                    break
                inw_key = (iid, p_id)
                init_qty = inward_quantities.get(inw_key, 0.0)
                already_disp = dispatched_pool.get(inw_key, 0.0)
                avail_qty = max(0.0, init_qty - already_disp)
                if avail_qty > 0:
                    alloc = min(avail_qty, rem_qty)
                    dispatched_pool[inw_key] = already_disp + alloc
                    rem_qty -= alloc

    # 3. Unroll and compute remaining balance for each inward line
    result_list = []
    remaining_dispatched = {k: v for k, v in dispatched_pool.items()}

    for item in inward_item_list:
        inward_id = item["inward_id"]
        p_id = item["product_id"]
        line_qty = item["quantity"]
        unit_weight = item["weight"]
        lid = item["ledger_id"]

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
            supplier_name = ledger_map.get(lid, "Unknown Supplier")
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


async def get_stock_in_hand_report(
    db: AsyncSession,
    schema: str,
    as_of_date: str,
    ledger_id: Optional[int] = None,
) -> list[dict]:
    """
    Asynchronous handler to fetch database rows and compute stock in hand
    with strict supplier attribution and filtering.
    """
    # 1. Fetch ledgers map and products map
    ledgers_res = await db.execute(text("SELECT id, name FROM master.ledgers"))
    ledger_map = {r["id"]: r["name"] for r in ledgers_res.mappings().all()}

    products_res = await db.execute(text("SELECT id, name FROM master.products"))
    product_map = {r["id"]: r["name"] for r in products_res.mappings().all()}

    # 2. Build full map of inward_id -> ledger_id for supplier attribution
    all_inw_res = await db.execute(text(f"SELECT id, ledger_id FROM {schema}.stock_inward"))
    inward_to_supplier = {int(r["id"]): int(r["ledger_id"]) for r in all_inw_res.mappings().all() if r["ledger_id"]}

    # 3. Fetch stock inward records up to as_of_date
    inw_conds = ["si.inward_date <= :aod"]
    inw_params: dict = {"aod": as_of_date}
    if ledger_id and ledger_id > 0:
        inw_conds.append("si.ledger_id = :lid")
        inw_params["lid"] = ledger_id

    inward_res = await db.execute(
        text(f"SELECT * FROM {schema}.stock_inward si WHERE {' AND '.join(inw_conds)} ORDER BY si.inward_date ASC, si.id ASC"),
        inw_params,
    )
    inward_rows = [dict(r) for r in inward_res.mappings().all()]

    # 4. Fetch stock outward records up to as_of_date (filtered by supplier if ledger_id given)
    out_conds = ["so.outward_date <= :aod"]
    out_params: dict = {"aod": as_of_date}
    if ledger_id and ledger_id > 0:
        out_conds.append(
            "(so.ledger_id = :lid "
            f"OR so.inward_id IN (SELECT id FROM {schema}.stock_inward WHERE ledger_id = :lid) "
            "OR EXISTS ("
            "  SELECT 1 FROM jsonb_array_elements_text(COALESCE(so.inward_ids, '[]'::jsonb)) x "
            f"  WHERE x ~ '^[0-9]+$' AND x::int IN (SELECT id FROM {schema}.stock_inward WHERE ledger_id = :lid)"
            ") "
            "OR EXISTS ("
            "  SELECT 1 FROM jsonb_array_elements(COALESCE(so.items, '[]'::jsonb)) it "
            f"  WHERE (it->>'inward_id') ~ '^[0-9]+$' AND (it->>'inward_id')::int IN (SELECT id FROM {schema}.stock_inward WHERE ledger_id = :lid)"
            "))"
        )
        out_params["lid"] = ledger_id

    outward_res = await db.execute(
        text(f"SELECT * FROM {schema}.stock_outward so WHERE {' AND '.join(out_conds)} ORDER BY so.outward_date ASC, so.id ASC"),
        out_params,
    )
    outward_rows = [dict(r) for r in outward_res.mappings().all()]

    return compute_stock_in_hand_balances(
        inward_rows=inward_rows,
        outward_rows=outward_rows,
        ledger_map=ledger_map,
        product_map=product_map,
        inward_to_supplier=inward_to_supplier,
        filter_ledger_id=ledger_id if ledger_id and ledger_id > 0 else None,
    )
