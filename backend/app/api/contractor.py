from fastapi import APIRouter, Query
from sqlalchemy import text
from pydantic import BaseModel
from typing import Optional

from app.api.deps import CurrentUser, DBSession

router = APIRouter()


def s(fy: str) -> str:
    return f"fy_{fy}"


class JobWorkIn(BaseModel):
    entry_no: str
    entry_date: str
    ledger_id: int
    outward_id: int | None = None
    outward_ids: list[int] | None = None
    product_id: int | None = None
    process_id: int | None = None
    rate_id: int | None = None
    quantity: float = 0
    rate: float = 0
    amount: float = 0
    entry_type: str = "Register"  # Register, Payment, Advance Payment, Advance Receipt
    narration: str | None = None
    items: list | None = None
    register_ids: list[int] | None = None


@router.get("/")
async def list_job_work(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    entry_type: Optional[str] = None, ledger_id: Optional[int] = None,
    from_date: Optional[str] = None, to_date: Optional[str] = None
):
    schema = s(fy)
    conds = ["1=1"]
    params: dict = {}
    if entry_type:
        conds.append("j.entry_type = :et")
        params["et"] = entry_type
    if ledger_id:
        conds.append("j.ledger_id = :lid")
        params["lid"] = ledger_id
    if from_date:
        conds.append("j.entry_date >= :fd")
        params["fd"] = from_date
    if to_date:
        conds.append("j.entry_date <= :td")
        params["td"] = to_date

    query = f"""
    SELECT 
        j.*,
        so.outward_no,
        p.name AS product_name,
        pr.name AS process_name,
        l.name AS contractor_name
    FROM {schema}.job_work_entries j
    LEFT JOIN {schema}.stock_outward so ON so.id = j.outward_id
    LEFT JOIN master.products p ON p.id = j.product_id
    LEFT JOIN master.processes pr ON pr.id = j.process_id
    LEFT JOIN master.ledgers l ON l.id = j.ledger_id
    WHERE {' AND '.join(conds)}
    ORDER BY j.entry_date DESC, j.id DESC
    """
    result = await db.execute(text(query), params)
    return [dict(r) for r in result.mappings().all()]


@router.get("/pending-registers")
async def list_pending_registers(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    ledger_id: Optional[int] = None, include_ids: Optional[str] = None
):
    schema = s(fy)
    conds = ["j.entry_type = 'Register'", "COALESCE(j.is_paid, FALSE) = FALSE"]
    params: dict = {}
    if ledger_id:
        conds.append("j.ledger_id = :lid")
        params["lid"] = ledger_id
    if include_ids:
        ids = [int(x) for x in include_ids.split(",") if x.strip().isdigit()]
        if ids:
            conds.append("(COALESCE(j.is_paid, FALSE) = FALSE OR j.id = ANY(:iids::int[]))")
            params["iids"] = ids

    query = f"""
    SELECT 
        j.id,
        j.entry_no,
        j.entry_date::text,
        j.ledger_id,
        l.name AS contractor_name,
        j.product_id,
        p.name AS product_name,
        j.process_id,
        pr.name AS process_name,
        j.quantity,
        j.rate,
        j.amount,
        COALESCE(j.outward_ids, '[]'::jsonb) AS outward_ids,
        COALESCE((
            SELECT string_agg(DISTINCT so.outward_no, ', ' ORDER BY so.outward_no)
            FROM jsonb_array_elements_text(COALESCE(j.outward_ids, '[]'::jsonb)) AS eid
            JOIN {schema}.stock_outward so ON so.id = eid::bigint
        ), '') AS outward_nos,
        COALESCE((
            SELECT string_agg(DISTINCT si.inward_no, ', ' ORDER BY si.inward_no)
            FROM jsonb_array_elements_text(COALESCE(j.outward_ids, '[]'::jsonb)) AS eid
            JOIN {schema}.stock_outward so ON so.id = eid::bigint
            LEFT JOIN {schema}.stock_inward si ON si.id = so.inward_id
        ), '') AS inward_nos,
        COALESCE((
            SELECT SUM(COALESCE(so.total_weight, 0))
            FROM jsonb_array_elements_text(COALESCE(j.outward_ids, '[]'::jsonb)) AS eid
            JOIN {schema}.stock_outward so ON so.id = eid::bigint
        ), 0) AS total_weight
    FROM {schema}.job_work_entries j
    LEFT JOIN master.ledgers l ON l.id = j.ledger_id
    LEFT JOIN master.products p ON p.id = j.product_id
    LEFT JOIN master.processes pr ON pr.id = j.process_id
    WHERE {' AND '.join(conds)}
    ORDER BY j.entry_date DESC, j.id DESC
    """
    result = await db.execute(text(query), params)
    return [dict(r) for r in result.mappings().all()]


def parse_date_iso(date_str: str | None) -> str:
    if not date_str:
        return str(date.today())
    date_str = date_str.strip()
    if len(date_str) == 10 and date_str[2] == "-" and date_str[5] == "-":
        parts = date_str.split("-")
        return f"{parts[2]}-{parts[1]}-{parts[0]}"
    if len(date_str) == 10 and date_str[2] == "/" and date_str[5] == "/":
        parts = date_str.split("/")
        return f"{parts[2]}-{parts[1]}-{parts[0]}"
    return date_str


