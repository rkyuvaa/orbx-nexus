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

    result = await db.execute(
        text(
            f"INSERT INTO {schema}.job_work_entries "
            f"(entry_no, entry_date, ledger_id, outward_id, outward_ids, product_id, process_id, rate_id, quantity, rate, amount, entry_type, narration, created_by) "
            f"VALUES (:eno, :edate, :lid, :oid, :oids, :pid, :prid, :rid, :qty, :rate, :amt, :et, :narr, :cby) RETURNING id"
        ),
        {
            "eno": entry_no, "edate": body.entry_date, "lid": body.ledger_id,
            "oid": first_oid, "oids": oids_json, "pid": body.product_id, "prid": body.process_id, "rid": body.rate_id,
            "qty": body.quantity, "rate": body.rate, "amt": body.amount,
            "et": body.entry_type, "narr": body.narration, "cby": current_user.id
        }
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

    await db.execute(
        text(
            f"UPDATE {schema}.job_work_entries SET entry_no=:eno, entry_date=:edate, ledger_id=:lid, "
            f"outward_id=:oid, outward_ids=:oids, product_id=:pid, process_id=:prid, rate_id=:rid, quantity=:qty, rate=:rate, amount=:amt, "
            f"entry_type=:et, narration=:narr, updated_at=NOW() WHERE id=:id"
        ),
        {
            "eno": body.entry_no, "edate": body.entry_date, "lid": body.ledger_id,
            "oid": first_oid, "oids": oids_json, "pid": body.product_id, "prid": body.process_id, "rid": body.rate_id,
            "qty": body.quantity, "rate": body.rate, "amt": body.amount,
            "et": body.entry_type, "narr": body.narration, "id": entry_id
        }
    )
    return {"message": "Updated"}


@router.delete("/{entry_id}", status_code=204)
async def delete_job_work(
    entry_id: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    await db.execute(
        text(f"DELETE FROM {s(fy)}.job_work_entries WHERE id = :id"), {"id": entry_id}
    )
