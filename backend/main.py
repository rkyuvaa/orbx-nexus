import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

if sys.platform == "win32":
    import asyncio
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

import uvicorn
from contextlib import asynccontextmanager
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import select, func, text

from app.core.config import settings
from app.db.session import engine, AsyncSessionLocal
from app.db.base_class import Base
from app.db.schema_manager import ensure_master_schema, ensure_year_schema
from app.models.master import User, FinancialYear, DocumentSequence
from app.core.security import get_password_hash, verify_token

# Import all API routers
from app.api import (
    auth, company, ledgers, products, vouchers,
    stock, labour_bill, salary, contractor,
    reports, biometrics, backups,
    audit, financial_years, sequences,
)

DEFAULT_YEARS = [
    {"year_str": "2023_2024", "label": "2023-2024", "start_date": "2023-04-01", "end_date": "2024-03-31"},
    {"year_str": "2024_2025", "label": "2024-2025", "start_date": "2024-04-01", "end_date": "2025-03-31"},
    {"year_str": "2025_2026", "label": "2025-2026", "start_date": "2025-04-01", "end_date": "2026-03-31"},
    {"year_str": "2026_2027", "label": "2026-2027", "start_date": "2026-04-01", "end_date": "2027-03-31"},
]


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application startup and shutdown."""
    print("[STARTUP] OrbX Nexus starting up...")

    # 1. Ensure master schema exists
    await ensure_master_schema(engine)
    print("[OK] Master schema ready")

    # 2. Create all master schema tables
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
        # Migrate ledger table if needed
        for col in ("city VARCHAR(100)", "pincode VARCHAR(10)", "state VARCHAR(100)"):
            await conn.execute(text(f"ALTER TABLE master.ledgers ADD COLUMN IF NOT EXISTS {col}"))
        # Migrate processes table if needed
        for col in ("company_rate NUMERIC(15, 4) DEFAULT 0", "contractor_rate NUMERIC(15, 4) DEFAULT 0"):
            await conn.execute(text(f"ALTER TABLE master.processes ADD COLUMN IF NOT EXISTS {col}"))
        # Migrate products table if needed
        await conn.execute(text("ALTER TABLE master.products ADD COLUMN IF NOT EXISTS weight NUMERIC(15, 3) DEFAULT 0"))
        
        # Migrate company table print settings and logo_path columns if needed
        for col, col_type in [
            ("show_logo", "BOOLEAN DEFAULT TRUE"),
            ("voucher_paper_size", "VARCHAR(10) DEFAULT 'A5'"),
            ("inward_paper_size", "VARCHAR(10) DEFAULT 'A4'"),
            ("outward_paper_size", "VARCHAR(10) DEFAULT 'A5'"),
            ("bill_paper_size", "VARCHAR(10) DEFAULT 'A4'"),
            ("report_paper_size", "VARCHAR(10) DEFAULT 'A4'"),
            ("grid_paper_size", "VARCHAR(10) DEFAULT 'A4'"),
            ("voucher_title", "VARCHAR(200) DEFAULT 'Voucher Receipt'"),
            ("voucher_terms", "TEXT DEFAULT '1. Subject to local jurisdiction.\n2. This is a computer-generated voucher and requires no physical signature.'"),
            ("inward_title", "VARCHAR(200) DEFAULT 'Inward Challan'"),
            ("inward_terms", "TEXT DEFAULT '1. Received goods are subject to count & quality checks.\n2. Report discrepancies within 24 hours.'"),
            ("outward_title", "VARCHAR(200) DEFAULT 'Delivery Note'"),
            ("outward_terms", "TEXT DEFAULT '1. Goods once sold/delivered cannot be taken back.\n2. Subject to company terms of carriage.'"),
            ("bill_title", "VARCHAR(200) DEFAULT 'Labour Bill Invoice'"),
            ("bill_terms", "TEXT DEFAULT '1. Payment terms: Net 15 days.\n2. Interest @ 18% p.a. will be charged for delayed payments.'"),
        ]:
            await conn.execute(text(f"ALTER TABLE master.company ADD COLUMN IF NOT EXISTS {col} {col_type}"))
        
        # Alter logo_path type to TEXT if it's currently string
        await conn.execute(text("ALTER TABLE master.company ALTER COLUMN logo_path TYPE TEXT"))
        # Migrate locations table if needed
        for col in (
            "p1_id INTEGER REFERENCES master.ledgers(id)",
            "p1_from VARCHAR(10)",
            "p1_to VARCHAR(10)",
            "p2_id INTEGER REFERENCES master.ledgers(id)",
            "p2_from VARCHAR(10)",
            "p2_to VARCHAR(10)"
        ):
            await conn.execute(text(f"ALTER TABLE master.locations ADD COLUMN IF NOT EXISTS {col}"))
    print("[OK] Master tables created")

    # 3. Ensure financial year schemas exist and run migrations on year tables
    for fy in DEFAULT_YEARS:
        try:
            await ensure_year_schema(fy["year_str"], engine)
            print(f"[OK] Schema fy_{fy['year_str']} ready")
            async with engine.begin() as conn:
                for col in ("items JSONB DEFAULT '[]'::jsonb", "outward_ids JSONB DEFAULT '[]'::jsonb", "dispatch_through VARCHAR(255)", "freight_items JSONB DEFAULT '[]'::jsonb"):
                    await conn.execute(text(f"ALTER TABLE fy_{fy['year_str']}.labour_bills ADD COLUMN IF NOT EXISTS {col}"))
                await conn.execute(
                    text(
                        f"ALTER TABLE fy_{fy['year_str']}.stock_item_movements "
                        f"ADD COLUMN IF NOT EXISTS items JSONB DEFAULT '[]'::jsonb"
                    )
                )
                await conn.execute(
                    text(
                        f"ALTER TABLE fy_{fy['year_str']}.job_work_entries "
                        f"ADD COLUMN IF NOT EXISTS outward_id INTEGER REFERENCES fy_{fy['year_str']}.stock_outward(id)"
                    )
                )
                await conn.execute(
                    text(
                        f"ALTER TABLE fy_{fy['year_str']}.job_work_entries "
                        f"ADD COLUMN IF NOT EXISTS outward_ids JSONB DEFAULT '[]'::jsonb"
                    )
                )
                await conn.execute(
                    text(
                        f"ALTER TABLE fy_{fy['year_str']}.job_work_entries "
                        f"ADD COLUMN IF NOT EXISTS items JSONB DEFAULT '[]'::jsonb"
                    )
                )
                await conn.execute(
                    text(
                        f"ALTER TABLE fy_{fy['year_str']}.job_work_entries "
                        f"ADD COLUMN IF NOT EXISTS is_paid BOOLEAN DEFAULT FALSE"
                    )
                )
                await conn.execute(
                    text(
                        f"ALTER TABLE fy_{fy['year_str']}.job_work_entries "
                        f"ADD COLUMN IF NOT EXISTS register_ids JSONB DEFAULT '[]'::jsonb"
                    )
                )
            print(f"[OK] Schema fy_{fy['year_str']} tables migrated")
        except Exception as e:
            print(f"[WARNING] Could not create/migrate schema for {fy['year_str']}: {e}")

    # 4. Initialize financial year records
    async with AsyncSessionLocal() as db:
        for fy in DEFAULT_YEARS:
            result = await db.execute(
                select(FinancialYear).where(FinancialYear.year_str == fy["year_str"])
            )
            if not result.scalar_one_or_none():
                is_active = fy["year_str"] == "2026_2027"
                db.add(FinancialYear(
                    year_str=fy["year_str"],
                    label=fy["label"],
                    start_date=fy["start_date"],
                    end_date=fy["end_date"],
                    schema_name=f"fy_{fy['year_str']}",
                    is_active=is_active,
                    is_locked=fy["year_str"] in ("2023_2024", "2024_2025"),
                ))
        await db.commit()

    # 5. Initialize default document sequences
    async with AsyncSessionLocal() as db:
        default_sequences = [
            {"document_type": "stock_inward", "prefix": "INW-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "stock_outward", "prefix": "OUT-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "job_work_register", "prefix": "JWR-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "job_work_payment", "prefix": "JWP-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "job_work_advance_payment", "prefix": "JWA-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "job_work_advance_receipt", "prefix": "JWAR-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "voucher_payment", "prefix": "PAY-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "voucher_receipt", "prefix": "REC-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "voucher_contra", "prefix": "CON-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "voucher_journal", "prefix": "JOU-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "voucher_purchase", "prefix": "PUR-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "labour_bill", "prefix": "LBB-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "staff_advance_payment", "prefix": "SAP-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "staff_advance_receipt", "prefix": "SAR-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "salary_voucher", "prefix": "SAL-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "stock_adjustment", "prefix": "ADJ-", "suffix": "/26-27", "current_number": 0, "padding_width": 3},
            {"document_type": "inventory_inward", "prefix": "INV-IN/", "suffix": "", "current_number": 0, "padding_width": 4},
            {"document_type": "inventory_outward", "prefix": "INV-OUT/", "suffix": "", "current_number": 0, "padding_width": 4},
        ]
        for seq in default_sequences:
            result = await db.execute(
                select(DocumentSequence).where(DocumentSequence.document_type == seq["document_type"])
            )
            if not result.scalar_one_or_none():
                db.add(DocumentSequence(**seq))
        await db.commit()

    # 6. Ensure default admin user
    async with AsyncSessionLocal() as db:
        result = await db.execute(select(func.count(User.id)))
        count = result.scalar()
        if count == 0:
            admin = User(
                username="admin",
                hashed_password=get_password_hash("admin@orbx"),
                full_name="System Administrator",
                role="Admin",
                is_active=True,
            )
            db.add(admin)
            await db.commit()
            print("[OK] Default admin user created (admin / admin@orbx)")
        else:
            print(f"[OK] {count} user(s) found in database")

    print("[READY] OrbX Nexus is ready!")
    yield
    print("[SHUTDOWN] OrbX Nexus shutting down...")


app = FastAPI(
    title=settings.PROJECT_NAME,
    version="2.0.0",
    description="OrbX Nexus ERP — Manufacturing Management System",
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    docs_url=f"{settings.API_V1_STR}/docs",
    redoc_url=f"{settings.API_V1_STR}/redoc",
    lifespan=lifespan,
)

# CORS — allow all origins for local dev
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.middleware("http")
async def audit_logger_middleware(request: Request, call_next):
    response = await call_next(request)
    if request.method in ("POST", "PUT", "DELETE", "PATCH"):
        path = request.url.path
        if (
            path.startswith(settings.API_V1_STR)
            and not path.startswith(f"{settings.API_V1_STR}/audit")
            and response.status_code < 400
            and not getattr(request.state, "audit_logged", False)
        ):
            try:
                auth_header = request.headers.get("authorization")
                user_id = None
                username = "System"
                if auth_header and auth_header.startswith("Bearer "):
                    token = auth_header.split(" ")[1]
                    payload = verify_token(token)
                    if payload:
                        user_id = int(payload.get("sub")) if payload.get("sub") else None
                        username = payload.get("username") or "User"

                fy = request.query_params.get("fy", "2026_2027")
                schema = f"fy_{fy}"

                # Infer module from path
                rel_path = path.replace(settings.API_V1_STR, "")
                parts = [p for p in rel_path.split("/") if p]
                module_raw = parts[0] if parts else "System"
                module_map = {
                    "company": "Company/Settings",
                    "sequences": "DocumentNumbering/Settings",
                    "ledgers": "Ledgers",
                    "vouchers": "Vouchers",
                    "stock": "Stock",
                    "labour-bills": "LabourBills",
                    "payroll": "Payroll",
                    "contractor": "Contractor",
                    "biometrics": "Biometrics",
                    "backups": "Backups",
                    "financial-years": "FinancialYears",
                    "auth": "Auth",
                    "products": "Products",
                }
                module = module_map.get(module_raw.lower(), module_raw.capitalize())
                action_map = {"POST": "CREATE", "PUT": "UPDATE", "DELETE": "DELETE", "PATCH": "UPDATE"}
                action = action_map.get(request.method, request.method)
                ip_address = request.client.host if request.client else None

                async with AsyncSessionLocal() as session:
                    await session.execute(
                        text(
                            f"INSERT INTO {schema}.audit_logs (user_id, username, action, module, ip_address) "
                            f"VALUES (:uid, :uname, :action, :mod, :ip)"
                        ),
                        {
                            "uid": user_id,
                            "uname": username,
                            "action": action,
                            "mod": module,
                            "ip": ip_address,
                        }
                    )
                    await session.commit()
            except Exception as e:
                print(f"[AUDIT MIDDLEWARE ERROR] Failed to log audit event: {e}")

    return response


# Mount all routers
app.include_router(auth.router, prefix=f"{settings.API_V1_STR}/auth", tags=["Authentication"])
app.include_router(company.router, prefix=f"{settings.API_V1_STR}/company", tags=["Company"])
app.include_router(ledgers.router, prefix=f"{settings.API_V1_STR}/ledgers", tags=["Ledgers"])
app.include_router(products.router, prefix=f"{settings.API_V1_STR}/products", tags=["Products"])
app.include_router(vouchers.router, prefix=f"{settings.API_V1_STR}/vouchers", tags=["Vouchers"])
app.include_router(stock.router, prefix=f"{settings.API_V1_STR}/stock", tags=["Stock"])
app.include_router(labour_bill.router, prefix=f"{settings.API_V1_STR}/labour-bills", tags=["Labour Bills"])
app.include_router(salary.router, prefix=f"{settings.API_V1_STR}/payroll", tags=["Payroll"])
app.include_router(contractor.router, prefix=f"{settings.API_V1_STR}/contractor", tags=["Contractor"])
app.include_router(reports.router, prefix=f"{settings.API_V1_STR}/reports", tags=["Reports"])
app.include_router(biometrics.router, prefix=f"{settings.API_V1_STR}/biometrics", tags=["Biometrics"])
app.include_router(backups.router, prefix=f"{settings.API_V1_STR}/backups", tags=["Backups"])
app.include_router(audit.router, prefix=f"{settings.API_V1_STR}/audit", tags=["Audit"])
app.include_router(financial_years.router, prefix=f"{settings.API_V1_STR}/financial-years", tags=["Financial Years"])
app.include_router(sequences.router, prefix=f"{settings.API_V1_STR}/sequences", tags=["Sequences"])


@app.get("/")
def root():
    return {
        "message": "OrbX Nexus ERP API",
        "version": "2.0.0",
        "docs": f"{settings.API_V1_STR}/docs",
    }


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
