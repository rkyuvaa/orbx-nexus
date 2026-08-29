from fastapi import APIRouter, HTTPException, Query
from sqlalchemy import select, func
from pydantic import BaseModel, ConfigDict
from typing import Optional

from app.api.deps import CurrentUser, DBSession
from app.models.master import LedgerGroup, Ledger

router = APIRouter()


# ──── Schemas ────

class LedgerGroupOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    name: str
    parent_id: int | None = None
    group_type: str
    is_system: bool


class LedgerGroupCreate(BaseModel):
    name: str
    parent_id: int | None = None
    group_type: str = "Liability"


class LedgerOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    name: str
    ledger_code: str | None = None
    group_id: int
    ledger_type: str
    opening_balance: float
    balance_type: str
    phone: str | None = None
    mobile: str | None = None
    address: str | None = None
    city: str | None = None
    pincode: str | None = None
    state: str | None = None
    gstin: str | None = None
    pan: str | None = None
    bank_name: str | None = None
    bank_account_no: str | None = None
    bank_ifsc: str | None = None
    designation: str | None = None
    department: str | None = None
    basic_salary: float | None = None
    join_date: str | None = None
    is_active: bool


class LedgerCreate(BaseModel):
    name: str
    ledger_code: str | None = None
    group_id: int
    ledger_type: str = "Account"
    opening_balance: float = 0
    balance_type: str = "Dr"
    phone: str | None = None
    mobile: str | None = None
    address: str | None = None
    city: str | None = None
    pincode: str | None = None
    state: str | None = None
    gstin: str | None = None
    pan: str | None = None
    bank_name: str | None = None
    bank_account_no: str | None = None
    bank_ifsc: str | None = None
    designation: str | None = None
    department: str | None = None
    basic_salary: float | None = None
    join_date: str | None = None


class LedgerUpdate(LedgerCreate):
    name: str | None = None
    group_id: int | None = None
    is_active: bool | None = None


from app.api.audit import log_audit_event


# ──── Ledger Groups ────

@router.get("/groups", response_model=list[LedgerGroupOut])
async def list_groups(current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(LedgerGroup).order_by(LedgerGroup.name))
    return result.scalars().all()


@router.post("/groups", response_model=LedgerGroupOut, status_code=201)
async def create_group(body: LedgerGroupCreate, current_user: CurrentUser, db: DBSession):
    group = LedgerGroup(**body.model_dump())
    db.add(group)
    await db.flush()
    await db.refresh(group)
    await log_audit_event(
        db=db, user_id=current_user.id, username=current_user.username,
        action="CREATE", module="LedgerGroups", record_id=group.id
    )
    return group


@router.put("/groups/{group_id}", response_model=LedgerGroupOut)
async def update_group(group_id: int, body: LedgerGroupCreate, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(LedgerGroup).where(LedgerGroup.id == group_id))
    group = result.scalar_one_or_none()
    if not group:
        raise HTTPException(status_code=404, detail="Group not found")
    for k, v in body.model_dump().items():
        setattr(group, k, v)
    await db.flush()
    await db.refresh(group)
    await log_audit_event(
        db=db, user_id=current_user.id, username=current_user.username,
        action="UPDATE", module="LedgerGroups", record_id=group_id
    )
    return group


@router.delete("/groups/{group_id}", status_code=204)
async def delete_group(group_id: int, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(LedgerGroup).where(LedgerGroup.id == group_id))
    group = result.scalar_one_or_none()
    if not group:
        raise HTTPException(status_code=404, detail="Group not found")
    await db.delete(group)
    await log_audit_event(
        db=db, user_id=current_user.id, username=current_user.username,
        action="DELETE", module="LedgerGroups", record_id=group_id
    )


# ──── Ledgers ────

@router.get("/", response_model=list[LedgerOut])
async def list_ledgers(
    current_user: CurrentUser,
    db: DBSession,
    ledger_type: Optional[str] = Query(None),
    group_id: Optional[int] = Query(None),
    is_active: Optional[bool] = Query(None),
    search: Optional[str] = Query(None),
):
    q = select(Ledger)
    if ledger_type:
        q = q.where(Ledger.ledger_type == ledger_type)
    if group_id:
        q = q.where(Ledger.group_id == group_id)
    if is_active is not None:
        q = q.where(Ledger.is_active == is_active)
    if search:
        q = q.where(Ledger.name.ilike(f"%{search}%"))
    q = q.order_by(Ledger.name)
    result = await db.execute(q)
    return result.scalars().all()


@router.get("/{ledger_id}", response_model=LedgerOut)
async def get_ledger(ledger_id: int, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Ledger).where(Ledger.id == ledger_id))
    ledger = result.scalar_one_or_none()
    if not ledger:
        raise HTTPException(status_code=404, detail="Ledger not found")
    return ledger


@router.post("/", response_model=LedgerOut, status_code=201)
async def create_ledger(body: LedgerCreate, current_user: CurrentUser, db: DBSession):
    ledger = Ledger(**body.model_dump())
    db.add(ledger)
    await db.flush()
    await db.refresh(ledger)
    await log_audit_event(
        db=db, user_id=current_user.id, username=current_user.username,
        action="CREATE", module="Ledgers", record_id=ledger.id
    )
    return ledger


@router.put("/{ledger_id}", response_model=LedgerOut)
async def update_ledger(ledger_id: int, body: LedgerUpdate, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Ledger).where(Ledger.id == ledger_id))
    ledger = result.scalar_one_or_none()
    if not ledger:
        raise HTTPException(status_code=404, detail="Ledger not found")
    for k, v in body.model_dump(exclude_none=True).items():
        setattr(ledger, k, v)
    await db.flush()
    await db.refresh(ledger)
    await log_audit_event(
        db=db, user_id=current_user.id, username=current_user.username,
        action="UPDATE", module="Ledgers", record_id=ledger_id
    )
    return ledger


@router.delete("/{ledger_id}", status_code=204)
async def delete_ledger(ledger_id: int, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Ledger).where(Ledger.id == ledger_id))
    ledger = result.scalar_one_or_none()
    if not ledger:
        raise HTTPException(status_code=404, detail="Ledger not found")
    await db.delete(ledger)
    await log_audit_event(
        db=db, user_id=current_user.id, username=current_user.username,
        action="DELETE", module="Ledgers", record_id=ledger_id
    )

