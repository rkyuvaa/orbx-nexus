"""
API dependency functions.
- get_current_user: extract and validate JWT
- get_db: async DB session
- check_permission: RBAC enforcement
"""
from typing import Annotated
from fastapi import Depends, HTTPException, status, Query
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.db.session import get_db
from app.core.security import verify_token
from app.models.master import User, RolePermission

bearer_scheme = HTTPBearer()


async def get_current_user(
    credentials: Annotated[HTTPAuthorizationCredentials, Depends(bearer_scheme)],
    db: AsyncSession = Depends(get_db),
) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    payload = verify_token(credentials.credentials)
    if payload is None:
        raise credentials_exception

    user_id: int = payload.get("sub")
    if user_id is None:
        raise credentials_exception

    result = await db.execute(select(User).where(User.id == int(user_id), User.is_active == True))
    user = result.scalar_one_or_none()
    if user is None:
        raise credentials_exception
    return user


CurrentUser = Annotated[User, Depends(get_current_user)]
DBSession = Annotated[AsyncSession, Depends(get_db)]


def require_permission(module: str, action: str = "view"):
    """Returns a dependency that checks RBAC permissions."""
    async def _check(
        current_user: CurrentUser,
        db: DBSession,
    ):
        if current_user.role == "Admin":
            return current_user  # Admins bypass all checks

        result = await db.execute(
            select(RolePermission).where(
                RolePermission.user_id == current_user.id,
                RolePermission.module == module,
            )
        )
        perm = result.scalar_one_or_none()

        if perm is None:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"No access to module: {module}",
            )

        action_map = {
            "view": perm.can_view,
            "create": perm.can_create,
            "edit": perm.can_edit,
            "delete": perm.can_delete,
            "print": perm.can_print,
        }
        if not action_map.get(action, False):
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Permission denied: {action} on {module}",
            )
        return current_user

    return _check


def get_fy_schema(fy: str = Query(default="2026_2027")) -> str:
    """Extract financial year schema from query param."""
    return f"fy_{fy}"
