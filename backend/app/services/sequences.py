from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.master import DocumentSequence

async def get_next_sequence_preview(db: AsyncSession, document_type: str) -> str:
    result = await db.execute(
        select(DocumentSequence).where(DocumentSequence.document_type == document_type)
    )
    seq = result.scalar_one_or_none()
    if not seq:
        return ""
    next_num = seq.current_number + 1
    num_str = str(next_num).zfill(seq.padding_width)
    return f"{seq.prefix}{num_str}{seq.suffix}"

async def generate_and_increment_sequence(db: AsyncSession, document_type: str) -> str:
    result = await db.execute(
        select(DocumentSequence).where(DocumentSequence.document_type == document_type).with_for_update()
    )
    seq = result.scalar_one_or_none()
    if not seq:
        return "GEN-001"
    
    seq.current_number += 1
    num_str = str(seq.current_number).zfill(seq.padding_width)
    formatted = f"{seq.prefix}{num_str}{seq.suffix}"
    await db.flush()
    return formatted
