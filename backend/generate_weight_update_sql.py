import sys
import asyncio
from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine

if sys.platform == "win32":
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

PG_URL = "postgresql+psycopg://orbx:orbx_secret@localhost:5432/orbx_nexus"

async def generate_sql():
    engine = create_async_engine(PG_URL)
    async with engine.begin() as conn:
        res = await conn.execute(text("SELECT product_code, weight FROM master.products WHERE weight > 0;"))
        rows = res.fetchall()
        
    sql_lines = ["-- Update Product Weights in master.products\n"]
    for code, weight in rows:
        sql_lines.append(f"UPDATE master.products SET weight = {weight} WHERE product_code = '{code}';")
    
    out_path = "d:/OrbX Nexus/backend/backups/update_product_weights.sql"
    with open(out_path, "w", encoding="utf-8") as f:
        f.write("\n".join(sql_lines))
        
    print(f"[OK] Generated {len(rows)} weight update SQL statements in {out_path}")

if __name__ == "__main__":
    asyncio.run(generate_sql())
