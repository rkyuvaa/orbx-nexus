from fastapi import APIRouter, HTTPException, Query
from sqlalchemy import text
from pydantic import BaseModel
from typing import Optional

from app.api.deps import CurrentUser, DBSession

router = APIRouter()


import json

class StockInwardIn(BaseModel):
    inward_no: str
    inward_date: str
    product_id: int | None = None
    process_id: str | None = None
    ledger_id: int
    quantity: float = 0
    rate: float = 0
    amount: float = 0
    uom_id: int | None = None
    narration: str | None = None
    serial_no: str | None = None
    ref_no: str | None = None
    ref_date: str | None = None
    expected_duration_days: int | None = None
    weight: float = 0
    total_weight: float = 0
    items: list[dict] | None = None


class StockOutwardIn(BaseModel):
    outward_no: str
    outward_date: str
    inward_id: int | None = None
    inward_ids: list[int] | None = None
    product_id: int | None = None
    process_id: str | None = None
    ledger_id: int
    quantity: float = 0
    rate: float = 0
    amount: float = 0
    weight: float = 0
    total_weight: float = 0
    uom_id: int | None = None
    serial_no: str | None = None
    ref_no: str | None = None
    narration: str | None = None
    dispatch_through: str | None = None
    items: list[dict] | None = None



class StockTransferIn(BaseModel):
    transfer_no: str
    transfer_date: str
    from_stock_item_id: int
    to_stock_item_id: int
    quantity: float
    narration: str | None = None


class StockAdjustmentIn(BaseModel):
    adjustment_no: str
    adjustment_date: str
    product_id: int
    quantity: float
    reason: str | None = None


def _schema(fy: str) -> str:
    return f"fy_{fy}"


@router.get("/inward")
async def list_inward(
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
    from_date: Optional[str] = None,
    to_date: Optional[str] = None,
    product_id: Optional[int] = None,
):
    s = _schema(fy)
    conds = ["1=1"]
    params: dict = {}
    if from_date:
        conds.append("inward_date >= :fd")
        params["fd"] = from_date
    if to_date:
        conds.append("inward_date <= :td")
        params["td"] = to_date
    if product_id:
        conds.append("product_id = :pid")
        params["pid"] = product_id
    where = " AND ".join(conds)
    result = await db.execute(
        text(f"SELECT * FROM {s}.stock_inward WHERE {where} ORDER BY inward_date DESC"), params
    )
    return [dict(r) for r in result.mappings().all()]


@router.get("/inward/suggested-processes")
async def get_suggested_processes(
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
):
    s = _schema(fy)
    result = await db.execute(
        text(
            f"SELECT DISTINCT process_id FROM {s}.stock_inward "
            f"WHERE process_id IS NOT NULL AND process_id != '' "
            f"ORDER BY process_id"
        )
    )
    return [row[0] for row in result.fetchall() if row[0]]


@router.get("/inward/pending-outward")
async def get_pending_inward_for_outward(
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
    ledger_id: Optional[int] = Query(None),
):
    """Return inward vouchers with per-line-item balance quantities."""
    s = _schema(fy)
    params: dict = {}
    ledger_filter = ""
    if ledger_id:
        ledger_filter = "AND si.ledger_id = :lid"
        params["lid"] = ledger_id

    result = await db.execute(
        text(f"""
        WITH i_lines AS (
          SELECT si.id AS inward_id,
            si.product_id AS hdr_product_id, si.quantity AS hdr_qty,
            si.items AS hdr_items
          FROM {s}.stock_inward si WHERE 1=1 {ledger_filter}
        ),
        in_lines AS (
          SELECT inward_id, hdr_product_id AS product_id, hdr_qty AS line_qty,
            NULL::int AS process_id
          FROM i_lines
          WHERE jsonb_array_length(COALESCE(hdr_items, '[]'::jsonb)) = 0
            AND hdr_product_id IS NOT NULL
          UNION ALL
          SELECT inward_id, (item->>'product_id')::int AS product_id,
            (item->>'quantity')::numeric AS line_qty,
            (item->>'process_id')::int AS process_id
          FROM i_lines,
            jsonb_array_elements(COALESCE(hdr_items, '[]'::jsonb)) AS item
          WHERE jsonb_array_length(COALESCE(hdr_items, '[]'::jsonb)) > 0
        ),
        -- Outward items matched only by inward_id + product_id (ignoring process)
        out_dispatched AS (
          SELECT so.inward_id,
            COALESCE((o_item->>'product_id')::int, so.product_id) AS product_id,
            SUM(COALESCE((o_item->>'quantity')::numeric, so.quantity)) AS dispatched
          FROM {s}.stock_outward so
          LEFT JOIN LATERAL jsonb_array_elements(
            CASE WHEN jsonb_array_length(COALESCE(so.items, '[]'::jsonb)) > 0
              THEN so.items ELSE NULL END
          ) AS o_item ON TRUE
          WHERE so.inward_id IS NOT NULL
          GROUP BY so.inward_id,
            COALESCE((o_item->>'product_id')::int, so.product_id)
        ),
        inward_balances AS (
          SELECT il.inward_id,
            SUM(GREATEST(il.line_qty - COALESCE(od.dispatched, 0), 0)) AS total_balance
          FROM in_lines il
          LEFT JOIN out_dispatched od ON od.inward_id = il.inward_id AND od.product_id = il.product_id
          GROUP BY il.inward_id
        )
        SELECT si.*,
          COALESCE(ib.total_balance, 0) AS balance_qty,
          -- per-line-item balances as JSON array
          COALESCE((
            SELECT jsonb_agg(
              jsonb_build_object(
                'product_id', il.product_id,
                'process_id', il.process_id,
                'quantity', il.line_qty,
                'balance_qty', GREATEST(il.line_qty - COALESCE(od.dispatched, 0), 0)
              )
              ORDER BY il.product_id, il.process_id
            )
            FROM in_lines il
            LEFT JOIN out_dispatched od ON od.inward_id = il.inward_id
              AND od.product_id = il.product_id
            WHERE il.inward_id = si.id
              AND GREATEST(il.line_qty - COALESCE(od.dispatched, 0), 0) > 0
          ), '[]'::jsonb) AS line_items_balance
        FROM {s}.stock_inward si
        LEFT JOIN inward_balances ib ON ib.inward_id = si.id
        WHERE 1=1 {ledger_filter}
        ORDER BY si.inward_date DESC
        """),
        params,
    )
    return [dict(r) for r in result.mappings().all()]




