from datetime import timedelta
from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.api.deps import get_db, get_current_user, DBSession, CurrentUser
from app.core.security import verify_password, get_password_hash, create_access_token
from app.core.config import settings
from app.models.master import User, RolePermission
from pydantic import BaseModel, ConfigDict

router = APIRouter()


# ──────── Schemas ────────

class Token(BaseModel):
    access_token: str
    token_type: str
    user: "UserOut"


class UserOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    username: str
    full_name: str | None
    email: str | None
    role: str
    is_active: bool


class UserCreate(BaseModel):
    username: str
    password: str
    full_name: str | None = None
    email: str | None = None
    role: str = "User"


class UserUpdate(BaseModel):
    full_name: str | None = None
    email: str | None = None
    role: str | None = None
    is_active: bool | None = None
    password: str | None = None


class PermissionSchema(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    module: str
    can_view: bool = True
    can_create: bool = False
    can_edit: bool = False
    can_delete: bool = False
    can_print: bool = True


Token.model_rebuild()


# ──────── Routes ────────

from app.api.audit import log_audit_event

@router.post("/login", response_model=Token)
async def login(
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
    db: DBSession,
):
    result = await db.execute(
        select(User).where(User.username == form_data.username, User.is_active == True)
    )
    user = result.scalar_one_or_none()

    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token = create_access_token(
        data={"sub": str(user.id), "username": user.username, "role": user.role},
        expires_delta=timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES),
    )
    await log_audit_event(
        db=db,
        user_id=user.id,
        username=user.username,
        action="LOGIN",
        module="Auth",
        record_id=user.id,
    )
    return Token(
        access_token=access_token,
        token_type="bearer",
        user=UserOut.model_validate(user),
    )


@router.get("/me", response_model=UserOut)
async def get_me(current_user: CurrentUser):
    return current_user


@router.get("/users", response_model=list[UserOut])
async def list_users(current_user: CurrentUser, db: DBSession):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    result = await db.execute(select(User).order_by(User.username))
    return result.scalars().all()


@router.post("/users", response_model=UserOut, status_code=201)
async def create_user(body: UserCreate, current_user: CurrentUser, db: DBSession):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    existing = await db.execute(select(User).where(User.username == body.username))
    if existing.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Username already exists")
    user = User(
        username=body.username,
        hashed_password=get_password_hash(body.password),
        full_name=body.full_name,
        email=body.email,
        role=body.role,
        is_active=True,
    )
    db.add(user)
    await db.flush()
    await db.refresh(user)
    await log_audit_event(
        db=db,
        user_id=current_user.id,
        username=current_user.username,
        action="CREATE",
        module="UserManagement",
        record_id=user.id,
        new_values={"username": user.username, "role": user.role},
    )
    return user


@router.put("/users/{user_id}", response_model=UserOut)
async def update_user(user_id: int, body: UserUpdate, current_user: CurrentUser, db: DBSession):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    if body.full_name is not None:
        user.full_name = body.full_name
    if body.email is not None:
        user.email = body.email
    if body.role is not None:
        user.role = body.role
    if body.is_active is not None:
        user.is_active = body.is_active
    if body.password:
        user.hashed_password = get_password_hash(body.password)
    await db.flush()
    await db.refresh(user)
    await log_audit_event(
        db=db,
        user_id=current_user.id,
        username=current_user.username,
        action="UPDATE",
        module="UserManagement",
        record_id=user_id,
        new_values=body.model_dump(exclude={"password"}, exclude_none=True),
    )
    return user


@router.delete("/users/{user_id}", status_code=204)
async def delete_user(user_id: int, current_user: CurrentUser, db: DBSession):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    if user_id == current_user.id:
        raise HTTPException(status_code=400, detail="Cannot delete yourself")
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    await db.delete(user)
    await log_audit_event(
        db=db,
        user_id=current_user.id,
        username=current_user.username,
        action="DELETE",
        module="UserManagement",
        record_id=user_id,
    )


@router.get("/users/{user_id}/permissions", response_model=list[PermissionSchema])
async def get_user_permissions(user_id: int, current_user: CurrentUser, db: DBSession):
    if current_user.role != "Admin" and current_user.id != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    result = await db.execute(
        select(RolePermission).where(RolePermission.user_id == user_id)
    )
    return result.scalars().all()


@router.put("/users/{user_id}/permissions", response_model=list[PermissionSchema])
async def set_user_permissions(
    user_id: int,
    perms: list[PermissionSchema],
    current_user: CurrentUser,
    db: DBSession,
):
    if current_user.role != "Admin":
        raise HTTPException(status_code=403, detail="Admin only")
    # Delete existing and recreate
    result = await db.execute(
        select(RolePermission).where(RolePermission.user_id == user_id)
    )
    for existing in result.scalars().all():
        await db.delete(existing)
    await db.flush()

    new_perms = []
    for p in perms:
        perm = RolePermission(user_id=user_id, **p.model_dump())
        db.add(perm)
        new_perms.append(perm)
    await db.flush()
    await log_audit_event(
        db=db,
        user_id=current_user.id,
        username=current_user.username,
        action="UPDATE_PERMISSIONS",
        module="UserManagement",
        record_id=user_id,
    )
    return new_perms

