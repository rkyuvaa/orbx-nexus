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
    product_id: int | None = None
    process_id: int | None = None
    rate_id: int | None = None
    quantity: float = 0
    rate: float = 0
    amount: float = 0
    entry_type: str = "Register"  # Register, Payment
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
        conds.append("entry_type = :et")
        params["et"] = entry_type
    if ledger_id:
        conds.append("ledger_id = :lid")
        params["lid"] = ledger_id
    if from_date:
        conds.append("entry_date >= :fd")
        params["fd"] = from_date
    if to_date:
        conds.append("entry_date <= :td")
        params["td"] = to_date
    result = await db.execute(
        text(f"SELECT * FROM {schema}.job_work_entries WHERE {' AND '.join(conds)} ORDER BY entry_date DESC"),
        params
    )
    return [dict(r) for r in result.mappings().all()]


@router.post("/", status_code=201)
async def create_job_work(
    body: JobWorkIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"INSERT INTO {schema}.job_work_entries "
            f"(entry_no, entry_date, ledger_id, product_id, process_id, rate_id, quantity, rate, amount, entry_type, narration, created_by) "
            f"VALUES (:eno, :edate, :lid, :pid, :prid, :rid, :qty, :rate, :amt, :et, :narr, :cby) RETURNING id"
        ),
        {
            "eno": body.entry_no, "edate": body.entry_date, "lid": body.ledger_id,
            "pid": body.product_id, "prid": body.process_id, "rid": body.rate_id,
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
    await db.execute(
        text(
            f"UPDATE {schema}.job_work_entries SET entry_no=:eno, entry_date=:edate, ledger_id=:lid, "
            f"product_id=:pid, process_id=:prid, rate_id=:rid, quantity=:qty, rate=:rate, amount=:amt, "
            f"entry_type=:et, narration=:narr, updated_at=NOW() WHERE id=:id"
        ),
        {
            "eno": body.entry_no, "edate": body.entry_date, "lid": body.ledger_id,
            "pid": body.product_id, "prid": body.process_id, "rid": body.rate_id,
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