@router.post("/inward", status_code=201)
async def create_inward(
    body: StockInwardIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    s = _schema(fy)
    from app.services.sequences import generate_and_increment_sequence
    inward_no = await generate_and_increment_sequence(db, "stock_inward")
    items_json = json.dumps(body.items) if body.items else "[]"
    result = await db.execute(
        text(
            f"INSERT INTO {s}.stock_inward (inward_no, inward_date, product_id, process_id, ledger_id, "
            f"quantity, rate, amount, uom_id, narration, serial_no, ref_no, ref_date, "
            f"expected_duration_days, weight, total_weight, items, created_by) "
            f"VALUES (:ino, :idate, :pid, :prid, :lid, :qty, :rate, :amt, :uom, :narr, "
            f":sno, :rno, :rdate, :edays, :wt, :twt, :items, :cby) RETURNING id"
        ),
        {
            "ino": inward_no, "idate": body.inward_date, "pid": body.product_id,
            "prid": body.process_id, "lid": body.ledger_id, "qty": body.quantity,
            "rate": body.rate, "amt": body.amount, "uom": body.uom_id,
            "narr": body.narration, "sno": body.serial_no, "rno": body.ref_no,
            "rdate": body.ref_date, "edays": body.expected_duration_days,
            "wt": body.weight, "twt": body.total_weight, "items": items_json,
            "cby": current_user.id
        },
    )
    return {"id": result.scalar_one(), "message": "Inward entry created"}


@router.put("/inward/{inward_id}")
async def update_inward(
    inward_id: int, body: StockInwardIn, current_user: CurrentUser,
    db: DBSession, fy: str = Query(default="2026_2027")
):
    s = _schema(fy)
    items_json = json.dumps(body.items) if body.items else "[]"
    await db.execute(
        text(
            f"UPDATE {s}.stock_inward SET inward_no=:ino, inward_date=:idate, product_id=:pid, "
            f"process_id=:prid, ledger_id=:lid, quantity=:qty, rate=:rate, amount=:amt, "
            f"uom_id=:uom, narration=:narr, serial_no=:sno, ref_no=:rno, ref_date=:rdate, "
            f"expected_duration_days=:edays, weight=:wt, total_weight=:twt, items=:items, "
            f"updated_at=NOW() WHERE id=:id"
        ),
        {
            "ino": body.inward_no, "idate": body.inward_date, "pid": body.product_id,
            "prid": body.process_id, "lid": body.ledger_id, "qty": body.quantity,
            "rate": body.rate, "amt": body.amount, "uom": body.uom_id,
            "narr": body.narration, "sno": body.serial_no, "rno": body.ref_no,
            "rdate": body.ref_date, "edays": body.expected_duration_days,
            "wt": body.weight, "twt": body.total_weight, "items": items_json,
            "id": inward_id
        },
    )
    return {"message": "Updated"}


@router.delete("/inward/delete-all", status_code=200)
async def delete_all_inward(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    s = _schema(fy)
    await db.execute(text(f"DELETE FROM {s}.stock_outward WHERE inward_id IS NOT NULL"))
    await db.execute(text(f"DELETE FROM {s}.stock_inward"))
    return {"message": "All inward vouchers deleted"}


@router.delete("/inward/{inward_id}", status_code=204)
async def delete_inward(
    inward_id: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = _schema(fy)
    # Check if any outward entries reference this inward
    dep = await db.execute(
        text(f"SELECT COUNT(*) AS cnt FROM {schema}.stock_outward WHERE inward_id = :id"),
        {"id": inward_id},
    )
    row = dep.mappings().one()
    if int(row["cnt"]) > 0:
        raise HTTPException(
            status_code=409,
            detail=f"Cannot delete: {row['cnt']} outward voucher(s) reference this inward entry. Remove or unlink them first.",
        )
    await db.execute(
        text(f"DELETE FROM {_schema(fy)}.stock_inward WHERE id = :id"), {"id": inward_id}
    )


@router.get("/outward")
async def list_outward(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    from_date: Optional[str] = None, to_date: Optional[str] = None,
    ledger_id: Optional[int] = None
):
    s = _schema(fy)
    conds = ["1=1"]
    params: dict = {}
    if from_date:
        conds.append("outward_date >= :fd")
        params["fd"] = from_date
    if to_date:
        conds.append("outward_date <= :td")
        params["td"] = to_date
    if ledger_id:
        conds.append("ledger_id = :lid")
        params["lid"] = ledger_id
    result = await db.execute(
        text(f"SELECT * FROM {s}.stock_outward WHERE {' AND '.join(conds)} ORDER BY outward_date DESC"),
        params
    )
    return [dict(r) for r in result.mappings().all()]


@router.post("/outward", status_code=201)
async def create_outward(
    body: StockOutwardIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    s = _schema(fy)
    from app.services.sequences import generate_and_increment_sequence
    outward_no = await generate_and_increment_sequence(db, "stock_outward")
    items_json = json.dumps(body.items) if body.items else "[]"
    iids_json = json.dumps(body.inward_ids) if body.inward_ids else "[]"
    result = await db.execute(
        text(
            f"INSERT INTO {s}.stock_outward (outward_no, outward_date, inward_id, product_id, process_id, "
            f"ledger_id, quantity, rate, amount, weight, total_weight, uom_id, serial_no, ref_no, narration, dispatch_through, items, inward_ids, created_by) "
            f"VALUES (:ono, :odate, :iid, :pid, :prid, :lid, :qty, :rate, :amt, :wt, :twt, :uom, :sno, :rno, :narr, :dt, :items, :iids, :cby) RETURNING id"
        ),
        {
            "ono": outward_no, "odate": body.outward_date, "iid": body.inward_id,
            "pid": body.product_id, "prid": body.process_id, "lid": body.ledger_id,
            "qty": body.quantity, "rate": body.rate, "amt": body.amount,
            "wt": body.weight, "twt": body.total_weight,
            "uom": body.uom_id, "sno": body.serial_no, "rno": body.ref_no,
            "narr": body.narration, "dt": body.dispatch_through, "items": items_json, "iids": iids_json, "cby": current_user.id
        },
    )
    return {"id": result.scalar_one(), "message": "Outward entry created"}


@router.put("/outward/{outward_id}")
async def update_outward(
    outward_id: int, body: StockOutwardIn, current_user: CurrentUser, db: DBSession,
    fy: str = Query(default="2026_2027")
):
    s = _schema(fy)
    items_json = json.dumps(body.items) if body.items else "[]"
    iids_json = json.dumps(body.inward_ids) if body.inward_ids else "[]"
    await db.execute(
        text(
            f"UPDATE {s}.stock_outward SET outward_no=:ono, outward_date=:odate, inward_id=:iid, "
            f"product_id=:pid, process_id=:prid, ledger_id=:lid, quantity=:qty, rate=:rate, "
            f"amount=:amt, weight=:wt, total_weight=:twt, uom_id=:uom, serial_no=:sno, "
            f"ref_no=:rno, narration=:narr, dispatch_through=:dt, items=:items, inward_ids=:iids "
            f"WHERE id=:id"
        ),
        {
            "id": outward_id,
            "ono": body.outward_no, "odate": body.outward_date, "iid": body.inward_id,
            "pid": body.product_id, "prid": body.process_id, "lid": body.ledger_id,
            "qty": body.quantity, "rate": body.rate, "amt": body.amount,
            "wt": body.weight, "twt": body.total_weight,
            "uom": body.uom_id, "sno": body.serial_no, "rno": body.ref_no,
            "narr": body.narration, "dt": body.dispatch_through, "items": items_json, "iids": iids_json,
        },
    )
    return {"message": "Updated"}


@router.delete("/outward/{outward_id}", status_code=204)
async def delete_outward(
    outward_id: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = _schema(fy)
    
    # Check if any job work entries reference this outward voucher
    jw_dep = await db.execute(
        text(
            f"SELECT COUNT(*) AS cnt FROM {schema}.job_work_entries "
            f"WHERE outward_id = :id OR (outward_ids IS NOT NULL AND outward_ids @> :id_json::jsonb)"
        ),
        {"id": outward_id, "id_json": json.dumps([outward_id])},
    )
    jw_row = jw_dep.mappings().one()
    if int(jw_row["cnt"]) > 0:
        raise HTTPException(
            status_code=409,
            detail=f"Cannot delete: {jw_row['cnt']} job work entry/entries reference this outward entry. Remove or unlink them first.",
        )

    # Check if any labour bills reference this outward voucher
    lb_dep = await db.execute(
        text(
            f"SELECT COUNT(*) AS cnt FROM {schema}.labour_bills "
            f"WHERE outward_ids IS NOT NULL AND outward_ids @> :id_json::jsonb"
        ),
        {"id_json": json.dumps([outward_id])},
    )
    lb_row = lb_dep.mappings().one()
    if int(lb_row["cnt"]) > 0:
        raise HTTPException(
            status_code=409,
            detail=f"Cannot delete: {lb_row['cnt']} labour bill(s) reference this outward entry. Remove or unlink them first.",
        )

    try:
        await db.execute(
            text(f"DELETE FROM {schema}.stock_outward WHERE id = :id"), {"id": outward_id}
        )
    except Exception:
        await db.rollback()
        raise HTTPException(
            status_code=409,
            detail="Cannot delete: database constraint error. The outward entry might be referenced by other records.",
        )


@router.get("/transfer")
async def list_transfers(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    s = _schema(fy)
    result = await db.execute(
        text(f"SELECT * FROM {s}.stock_transfer ORDER BY transfer_date DESC")
    )
    return [dict(r) for r in result.mappings().all()]


@router.post("/transfer", status_code=201)
async def create_transfer(
    body: StockTransferIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    s = _schema(fy)
    result = await db.execute(
        text(
            f"INSERT INTO {s}.stock_transfer (transfer_no, transfer_date, from_stock_item_id, "
            f"to_stock_item_id, quantity, narration, created_by) "
            f"VALUES (:tno, :tdate, :fid, :tid, :qty, :narr, :cby) RETURNING id"
        ),
        {
            "tno": body.transfer_no, "tdate": body.transfer_date,
            "fid": body.from_stock_item_id, "tid": body.to_stock_item_id,
            "qty": body.quantity, "narr": body.narration, "cby": current_user.id
        },
    )
    return {"id": result.scalar_one(), "message": "Transfer created"}


# ──── Stock Adjustments ────

@router.get("/adjustments")
async def list_adjustments(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    s = _schema(fy)
    result = await db.execute(
        text(f"SELECT sa.*, p.name AS product_name FROM {s}.stock_adjustments sa "
             f"LEFT JOIN master.products p ON p.id = sa.product_id "
             f"ORDER BY sa.adjustment_date DESC, sa.id DESC")
    )
    return [dict(r) for r in result.mappings().all()]


@router.post("/adjustments", status_code=201)
async def create_adjustment(
    body: StockAdjustmentIn, current_user: CurrentUser,
    db: DBSession, fy: str = Query(default="2026_2027")
):
    s = _schema(fy)
    from app.services.sequences import generate_and_increment_sequence
    adjustment_no = await generate_and_increment_sequence(db, "stock_adjustment")
    result = await db.execute(
        text(
            f"INSERT INTO {s}.stock_adjustments "
            f"(adjustment_no, adjustment_date, product_id, quantity, reason, created_by) "
            f"VALUES (:ano, :adate, :pid, :qty, :reason, :cby) RETURNING id"
        ),
        {
            "ano": adjustment_no, "adate": body.adjustment_date,
            "pid": body.product_id, "qty": body.quantity,
            "reason": body.reason, "cby": current_user.id
        },
    )
    return {"id": result.scalar_one(), "message": "Adjustment created"}


@router.put("/adjustments/{adjustment_id}")
async def update_adjustment(
    adjustment_id: int, body: StockAdjustmentIn, current_user: CurrentUser,
    db: DBSession, fy: str = Query(default="2026_2027")
):
    s = _schema(fy)
    await db.execute(
        text(
            f"UPDATE {s}.stock_adjustments SET adjustment_no=:ano, adjustment_date=:adate, "
            f"product_id=:pid, quantity=:qty, reason=:reason WHERE id=:id"
        ),
        {
            "ano": body.adjustment_no, "adate": body.adjustment_date,
            "pid": body.product_id, "qty": body.quantity,
            "reason": body.reason, "id": adjustment_id
        },
    )
    return {"message": "Updated"}


@router.delete("/adjustments/{adjustment_id}", status_code=204)
async def delete_adjustment(
    adjustment_id: int, current_user: CurrentUser,
    db: DBSession, fy: str = Query(default="2026_2027")
):
    s = _schema(fy)
    await db.execute(
        text(f"DELETE FROM {s}.stock_adjustments WHERE id = :id"), {"id": adjustment_id}
    )


# ──── Inventory Stock Item Movements ────

class StockItemMovementIn(BaseModel):
    movement_no: str
    movement_date: str
    movement_type: str  # 'Inward', 'Outward', 'Transfer', 'Consumption'
    stock_item_id: int
    ledger_id: int | None = None
    quantity: float = 0
    rate: float = 0
    amount: float = 0
    uom_id: int | None = None
    ref_no: str | None = None
    narration: str | None = None
    location_id: int | None = None
    to_location_id: int | None = None


@router.get("/inventory")
async def get_inventory_balance(
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
):
    """Return all stock items with their current balance (opening + inward - outward)."""
    s = _schema(fy)
    result = await db.execute(
        text(
            f"SELECT si.id, si.name, si.item_code, si.uom_id, si.opening_stock, si.reorder_level, "
            f"u.symbol AS uom_symbol, "
            f"COALESCE(SUM(CASE WHEN m.movement_type='Inward'  THEN m.quantity ELSE 0 END), 0) AS total_inward, "
            f"COALESCE(SUM(CASE WHEN m.movement_type='Outward' THEN m.quantity ELSE 0 END), 0) AS total_outward, "
            f"si.opening_stock "
            f"  + COALESCE(SUM(CASE WHEN m.movement_type='Inward'  THEN m.quantity ELSE 0 END), 0) "
            f"  - COALESCE(SUM(CASE WHEN m.movement_type='Outward' THEN m.quantity ELSE 0 END), 0) AS balance_qty, "
            f"COALESCE(SUM(CASE WHEN m.movement_type='Inward'  THEN m.amount ELSE 0 END), 0) AS total_inward_value, "
            f"COALESCE(SUM(CASE WHEN m.movement_type='Outward' THEN m.amount ELSE 0 END), 0) AS total_outward_value "
            f"FROM master.stock_items si "
            f"LEFT JOIN {s}.stock_item_movements m ON m.stock_item_id = si.id "
            f"LEFT JOIN master.units_of_measure u ON u.id = si.uom_id "
            f"WHERE si.is_active = TRUE "
            f"GROUP BY si.id, si.name, si.item_code, si.uom_id, si.opening_stock, si.reorder_level, u.symbol "
            f"ORDER BY si.name"
        )
    )
    return [dict(r) for r in result.mappings().all()]


@router.get("/inventory/movements")
async def list_inventory_movements(
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
    movement_type: Optional[str] = None,
    stock_item_id: Optional[int] = None,
    from_date: Optional[str] = None,
    to_date: Optional[str] = None,
):
    s = _schema(fy)
    conds = ["1=1"]
    params: dict = {}
    if movement_type:
        conds.append("m.movement_type = :mtype")
        params["mtype"] = movement_type
    if stock_item_id:
        conds.append("m.stock_item_id = :siid")
        params["siid"] = stock_item_id
    if from_date:
        conds.append("m.movement_date >= :fd")
        params["fd"] = from_date
    if to_date:
        conds.append("m.movement_date <= :td")
        params["td"] = to_date
    where = " AND ".join(conds)
    result = await db.execute(
        text(
            f"SELECT m.*, si.name AS stock_item_name, si.item_code, "
            f"u.symbol AS uom_symbol, l.name AS ledger_name, "
            f"loc.name AS location_name, to_loc.name AS to_location_name "
            f"FROM {s}.stock_item_movements m "
            f"LEFT JOIN master.stock_items si ON si.id = m.stock_item_id "
            f"LEFT JOIN master.units_of_measure u ON u.id = m.uom_id "
            f"LEFT JOIN master.ledgers l ON l.id = m.ledger_id "
            f"LEFT JOIN master.locations loc ON loc.id = m.location_id "
            f"LEFT JOIN master.locations to_loc ON to_loc.id = m.to_location_id "
            f"WHERE {where} ORDER BY m.movement_date DESC, m.id DESC"
        ),
        params
    )
    return [dict(r) for r in result.mappings().all()]


@router.post("/inventory/movements", status_code=201)
async def create_inventory_movement(
    body: StockItemMovementIn, current_user: CurrentUser,
    db: DBSession, fy: str = Query(default="2026_2027")
):
    s = _schema(fy)
    result = await db.execute(
        text(
            f"INSERT INTO {s}.stock_item_movements "
            f"(movement_no, movement_date, movement_type, stock_item_id, ledger_id, "
            f"quantity, rate, amount, uom_id, ref_no, narration, location_id, to_location_id, created_by) "
            f"VALUES (:mno, :mdate, :mtype, :siid, :lid, :qty, :rate, :amt, :uom, :rno, :narr, :loc, :toloc, :cby) "
            f"RETURNING id"
        ),
        {
            "mno": body.movement_no, "mdate": body.movement_date, "mtype": body.movement_type,
            "siid": body.stock_item_id, "lid": body.ledger_id,
            "qty": body.quantity, "rate": body.rate, "amt": body.amount,
            "uom": body.uom_id, "rno": body.ref_no, "narr": body.narration,
            "loc": body.location_id, "toloc": body.to_location_id,
            "cby": current_user.id
        },
    )
    return {"id": result.scalar_one(), "message": f"{body.movement_type} entry created"}


@router.put("/inventory/movements/{movement_id}")
async def update_inventory_movement(
    movement_id: int, body: StockItemMovementIn, current_user: CurrentUser,
    db: DBSession, fy: str = Query(default="2026_2027")
):
    s = _schema(fy)
    await db.execute(
        text(
            f"UPDATE {s}.stock_item_movements SET "
            f"movement_no=:mno, movement_date=:mdate, movement_type=:mtype, "
            f"stock_item_id=:siid, ledger_id=:lid, quantity=:qty, rate=:rate, amount=:amt, "
            f"uom_id=:uom, ref_no=:rno, narration=:narr, location_id=:loc, to_location_id=:toloc, updated_at=NOW() "
            f"WHERE id=:id"
        ),
        {
            "mno": body.movement_no, "mdate": body.movement_date, "mtype": body.movement_type,
            "siid": body.stock_item_id, "lid": body.ledger_id,
            "qty": body.quantity, "rate": body.rate, "amt": body.amount,
            "uom": body.uom_id, "rno": body.ref_no, "narr": body.narration,
            "loc": body.location_id, "toloc": body.to_location_id,
            "id": movement_id
        },
    )
    return {"message": "Updated"}


@router.delete("/inventory/movements/{movement_id}", status_code=204)
async def delete_inventory_movement(
    movement_id: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    await db.execute(
        text(f"DELETE FROM {_schema(fy)}.stock_item_movements WHERE id = :id"), {"id": movement_id}
    )


# ──── Locations CRUD & Tracking API ────

from app.models.master import Location
from sqlalchemy import select

class LocationIn(BaseModel):
    name: str
    code: str | None = None
    process_id: int | None = None
    p1_id: int | None = None
    p1_from: str | None = None
    p1_to: str | None = None
    p2_id: int | None = None
    p2_from: str | None = None
    p2_to: str | None = None

@router.get("/locations")
async def list_locations(current_user: CurrentUser, db: DBSession):
    result = await db.execute(
        text(
            "SELECT l.*, p.name AS process_name, "
            "  l1.name AS p1_name, l2.name AS p2_name "
            "FROM master.locations l "
            "LEFT JOIN master.processes p ON p.id = l.process_id "
            "LEFT JOIN master.ledgers l1 ON l1.id = l.p1_id "
            "LEFT JOIN master.ledgers l2 ON l2.id = l.p2_id "
            "ORDER BY l.name"
        )
    )
    return [dict(r) for r in result.mappings().all()]

@router.post("/locations", status_code=201)
async def create_location(body: LocationIn, current_user: CurrentUser, db: DBSession):
    loc = Location(
        name=body.name, code=body.code, process_id=body.process_id,
        p1_id=body.p1_id, p1_from=body.p1_from, p1_to=body.p1_to,
        p2_id=body.p2_id, p2_from=body.p2_from, p2_to=body.p2_to
    )
    db.add(loc)
    await db.flush()
    await db.refresh(loc)
    return loc

@router.put("/locations/{id}")
async def update_location(id: int, body: LocationIn, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Location).where(Location.id == id))
    loc = result.scalar_one_or_none()
    if not loc:
        raise HTTPException(status_code=404, detail="Location not found")
    loc.name = body.name
    loc.code = body.code
    loc.process_id = body.process_id
    loc.p1_id = body.p1_id
    loc.p1_from = body.p1_from
    loc.p1_to = body.p1_to
    loc.p2_id = body.p2_id
    loc.p2_from = body.p2_from
    loc.p2_to = body.p2_to
    await db.flush()
    await db.refresh(loc)
    return loc

@router.delete("/locations/{id}", status_code=204)
async def delete_location(id: int, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Location).where(Location.id == id))
    loc = result.scalar_one_or_none()
    if not loc:
        raise HTTPException(status_code=404, detail="Location not found")
    await db.delete(loc)
    await db.flush()


@router.get("/locations/balances")
async def get_location_balances(
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
):
    s = _schema(fy)
    query = f"""
    WITH incoming AS (
        SELECT 
            NULL::integer AS location_id,
            id AS stock_item_id,
            opening_stock AS qty
        FROM master.stock_items
        WHERE opening_stock > 0 AND is_active = TRUE
        
        UNION ALL
        
        SELECT 
            NULL::integer AS location_id,
            stock_item_id,
            SUM(quantity) AS qty
        FROM {s}.stock_item_movements
        WHERE to_location_id IS NULL AND movement_type IN ('Inward', 'Transfer')
        GROUP BY stock_item_id

        UNION ALL

        SELECT 
            to_location_id AS location_id,
            stock_item_id,
            SUM(quantity) AS qty
        FROM {s}.stock_item_movements
        WHERE to_location_id IS NOT NULL
        GROUP BY to_location_id, stock_item_id
    ),
    outgoing AS (
        SELECT 
            NULL::integer AS location_id,
            stock_item_id,
            SUM(quantity) AS qty
        FROM {s}.stock_item_movements
        WHERE location_id IS NULL AND movement_type IN ('Outward', 'Transfer', 'Consumption')
        GROUP BY stock_item_id

        UNION ALL

        SELECT 
            location_id,
            stock_item_id,
            SUM(quantity) AS qty
        FROM {s}.stock_item_movements
        WHERE location_id IS NOT NULL
        GROUP BY location_id, stock_item_id
    ),
    combined_moves AS (
        SELECT 
            location_id,
            stock_item_id,
            SUM(qty) AS in_qty,
            0::numeric AS out_qty
        FROM incoming
        GROUP BY location_id, stock_item_id
        
        UNION ALL
        
        SELECT 
            location_id,
            stock_item_id,
            0::numeric AS in_qty,
            SUM(qty) AS out_qty
        FROM outgoing
        GROUP BY location_id, stock_item_id
    ),
    balances AS (
        SELECT 
            location_id,
            stock_item_id,
            SUM(in_qty) - SUM(out_qty) AS balance_qty
        FROM combined_moves
        GROUP BY location_id, stock_item_id
    )
    SELECT 
        b.location_id,
        COALESCE(loc.name, 'Main Store') AS location_name,
        pr.name AS process_name,
        b.stock_item_id,
        si.name AS stock_item_name,
        si.item_code,
        u.symbol AS uom_symbol,
        b.balance_qty
    FROM balances b
    LEFT JOIN master.locations loc ON loc.id = b.location_id
    LEFT JOIN master.processes pr ON pr.id = loc.process_id
    LEFT JOIN master.stock_items si ON si.id = b.stock_item_id
    LEFT JOIN master.units_of_measure u ON u.id = si.uom_id
    WHERE b.balance_qty != 0 OR b.location_id IS NULL
    ORDER BY COALESCE(loc.name, 'Main Store'), si.name
    """
    result = await db.execute(text(query))
    return [dict(r) for r in result.mappings().all()]


@router.get("/locations/process-consumption")
async def get_process_consumption(
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
    from_date: Optional[str] = None,
    to_date: Optional[str] = None,
):
    s = _schema(fy)
    conds = ["m.movement_type = 'Consumption'"]
    params = {}
    if from_date:
        conds.append("m.movement_date >= :fd")
        params["fd"] = from_date
    if to_date:
        conds.append("m.movement_date <= :td")
        params["td"] = to_date
        
    where = " AND ".join(conds)
    query = f"""
    SELECT 
        pr.id AS process_id,
        pr.name AS process_name,
        si.id AS stock_item_id,
        si.name AS stock_item_name,
        si.item_code,
        u.symbol AS uom_symbol,
        SUM(m.quantity) AS total_consumed,
        SUM(m.amount) AS total_value
    FROM {s}.stock_item_movements m
    JOIN master.locations loc ON loc.id = m.location_id
    JOIN master.processes pr ON pr.id = loc.process_id
    JOIN master.stock_items si ON si.id = m.stock_item_id
    LEFT JOIN master.units_of_measure u ON u.id = si.uom_id
    WHERE {where}
    GROUP BY pr.id, pr.name, si.id, si.name, si.item_code, u.symbol
    ORDER BY pr.name, si.name
    """
    result = await db.execute(text(query), params)
    return [dict(r) for r in result.mappings().all()]


@router.get("/locations/consumption-report")
async def get_locations_consumption_report(
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
    p1_id: Optional[int] = None,
    p1_from: Optional[str] = None,
    p1_to: Optional[str] = None,
    p2_id: Optional[int] = None,
    p2_from: Optional[str] = None,
    p2_to: Optional[str] = None,
):
    schema = _schema(fy)
    queries = []
    params = {}

    if p1_id and p1_from and p1_to:
        queries.append(f"""
        SELECT 
            l.name AS contractor_name,
            COALESCE(loc.name, 'Main Store') AS location_name,
            lb.bill_date::text AS date,
            si.inward_no,
            si.ref_no AS inward_ref,
            lb.quantity AS qty,
            (lb.quantity * COALESCE(si.weight, 0)) AS weight,
            '1st Shift' AS shift_label
        FROM {schema}.labour_bills lb
        LEFT JOIN master.ledgers l ON l.id = lb.ledger_id
        LEFT JOIN {schema}.stock_inward si ON si.id = lb.inward_id
        LEFT JOIN master.locations loc ON loc.process_id = lb.process_id
        WHERE lb.ledger_id = :p1_id AND lb.bill_date BETWEEN :p1_from AND :p1_to
        """)
        params.update({"p1_id": p1_id, "p1_from": p1_from, "p1_to": p1_to})

    if p2_id and p2_from and p2_to:
        queries.append(f"""
        SELECT 
            l.name AS contractor_name,
            COALESCE(loc.name, 'Main Store') AS location_name,
            lb.bill_date::text AS date,
            si.inward_no,
            si.ref_no AS inward_ref,
            lb.quantity AS qty,
            (lb.quantity * COALESCE(si.weight, 0)) AS weight,
            '2nd Shift' AS shift_label
        FROM {schema}.labour_bills lb
        LEFT JOIN master.ledgers l ON l.id = lb.ledger_id
        LEFT JOIN {schema}.stock_inward si ON si.id = lb.inward_id
        LEFT JOIN master.locations loc ON loc.process_id = lb.process_id
        WHERE lb.ledger_id = :p2_id AND lb.bill_date BETWEEN :p2_from AND :p2_to
        """)
        params.update({"p2_id": p2_id, "p2_from": p2_from, "p2_to": p2_to})

    if not queries:
        return []

    union_query = " UNION ALL ".join(queries) + " ORDER BY date DESC, shift_label"
    result = await db.execute(text(union_query), params)
    return [dict(r) for r in result.mappings().all()]


@router.get("/locations/{id}/consumption")
async def get_single_location_consumption(
    id: int,
    current_user: CurrentUser,
    db: DBSession,
    fy: str = Query(default="2026_2027"),
):
    def to_date_obj(date_str):
        if not date_str:
            return None
        date_str = str(date_str).strip()
        if not date_str or date_str in ("None", "null"):
            return None
        for fmt in ("%Y-%m-%d", "%d-%m-%Y", "%Y/%m/%d", "%d/%m/%Y"):
            try:
                from datetime import datetime
                return datetime.strptime(date_str, fmt).date()
            except ValueError:
                pass
        return None

    loc_res = await db.execute(
        text(
            "SELECT l.*, "
            "  l1.name AS p1_name, l2.name AS p2_name "
            "FROM master.locations l "
            "LEFT JOIN master.ledgers l1 ON l1.id = l.p1_id "
            "LEFT JOIN master.ledgers l2 ON l2.id = l.p2_id "
            "WHERE l.id = :id"
        ),
        {"id": id}
    )
    loc = loc_res.mappings().one_or_none()
    if not loc:
        raise HTTPException(status_code=404, detail="Location not found")

    loc_dict = dict(loc)
    schema = _schema(fy)
    
    p1_from_dt = to_date_obj(loc_dict.get("p1_from"))
    p1_to_dt = to_date_obj(loc_dict.get("p1_to"))
    p2_from_dt = to_date_obj(loc_dict.get("p2_from"))
    p2_to_dt = to_date_obj(loc_dict.get("p2_to"))
    p1_name = loc_dict.get("p1_name") or "Unassigned"
    p2_name = loc_dict.get("p2_name") or "Unassigned"

    query = f"""
    SELECT 
        m.id,
        m.movement_date::text AS date,
        si.name AS tool_name,
        si.item_code AS tool_code,
        m.quantity AS qty,
        u.symbol AS uom_symbol,
        m.narration
    FROM {schema}.stock_item_movements m
    JOIN master.stock_items si ON si.id = m.stock_item_id
    LEFT JOIN master.units_of_measure u ON u.id = si.uom_id
    WHERE m.location_id = :location_id AND m.movement_type = 'Consumption'
    ORDER BY m.movement_date DESC
    """
    
    result = await db.execute(
        text(query),
        {"location_id": id}
    )
    
    records = []
    for r in result.mappings().all():
        r_dict = dict(r)
        m_date = to_date_obj(r_dict.get("date"))
        
        shift = "Unassigned"
        contractor = "Unassigned"
        
        if m_date:
            if p1_from_dt and p1_to_dt and p1_from_dt <= m_date <= p1_to_dt:
                shift = "1st Shift"
                contractor = p1_name
            elif p2_from_dt and p2_to_dt and p2_from_dt <= m_date <= p2_to_dt:
                shift = "2nd Shift"
                contractor = p2_name
                
        r_dict["shift_label"] = shift
        r_dict["contractor_name"] = contractor
        records.append(r_dict)
        
    return records


