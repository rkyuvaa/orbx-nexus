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

    show_logo: bool = True
    voucher_paper_size: str = "A5"
    inward_paper_size: str = "A4"
    outward_paper_size: str = "A5"
    bill_paper_size: str = "A4"
    report_paper_size: str = "A4"
    grid_paper_size: str = "A4"

    voucher_title: str | None = "Voucher Receipt"
    voucher_terms: str | None = ""
    inward_title: str | None = "Inward Challan"
    inward_terms: str | None = ""
    outward_title: str | None = "Delivery Note"
    outward_terms: str | None = ""
    bill_title: str | None = "Labour Bill Invoice"
    bill_terms: str | None = ""


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
    logo_path: str | None = None

    show_logo: bool | None = None
    voucher_paper_size: str | None = None
    inward_paper_size: str | None = None
    outward_paper_size: str | None = None
    bill_paper_size: str | None = None
    report_paper_size: str | None = None
    grid_paper_size: str | None = None

    voucher_title: str | None = None
    voucher_terms: str | None = None
    inward_title: str | None = None
    inward_terms: str | None = None
    outward_title: str | None = None
    outward_terms: str | None = None
    bill_title: str | None = None
    bill_terms: str | None = None


from app.api.audit import log_audit_event


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
    action = "UPDATE"
    if not company:
        action = "CREATE"
        data = body.model_dump(exclude_none=True)
        data.setdefault("name", "OrbX Nexus Company")
        company = Company(**data)
        db.add(company)
    else:
        for k, v in body.model_dump(exclude_none=True).items():
            setattr(company, k, v)
    await db.flush()
    await db.commit()
    await db.refresh(company)

    await log_audit_event(
        db=db,
        user_id=current_user.id,
        username=current_user.username,
        action=action,
        module="Company/Settings",
        record_id=company.id,
        new_values=body.model_dump(exclude_none=True),
    )
    return company