@router.post("/", status_code=201)
async def create_job_work(
    body: JobWorkIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    
    seq_type = "job_work_register"
    if body.entry_type == "Payment":
        seq_type = "job_work_payment"
    elif body.entry_type == "Advance Payment":
        seq_type = "job_work_advance_payment"
    elif body.entry_type == "Advance Receipt":
        seq_type = "job_work_advance_receipt"
        
    from app.services.sequences import generate_and_increment_sequence
    entry_no = await generate_and_increment_sequence(db, seq_type)
    
    import json
    oids_json = json.dumps(body.outward_ids) if body.outward_ids else "[]"
    first_oid = body.outward_ids[0] if body.outward_ids else body.outward_id
    items_json = json.dumps(body.items) if body.items else "[]"
    rids_json = json.dumps(body.register_ids) if body.register_ids else "[]"
    edate = parse_date_iso(body.entry_date)

    result = await db.execute(
        text(
            f"INSERT INTO {schema}.job_work_entries "
            f"(entry_no, entry_date, ledger_id, outward_id, outward_ids, product_id, process_id, rate_id, quantity, rate, amount, entry_type, narration, items, register_ids, created_by) "
            f"VALUES (:eno, :edate, :lid, :oid, :oids::jsonb, :pid, :prid, :rid, :qty, :rate, :amt, :et, :narr, :items::jsonb, :rids::jsonb, :cby) RETURNING id"
        ),
        {
            "eno": entry_no, "edate": edate, "lid": body.ledger_id,
            "oid": first_oid, "oids": oids_json, "pid": body.product_id, "prid": body.process_id, "rid": body.rate_id,
            "qty": body.quantity, "rate": body.rate, "amt": body.amount,
            "et": body.entry_type, "narr": body.narration, "items": items_json, "rids": rids_json, "cby": current_user.id
        }
    )

    if body.entry_type == "Payment" and body.register_ids:
        await db.execute(
            text(
                f"UPDATE {schema}.job_work_entries SET is_paid = TRUE "
                f"WHERE id = ANY(:rids::int[]) AND entry_type = 'Register'"
            ),
            {"rids": body.register_ids}
        )

    return {"id": result.scalar_one(), "message": "Job work entry created"}


@router.put("/{entry_id}")
async def update_job_work(
    entry_id: int, body: JobWorkIn, current_user: CurrentUser,
    db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    import json
    oids_json = json.dumps(body.outward_ids) if body.outward_ids else "[]"
    first_oid = body.outward_ids[0] if body.outward_ids else body.outward_id
    items_json = json.dumps(body.items) if body.items else "[]"
    rids_json = json.dumps(body.register_ids) if body.register_ids else "[]"

    if body.entry_type == "Payment":
        prev = await db.execute(
            text(f"SELECT register_ids FROM {schema}.job_work_entries WHERE id = :id"),
            {"id": entry_id}
        )
        prev_row = prev.first()
        prev_rids = (prev_row.register_ids if prev_row and prev_row.register_ids else []) or []
        if prev_rids:
            await db.execute(
                text(
                    f"UPDATE {schema}.job_work_entries SET is_paid = FALSE "
                    f"WHERE id = ANY(:rids::int[]) AND entry_type = 'Register'"
                ),
                {"rids": prev_rids}
            )

    edate = parse_date_iso(body.entry_date)
    await db.execute(
        text(
            f"UPDATE {schema}.job_work_entries SET entry_no=:eno, entry_date=:edate, ledger_id=:lid, "
            f"outward_id=:oid, outward_ids=:oids::jsonb, product_id=:pid, process_id=:prid, rate_id=:rid, quantity=:qty, rate=:rate, amount=:amt, "
            f"entry_type=:et, narration=:narr, items=:items::jsonb, register_ids=:rids::jsonb, updated_at=NOW() WHERE id=:id"
        ),
        {
            "eno": body.entry_no, "edate": edate, "lid": body.ledger_id,
            "oid": first_oid, "oids": oids_json, "pid": body.product_id, "prid": body.process_id, "rid": body.rate_id,
            "qty": body.quantity, "rate": body.rate, "amt": body.amount,
            "et": body.entry_type, "narr": body.narration, "items": items_json, "rids": rids_json, "id": entry_id
        }
    )

    if body.entry_type == "Payment" and body.register_ids:
        await db.execute(
            text(
                f"UPDATE {schema}.job_work_entries SET is_paid = TRUE "
                f"WHERE id = ANY(:rids::int[]) AND entry_type = 'Register'"
            ),
            {"rids": body.register_ids}
        )

    return {"message": "Updated"}


@router.delete("/{entry_id}", status_code=204)
async def delete_job_work(
    entry_id: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    row = (await db.execute(
        text(f"SELECT entry_type, register_ids FROM {schema}.job_work_entries WHERE id = :id"),
        {"id": entry_id}
    )).first()
    if row and row.entry_type == "Payment" and row.register_ids:
        await db.execute(
            text(
                f"UPDATE {schema}.job_work_entries SET is_paid = FALSE "
                f"WHERE id = ANY(:rids::int[]) AND entry_type = 'Register'"
            ),
            {"rids": list(row.register_ids)}
        )
    await db.execute(
        text(f"DELETE FROM {schema}.job_work_entries WHERE id = :id"), {"id": entry_id}
    )
