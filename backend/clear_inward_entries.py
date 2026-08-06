import sys
import asyncio
from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine

if sys.platform == "win32":
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

PG_URL = "postgresql+psycopg://orbx:orbx_secret@localhost:5432/orbx_nexus"

async def delete_inward_entries():
    engine = create_async_engine(PG_URL)
    async with engine.begin() as conn:
        print("[CLEAR INWARD] Finding all financial year schemas...")
        res = await conn.execute(text(
            "SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE 'fy_%'"
        ))
        schemas = [r[0] for r in res.fetchall()]
        
        for s in schemas:
            print(f"      - Truncating stock inward entries from '{s}'...")
            await conn.execute(text(f"TRUNCATE TABLE {s}.stock_inward CASCADE;"))
            await conn.execute(text(f"DELETE FROM {s}.stock_item_movements WHERE movement_type = 'Inward';"))
        await conn.commit()
    print("[SUCCESS] All stock inward entries deleted across all financial years!")

if __name__ == "__main__":
    asyncio.run(delete_inward_entries())
