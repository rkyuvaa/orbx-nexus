from fastapi import APIRouter, HTTPException, Query, Depends
from sqlalchemy import select
from pydantic import BaseModel, ConfigDict
from typing import Optional

from app.api.deps import CurrentUser, DBSession
from app.models.master import DocumentSequence
from app.services.sequences import get_next_sequence_preview

router = APIRouter()

class DocumentSequenceOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    document_type: str
    prefix: str
    suffix: str
    current_number: int
    padding_width: int

class DocumentSequenceUpdate(BaseModel):
    prefix: str
    suffix: str
    current_number: int
    padding_width: int

@router.get("/preview/{document_type}")
async def get_sequence_preview(document_type: str, current_user: CurrentUser, db: DBSession):
    preview = await get_next_sequence_preview(db, document_type)
    if not preview:
        raise HTTPException(status_code=404, detail="Sequence type not found")
    return {"next_no": preview}

@router.get("/settings", response_model=list[DocumentSequenceOut])
async def list_sequence_settings(current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(DocumentSequence).order_by(DocumentSequence.document_type))
    return result.scalars().all()

from app.api.audit import log_audit_event

@router.put("/settings/{id}")
async def update_sequence_setting(id: int, body: DocumentSequenceUpdate, current_user: CurrentUser, db: DBSession):
    if current_user.role != "Admin":
         raise HTTPException(status_code=403, detail="Forbidden: Admin only")
    result = await db.execute(select(DocumentSequence).where(DocumentSequence.id == id))
    seq = result.scalar_one_or_none()
    if not seq:
        raise HTTPException(status_code=404, detail="Sequence setting not found")
    
    seq.prefix = body.prefix
    seq.suffix = body.suffix
    seq.current_number = body.current_number
    seq.padding_width = body.padding_width
    await db.flush()
    await log_audit_event(
        db=db,
        user_id=current_user.id,
        username=current_user.username,
        action="UPDATE",
        module="DocumentNumbering/Settings",
        record_id=id,
        new_values=body.model_dump(),
    )
    return {"message": "Sequence setting updated"}

