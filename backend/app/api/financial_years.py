from fastapi import APIRouter, Query
from sqlalchemy import text

from app.api.deps import CurrentUser, DBSession
from app.db.schema_manager import ensure_year_schema, get_year_schemas
from app.db.session import engine
from app.models.master import FinancialYear
from sqlalchemy import select
from pydantic import BaseModel

router = APIRouter()


class FYCreate(BaseModel):
    year_str: str  # e.g. 2027_2028
    label: str     # e.g. 2027-2028
    start_date: str
    end_date: str


@router.get("/")
async def list_financial_years(current_user: CurrentUser, db: DBSession):
    result = await db.execute(
        select(FinancialYear).order_by(FinancialYear.year_str.desc())
    )
    years = result.scalars().all()
    return [
        {
            "id": y.id, "year_str": y.year_str, "label": y.label,
            "start_date": y.start_date, "end_date": y.end_date,
            "is_active": y.is_active, "is_locked": y.is_locked,
            "schema_name": y.schema_name
        }
        for y in years
    ]


@router.post("/", status_code=201)
async def create_financial_year(body: FYCreate, current_user: CurrentUser, db: DBSession):
    if current_user.role != "Admin":
        from fastapi import HTTPException
        raise HTTPException(status_code=403, detail="Admin only")

    schema_name = f"fy_{body.year_str}"
    # Create the PostgreSQL schema + transaction tables
    await ensure_year_schema(body.year_str, engine)

    # Record in DB
    fy = FinancialYear(
        year_str=body.year_str,
        label=body.label,
        start_date=body.start_date,
        end_date=body.end_date,
        schema_name=schema_name,
        is_active=False,
        is_locked=False,
    )
    db.add(fy)
    await db.flush()
    await db.refresh(fy)
    return {"id": fy.id, "schema_name": schema_name, "message": "Financial year created"}


@router.patch("/{fy_id}/set-active")
async def set_active_year(fy_id: int, current_user: CurrentUser, db: DBSession):
    if current_user.role != "Admin":
        from fastapi import HTTPException
        raise HTTPException(status_code=403, detail="Admin only")
    # Deactivate all
    await db.execute(text("UPDATE master.financial_years SET is_active = FALSE"))
    # Activate selected
    await db.execute(
        text("UPDATE master.financial_years SET is_active = TRUE WHERE id = :id"),
        {"id": fy_id}
    )
    return {"message": "Active year updated"}


@router.patch("/{fy_id}/lock")
async def lock_year(fy_id: int, current_user: CurrentUser, db: DBSession):
    if current_user.role != "Admin":
        from fastapi import HTTPException
        raise HTTPException(status_code=403, detail="Admin only")
    await db.execute(
        text("UPDATE master.financial_years SET is_locked = TRUE WHERE id = :id"),
        {"id": fy_id}
    )
    return {"message": "Year locked"}
