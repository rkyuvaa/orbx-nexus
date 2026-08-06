import sys
import os
import asyncio
from sqlalchemy import text

sys.path.insert(0, os.path.dirname(__file__))

if sys.platform == "win32":
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

from app.db.session import engine

async def delete_records():
    print("====================================================")
    print("      Deleting Process Register & Labour Bills     ")
    print("====================================================")
    
    async with engine.begin() as conn:
        # 1. Clear Process Register (master.rates and master.processes)
        print("[1/2] Clearing Process Register (master.rates & master.processes)...")
        await conn.execute(text("TRUNCATE TABLE master.rates CASCADE;"))
        await conn.execute(text("TRUNCATE TABLE master.processes CASCADE;"))
        print("      - Process Register cleared.")
        
        # 2. Clear Labour Bills across all financial year schemas
        print("[2/2] Clearing Labour Bills across all schemas...")
        res = await conn.execute(text(
            "SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE 'fy_%'"
        ))
        schemas = [r[0] for r in res.fetchall()]
        
        for s in schemas:
            print(f"      - Truncating labour_bills from schema '{s}'...")
            await conn.execute(text(f"TRUNCATE TABLE {s}.labour_bills CASCADE;"))
            
        await conn.commit()
        
    print("\n====================================================")
    print(" SUCCESS: Process Register & Labour Bills deleted!  ")
    print("====================================================")

if __name__ == "__main__":
    asyncio.run(delete_records())
