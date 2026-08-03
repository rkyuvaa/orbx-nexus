import sys
import os
import asyncio
import subprocess
from sqlalchemy import text, select

sys.path.insert(0, os.path.dirname(__file__))

if sys.platform == "win32":
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

from app.core.config import settings
from app.db.session import engine, AsyncSessionLocal
from app.db.base_class import Base
from app.db.schema_manager import ensure_year_schema
from app.models.master import User, FinancialYear
from app.core.security import get_password_hash

DEFAULT_YEARS = [
    {"year_str": "2023_2024", "label": "2023-2024", "start_date": "2023-04-01", "end_date": "2024-03-31"},
    {"year_str": "2024_2025", "label": "2024-2025", "start_date": "2024-04-01", "end_date": "2025-03-31"},
    {"year_str": "2025_2026", "label": "2025-2026", "start_date": "2025-04-01", "end_date": "2026-03-31"},
    {"year_str": "2026_2027", "label": "2026-2027", "start_date": "2026-04-01", "end_date": "2027-03-31"},
]


async def flush_all_data():
    print("====================================================")
    print("      OrbX Nexus - Production Data Flush & Reset    ")
    print("====================================================")
    print("\n[1/5] Dropping existing PostgreSQL schemas (master, fy_*)...")

    # 1. Drop all custom schemas
    async with engine.begin() as conn:
        res = await conn.execute(
            text(
                "SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE 'fy_%' OR schema_name = 'master'"
            )
        )
        schemas = [r[0] for r in res.fetchall()]
        for s in schemas:
            print(f"      - Dropping schema '{s}' CASCADE...")
            await conn.execute(text(f"DROP SCHEMA IF EXISTS {s} CASCADE"))
        await conn.commit()

    # 2. Re-create master schema & tables
    print("[2/5] Creating clean master schema & tables...")
    async with engine.begin() as conn:
        await conn.execute(text("CREATE SCHEMA IF NOT EXISTS master"))
        await conn.run_sync(Base.metadata.create_all)
        # Apply column migrations
        await conn.execute(
            text("ALTER TABLE master.processes ADD COLUMN IF NOT EXISTS gst_percent NUMERIC(5,2) DEFAULT 0.0")
        )
        for col in ("city VARCHAR(100)", "pincode VARCHAR(10)", "state VARCHAR(100)"):
            await conn.execute(text(f"ALTER TABLE master.ledgers ADD COLUMN IF NOT EXISTS {col}"))
        for col in ("company_rate NUMERIC(15, 4) DEFAULT 0", "contractor_rate NUMERIC(15, 4) DEFAULT 0"):
            await conn.execute(text(f"ALTER TABLE master.processes ADD COLUMN IF NOT EXISTS {col}"))
        await conn.execute(text("ALTER TABLE master.products ADD COLUMN IF NOT EXISTS weight NUMERIC(15, 3) DEFAULT 0"))
        await conn.commit()

    # 3. Re-create financial year schemas & tables
    print("[3/5] Creating clean financial year schemas (2023-2027)...")
    for fy in DEFAULT_YEARS:
        await ensure_year_schema(fy["year_str"], engine)
        async with engine.begin() as conn:
            for col in (
                "items JSONB DEFAULT '[]'::jsonb",
                "outward_ids JSONB DEFAULT '[]'::jsonb",
                "dispatch_through VARCHAR(255)",
            ):
                await conn.execute(
                    text(f"ALTER TABLE fy_{fy['year_str']}.labour_bills ADD COLUMN IF NOT EXISTS {col}")
                )
            await conn.commit()

    # 4. Seed default financial years & default admin user
    print("[4/5] Seeding clean configuration & initial Admin credentials...")
    async with AsyncSessionLocal() as db:
        for fy in DEFAULT_YEARS:
            res_fy = await db.execute(
                select(FinancialYear).where(FinancialYear.year_str == fy["year_str"])
            )
            if not res_fy.scalar_one_or_none():
                is_active = fy["year_str"] == "2026_2027"
                db.add(
                    FinancialYear(
                        year_str=fy["year_str"],
                        label=fy["label"],
                        start_date=fy["start_date"],
                        end_date=fy["end_date"],
                        schema_name=f"fy_{fy['year_str']}",
                        is_active=is_active,
                        is_locked=fy["year_str"] in ("2023_2024", "2024_2025"),
                    )
                )

        res_user = await db.execute(select(User).where(User.username == "admin"))
        user = res_user.scalar_one_or_none()
        if not user:
            admin = User(
                username="admin",
                hashed_password=get_password_hash("admin@orbx"),
                full_name="System Administrator",
                role="Admin",
                is_active=True,
            )
            db.add(admin)
        else:
            user.hashed_password = get_password_hash("admin@orbx")
            user.is_active = True
        await db.commit()

    # 5. Flush Redis Cache
    print("[5/5] Flushing Redis cache...")
    try:
        res = subprocess.run(
            ["docker", "exec", "orbx_nexus_redis", "redis-cli", "FLUSHALL"],
            capture_output=True,
            text=True,
        )
        if res.returncode == 0:
            print("      - Redis cache flushed successfully.")
        else:
            print(f"      - Redis flush note: {res.stderr.strip()}")
    except Exception as e:
        print(f"      - Skipping local Docker redis flush: {e}")

    print("\n====================================================")
    print(" SUCCESS: Database & Cache successfully flushed!    ")
    print(" Ready for Cloud Server Deployment.                ")
    print(" Initial Admin Account created:                    ")
    print("   Username: admin                                  ")
    print("   Password: admin@orbx                             ")
    print("====================================================")


if __name__ == "__main__":
    asyncio.run(flush_all_data())
