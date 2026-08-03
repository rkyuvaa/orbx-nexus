from fastapi import APIRouter, Query
from sqlalchemy import text
from pydantic import BaseModel
from typing import Optional

from app.api.deps import CurrentUser, DBSession

router = APIRouter()


def s(fy: str) -> str:
    return f"fy_{fy}"


class EBReadingIn(BaseModel):
    reading_date: str
    meter_no: str | None = None
    previous_reading: float = 0
    current_reading: float = 0
    units_consumed: float = 0
    rate_per_unit: float = 0
    amount: float = 0
    narration: str | None = None


@router.get("/eb-readings")
async def list_eb_readings(
    current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027"),
    from_date: Optional[str] = None, to_date: Optional[str] = None
):
    schema = s(fy)
    conds = ["1=1"]
    params: dict = {}
    if from_date:
        conds.append("reading_date >= :fd")
        params["fd"] = from_date
    if to_date:
        conds.append("reading_date <= :td")
        params["td"] = to_date
    result = await db.execute(
        text(f"SELECT * FROM {schema}.eb_readings WHERE {' AND '.join(conds)} ORDER BY reading_date DESC"),
        params
    )
    return [dict(r) for r in result.mappings().all()]


@router.post("/eb-readings", status_code=201)
async def create_eb_reading(
    body: EBReadingIn, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    schema = s(fy)
    result = await db.execute(
        text(
            f"INSERT INTO {schema}.eb_readings "
            f"(reading_date, meter_no, previous_reading, current_reading, units_consumed, "
            f"rate_per_unit, amount, narration, created_by) "
            f"VALUES (:rdate, :mno, :prev, :curr, :units, :rpu, :amt, :narr, :cby) RETURNING id"
        ),
        {
            "rdate": body.reading_date, "mno": body.meter_no, "prev": body.previous_reading,
            "curr": body.current_reading, "units": body.units_consumed,
            "rpu": body.rate_per_unit, "amt": body.amount, "narr": body.narration,
            "cby": current_user.id
        }
    )
    return {"id": result.scalar_one(), "message": "EB reading created"}


@router.delete("/eb-readings/{rid}", status_code=204)
async def delete_eb_reading(
    rid: int, current_user: CurrentUser, db: DBSession, fy: str = Query(default="2026_2027")
):
    await db.execute(text(f"DELETE FROM {s(fy)}.eb_readings WHERE id = :id"), {"id": rid})
