from fastapi import APIRouter, HTTPException
from sqlalchemy import select
from pydantic import BaseModel, ConfigDict
from datetime import datetime

from app.api.deps import CurrentUser, DBSession
from app.models.master import Company

router = APIRouter()


class CompanySchema(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    name: str
    address: str | None = None
    city: str | None = None
    state: str | None = None
    pincode: str | None = None
    phone: str | None = None
    mobile: str | None = None
    email: str | None = None
    gstin: str | None = None
    pan: str | None = None
    tan: str | None = None
    financial_year_start_month: int = 4
    logo_path: str | None = None


class CompanyUpdate(BaseModel):
    name: str | None = None
    address: str | None = None
    city: str | None = None
    state: str | None = None
    pincode: str | None = None
    phone: str | None = None
    mobile: str | None = None
    email: str | None = None
    gstin: str | None = None
    pan: str | None = None
    tan: str | None = None
    financial_year_start_month: int | None = None


@router.get("/", response_model=CompanySchema)
async def get_company(current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Company))
    company = result.scalar_one_or_none()
    if not company:
        raise HTTPException(status_code=404, detail="Company not configured")
    return company


@router.put("/", response_model=CompanySchema)
async def update_company(body: CompanyUpdate, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Company))
    company = result.scalar_one_or_none()
    if not company:
        # Create
        data = body.model_dump(exclude_none=True)
        data.setdefault("name", "OrbX Nexus Company")
        company = Company(**data)
        db.add(company)
    else:
        for k, v in body.model_dump(exclude_none=True).items():
            setattr(company, k, v)
    await db.flush()
    await db.refresh(company)
    return company
