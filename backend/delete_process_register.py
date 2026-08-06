import asyncio
import os
import sys
from sqlalchemy import text

sys.path.insert(0, os.path.dirname(__file__))

from app.db.session import AsyncSessionLocal

async def main():
    print("====================================================")
    print("         Deleting All Process Register Records      ")
    print("====================================================")
    
    async with AsyncSessionLocal() as db:
        try:
            print("Clearing master.rates and master.processes...")
            await db.execute(text("TRUNCATE master.rates, master.processes CASCADE;"))
            await db.commit()
            print("\n SUCCESS: Process Register records have been deleted!")
        except Exception as e:
            await db.rollback()
            print(f"\n ERROR: Failed to delete records: {e}")

if __name__ == "__main__":
    if sys.platform == "win32":
        asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
    asyncio.run(main())
