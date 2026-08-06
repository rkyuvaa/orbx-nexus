import asyncio
import os
import sys
from sqlalchemy import text

# Make sure app path is in python path
sys.path.insert(0, os.path.dirname(__file__))

from app.db.session import AsyncSessionLocal

YEARS = ["2023_2024", "2024_2025", "2025_2026", "2026_2027"]

async def main():
    print("====================================================")
    print("         Deleting All Inward & Outward Vouchers     ")
    print("====================================================")
    
    async with AsyncSessionLocal() as db:
        try:
            for yr in YEARS:
                schema = f"fy_{yr}"
                print(f"Clearing stock_inward and stock_outward in schema '{schema}'...")
                await db.execute(text(f"TRUNCATE {schema}.stock_inward, {schema}.stock_outward CASCADE;"))
            await db.commit()
            print("\n SUCCESS: All stock inward and outward records have been deleted!")
        except Exception as e:
            await db.rollback()
            print(f"\n ERROR: Failed to clear records: {e}")

if __name__ == "__main__":
    # For Windows asyncio event loop policy
    if sys.platform == "win32":
        asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
    asyncio.run(main())
