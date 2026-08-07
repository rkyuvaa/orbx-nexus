import sys
import os
import asyncio
from sqlalchemy import text

sys.path.insert(0, os.path.dirname(__file__))

if sys.platform == "win32":
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

from app.db.session import engine

TABLES_TO_TRUNCATE = [
    "voucher_lines",
    "vouchers",
    "stock_outward",
    "stock_inward",
    "stock_transfer",
    "stock_adjustments",
    "stock_item_movements",
    "labour_bills",
    "salary_vouchers",
    "advance_payments",
    "job_work_entries",
    "biometric_entries",
    "audit_logs"
]

async def delete_previous_transactions():
    print("====================================================")
    print("   Deleting Previous Years' Transactional Records   ")
    print("====================================================")
    
    async with engine.begin() as conn:
        # Get all schemas starting with fy_
        res = await conn.execute(text(
            "SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE 'fy_%'"
        ))
        schemas = [r[0] for r in res.fetchall()]
        
        # We want to KEEP fy_2026_2027, so we filter it out
        target_schemas = [s for s in schemas if s != "fy_2026_2027"]
        
        if not target_schemas:
            print("No previous year schemas found (excluding fy_2026_2027).")
            return
            
        print(f"Target schemas to clear: {target_schemas}")
        
        for s in target_schemas:
            print(f"\nClearing schema '{s}'...")
            for table in TABLES_TO_TRUNCATE:
                try:
                    # Use CASCADE to handle any foreign key relationships within the schema
                    await conn.execute(text(f"TRUNCATE TABLE {s}.{table} CASCADE;"))
                    print(f"      - Truncated table {s}.{table}")
                except Exception as e:
                    print(f"      - Note: Could not truncate {s}.{table}: {e}")
            
        await conn.commit()
        
    print("\n====================================================")
    print(" SUCCESS: Previous years' transaction data deleted! ")
    print(" Keep 2026-2027 data intact.                         ")
    print("====================================================")

if __name__ == "__main__":
    asyncio.run(delete_previous_transactions())
