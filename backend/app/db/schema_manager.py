"""
Financial Year Schema Manager.

Each financial year gets its own PostgreSQL schema (e.g., fy_2023_2024).
Master/shared data lives in the 'master' schema.
This module handles schema creation and the transaction table DDL.
"""
from sqlalchemy.ext.asyncio import AsyncEngine
from sqlalchemy import text


TRANSACTION_TABLES_DDL = """
CREATE TABLE IF NOT EXISTS {schema}.vouchers (
    id SERIAL PRIMARY KEY,
    voucher_no VARCHAR(50) UNIQUE NOT NULL,
    voucher_type VARCHAR(30) NOT NULL,  -- Payment, Receipt, Contra, Journal, Purchase
    voucher_date DATE NOT NULL,
    ledger_id INTEGER NOT NULL,
    amount NUMERIC(15,2) NOT NULL DEFAULT 0,
    narration TEXT,
    ref_no VARCHAR(100),
    created_by INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS {schema}.voucher_lines (
    id SERIAL PRIMARY KEY,
    voucher_id INTEGER NOT NULL REFERENCES {schema}.vouchers(id) ON DELETE CASCADE,
    ledger_id INTEGER NOT NULL,
    dr_amount NUMERIC(15,2) DEFAULT 0,
    cr_amount NUMERIC(15,2) DEFAULT 0,
    narration TEXT
);

CREATE TABLE IF NOT EXISTS {schema}.stock_inward (
    id SERIAL PRIMARY KEY,
    inward_no VARCHAR(50) UNIQUE NOT NULL,
    inward_date DATE NOT NULL,
    product_id INTEGER,
    process_id VARCHAR(100),
    ledger_id INTEGER NOT NULL,
    quantity NUMERIC(15,3) DEFAULT 0,
    rate NUMERIC(15,2) DEFAULT 0,
    amount NUMERIC(15,2) DEFAULT 0,
    uom_id INTEGER,
    narration TEXT,
    serial_no VARCHAR(100),
    ref_no VARCHAR(100),
    ref_date DATE,
    expected_duration_days INTEGER,
    weight NUMERIC(15,3) DEFAULT 0,
    total_weight NUMERIC(15,3) DEFAULT 0,
    items JSONB DEFAULT '[]'::jsonb,
    is_completed BOOLEAN DEFAULT FALSE,
    completed_date DATE,
    created_by INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS {schema}.stock_outward (
    id SERIAL PRIMARY KEY,
    outward_no VARCHAR(50) UNIQUE NOT NULL,
    outward_date DATE NOT NULL,
    inward_id INTEGER REFERENCES {schema}.stock_inward(id),
    product_id INTEGER,
    process_id VARCHAR(100),
    ledger_id INTEGER NOT NULL,
    quantity NUMERIC(15,3) DEFAULT 0,
    rate NUMERIC(15,2) DEFAULT 0,
    amount NUMERIC(15,2) DEFAULT 0,
    weight NUMERIC(15,3) DEFAULT 0,
    total_weight NUMERIC(15,3) DEFAULT 0,
    uom_id INTEGER,
    serial_no VARCHAR(100),
    ref_no VARCHAR(100),
    narration TEXT,
    items JSONB DEFAULT '[]'::jsonb,
    inward_ids JSONB DEFAULT '[]'::jsonb,
    dispatch_through VARCHAR(255),
    created_by INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS {schema}.stock_transfer (
    id SERIAL PRIMARY KEY,
    transfer_no VARCHAR(50) UNIQUE NOT NULL,
    transfer_date DATE NOT NULL,
    from_stock_item_id INTEGER NOT NULL,
    to_stock_item_id INTEGER NOT NULL,
    quantity NUMERIC(15,3) DEFAULT 0,
    narration TEXT,
    created_by INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS {schema}.stock_adjustments (
    id SERIAL PRIMARY KEY,
    adjustment_no VARCHAR(50) UNIQUE NOT NULL,
    adjustment_date DATE NOT NULL,
    product_id INTEGER NOT NULL,
    quantity NUMERIC(15,3) NOT NULL,
    reason TEXT,
    created_by INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS {schema}.stock_item_movements (
    id SERIAL PRIMARY KEY,
    movement_no   VARCHAR(50) UNIQUE NOT NULL,
    movement_date DATE NOT NULL,
    movement_type VARCHAR(15) NOT NULL,  -- 'Inward', 'Outward', 'Transfer', 'Consumption'
    stock_item_id INTEGER NOT NULL,
    ledger_id     INTEGER,
    quantity      NUMERIC(15,3) DEFAULT 0,
    rate          NUMERIC(15,2) DEFAULT 0,
    amount        NUMERIC(15,2) DEFAULT 0,
    uom_id        INTEGER,
    ref_no        VARCHAR(100),
    narration     TEXT,
    items         JSONB DEFAULT '[]'::jsonb,
    location_id   INTEGER,
    to_location_id INTEGER,
    created_by    INTEGER,
    created_at    TIMESTAMP DEFAULT NOW(),
    updated_at    TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS {schema}.labour_bills (
    id SERIAL PRIMARY KEY,
    bill_no VARCHAR(50) UNIQUE NOT NULL,
    bill_date DATE NOT NULL,
    ledger_id INTEGER NOT NULL,
    inward_id INTEGER,
    product_id INTEGER,
    process_id INTEGER,
    quantity NUMERIC(15,3) DEFAULT 0,
    rate NUMERIC(15,2) DEFAULT 0,
    amount NUMERIC(15,2) DEFAULT 0,
    gst_percent NUMERIC(5,2) DEFAULT 0,
    gst_amount NUMERIC(15,2) DEFAULT 0,
    cgst_percent NUMERIC(5,2) DEFAULT 0,
    cgst_amount NUMERIC(15,2) DEFAULT 0,
    sgst_percent NUMERIC(5,2) DEFAULT 0,
    sgst_amount NUMERIC(15,2) DEFAULT 0,
    round_off NUMERIC(15,2) DEFAULT 0,
    net_amount NUMERIC(15,2) DEFAULT 0,
    total_amount NUMERIC(15,2) DEFAULT 0,
    narration TEXT,
    is_paid BOOLEAN DEFAULT FALSE,
    payment_date DATE,
    freight_items JSONB DEFAULT '[]'::jsonb,
    created_by INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS {schema}.salary_vouchers (
    id SERIAL PRIMARY KEY,
    voucher_no VARCHAR(50) UNIQUE NOT NULL,
    voucher_date DATE NOT NULL,
    ledger_id INTEGER NOT NULL,
    month INTEGER NOT NULL,
    year INTEGER NOT NULL,
    days_worked NUMERIC(5,1) DEFAULT 0,
    basic_salary NUMERIC(15,2) DEFAULT 0,
    allowances NUMERIC(15,2) DEFAULT 0,
    deductions NUMERIC(15,2) DEFAULT 0,
    net_salary NUMERIC(15,2) DEFAULT 0,
    narration TEXT,
    created_by INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS {schema}.advance_payments (
    id SERIAL PRIMARY KEY,
    voucher_no VARCHAR(50) UNIQUE NOT NULL,
    voucher_date DATE NOT NULL,
    ledger_id INTEGER NOT NULL,
    payment_type VARCHAR(20) NOT NULL,  -- Payment, Receipt
    ledger_type VARCHAR(20) NOT NULL,  -- Staff, Contractor
    amount NUMERIC(15,2) DEFAULT 0,
    narration TEXT,
    created_by INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS {schema}.job_work_entries (
    id SERIAL PRIMARY KEY,
    entry_no VARCHAR(50) UNIQUE NOT NULL,
    entry_date DATE NOT NULL,
    ledger_id INTEGER NOT NULL,
    product_id INTEGER,
    process_id INTEGER,
    rate_id INTEGER,
    quantity NUMERIC(15,3) DEFAULT 0,
    rate NUMERIC(15,2) DEFAULT 0,
    amount NUMERIC(15,2) DEFAULT 0,
    entry_type VARCHAR(20) NOT NULL,  -- Register, Payment
    narration TEXT,
    is_paid BOOLEAN DEFAULT FALSE,
    register_ids JSONB DEFAULT '[]'::jsonb,
    created_by INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS {schema}.biometric_entries (
    id SERIAL PRIMARY KEY,
    ledger_id INTEGER NOT NULL,
    entry_date DATE NOT NULL,
    punch_in TIME,
    punch_out TIME,
    hours_worked NUMERIC(5,2),
    status VARCHAR(20) DEFAULT 'Present',  -- Present, Absent, Half Day, Holiday
    device_log_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS {schema}.audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    username VARCHAR(100),
    action VARCHAR(50) NOT NULL,
    module VARCHAR(50),
    record_id INTEGER,
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_{schema_safe}_vouchers_date ON {schema}.vouchers(voucher_date);
CREATE INDEX IF NOT EXISTS idx_{schema_safe}_vouchers_type ON {schema}.vouchers(voucher_type);
CREATE INDEX IF NOT EXISTS idx_{schema_safe}_inward_date ON {schema}.stock_inward(inward_date);
CREATE INDEX IF NOT EXISTS idx_{schema_safe}_outward_date ON {schema}.stock_outward(outward_date);
CREATE INDEX IF NOT EXISTS idx_{schema_safe}_labour_date ON {schema}.labour_bills(bill_date);
CREATE INDEX IF NOT EXISTS idx_{schema_safe}_audit_date ON {schema}.audit_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_{schema_safe}_vouchers_ledger ON {schema}.vouchers(ledger_id);
CREATE INDEX IF NOT EXISTS idx_{schema_safe}_voucher_lines_voucher ON {schema}.voucher_lines(voucher_id);
CREATE INDEX IF NOT EXISTS idx_{schema_safe}_voucher_lines_ledger ON {schema}.voucher_lines(ledger_id);
CREATE INDEX IF NOT EXISTS idx_{schema_safe}_inward_ledger ON {schema}.stock_inward(ledger_id);
CREATE INDEX IF NOT EXISTS idx_{schema_safe}_outward_ledger ON {schema}.stock_outward(ledger_id);
CREATE INDEX IF NOT EXISTS idx_{schema_safe}_labour_ledger ON {schema}.labour_bills(ledger_id);
CREATE INDEX IF NOT EXISTS idx_{schema_safe}_job_work_ledger ON {schema}.job_work_entries(ledger_id);
CREATE INDEX IF NOT EXISTS idx_{schema_safe}_biometric_ledger ON {schema}.biometric_entries(ledger_id);
"""


async def ensure_master_schema(engine: AsyncEngine):
    """Create master schema if it doesn't exist."""
    async with engine.begin() as conn:
        await conn.execute(text("CREATE SCHEMA IF NOT EXISTS master"))
        await conn.execute(text("ALTER TABLE master.processes ADD COLUMN IF NOT EXISTS gst_percent NUMERIC(5,2) DEFAULT 0.0"))
        await conn.execute(text("ALTER TABLE master.processes ADD COLUMN IF NOT EXISTS process_ids VARCHAR(200)"))
        await conn.commit()


async def ensure_year_schema(year_str: str, engine: AsyncEngine):
    """
    Create a financial year schema and all transaction tables within it.
    year_str format: '2026_2027' -> schema: 'fy_2026_2027'
    """
    schema = f"fy_{year_str}"
    schema_safe = schema.replace("-", "_")

    async with engine.begin() as conn:
        # Create schema
        await conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {schema}"))

        # Create all transaction tables
        ddl = TRANSACTION_TABLES_DDL.format(
            schema=schema,
            schema_safe=schema_safe,
        )
        await conn.execute(text(ddl))

        # Ensure alter statements for new inward voucher columns
        alter_ddl = f"""
        ALTER TABLE {schema}.stock_inward ADD COLUMN IF NOT EXISTS serial_no VARCHAR(100);
        ALTER TABLE {schema}.stock_inward ADD COLUMN IF NOT EXISTS ref_no VARCHAR(100);
        ALTER TABLE {schema}.stock_inward ADD COLUMN IF NOT EXISTS ref_date DATE;
        ALTER TABLE {schema}.stock_inward ADD COLUMN IF NOT EXISTS expected_duration_days INTEGER;
        ALTER TABLE {schema}.stock_inward ADD COLUMN IF NOT EXISTS weight NUMERIC(15,3) DEFAULT 0;
        ALTER TABLE {schema}.stock_inward ADD COLUMN IF NOT EXISTS total_weight NUMERIC(15,3) DEFAULT 0;
        ALTER TABLE {schema}.stock_inward ADD COLUMN IF NOT EXISTS items JSONB DEFAULT '[]'::jsonb;
        ALTER TABLE {schema}.stock_inward ALTER COLUMN process_id TYPE VARCHAR(100) USING process_id::varchar;
        ALTER TABLE {schema}.stock_outward ALTER COLUMN process_id TYPE VARCHAR(100) USING process_id::varchar;
        ALTER TABLE {schema}.stock_inward ALTER COLUMN product_id DROP NOT NULL;
        ALTER TABLE {schema}.stock_outward ALTER COLUMN product_id DROP NOT NULL;
        ALTER TABLE {schema}.stock_outward ADD COLUMN IF NOT EXISTS weight NUMERIC(15,3) DEFAULT 0;
        ALTER TABLE {schema}.stock_outward ADD COLUMN IF NOT EXISTS total_weight NUMERIC(15,3) DEFAULT 0;
        ALTER TABLE {schema}.stock_outward ADD COLUMN IF NOT EXISTS serial_no VARCHAR(100);
        ALTER TABLE {schema}.stock_outward ADD COLUMN IF NOT EXISTS ref_no VARCHAR(100);
        ALTER TABLE {schema}.stock_outward ADD COLUMN IF NOT EXISTS items JSONB DEFAULT '[]'::jsonb;
        ALTER TABLE {schema}.stock_outward ADD COLUMN IF NOT EXISTS dispatch_through VARCHAR(255);
        ALTER TABLE {schema}.stock_outward ADD COLUMN IF NOT EXISTS inward_ids JSONB DEFAULT '[]'::jsonb;
        ALTER TABLE {schema}.labour_bills ADD COLUMN IF NOT EXISTS cgst_percent NUMERIC(5,2) DEFAULT 0;
        ALTER TABLE {schema}.labour_bills ADD COLUMN IF NOT EXISTS cgst_amount NUMERIC(15,2) DEFAULT 0;
        ALTER TABLE {schema}.labour_bills ADD COLUMN IF NOT EXISTS sgst_percent NUMERIC(5,2) DEFAULT 0;
        ALTER TABLE {schema}.labour_bills ADD COLUMN IF NOT EXISTS sgst_amount NUMERIC(15,2) DEFAULT 0;
        ALTER TABLE {schema}.labour_bills ADD COLUMN IF NOT EXISTS round_off NUMERIC(15,2) DEFAULT 0;
        ALTER TABLE {schema}.labour_bills ADD COLUMN IF NOT EXISTS net_amount NUMERIC(15,2) DEFAULT 0;
        ALTER TABLE {schema}.labour_bills ADD COLUMN IF NOT EXISTS freight_items JSONB DEFAULT '[]'::jsonb;
        ALTER TABLE {schema}.stock_item_movements ALTER COLUMN movement_type TYPE VARCHAR(15);
        ALTER TABLE {schema}.stock_item_movements ADD COLUMN IF NOT EXISTS location_id INTEGER;
        ALTER TABLE {schema}.stock_item_movements ADD COLUMN IF NOT EXISTS to_location_id INTEGER;
        CREATE TABLE IF NOT EXISTS {schema}.stock_adjustments (
            id SERIAL PRIMARY KEY,
            adjustment_no VARCHAR(50) UNIQUE NOT NULL,
            adjustment_date DATE NOT NULL,
            product_id INTEGER NOT NULL,
            quantity NUMERIC(15,3) NOT NULL,
            reason TEXT,
            created_by INTEGER,
            created_at TIMESTAMP DEFAULT NOW()
        );
        CREATE TABLE IF NOT EXISTS {schema}.stock_item_movements (
            id SERIAL PRIMARY KEY,
            movement_no   VARCHAR(50) UNIQUE NOT NULL,
            movement_date DATE NOT NULL,
            movement_type VARCHAR(15) NOT NULL,
            stock_item_id INTEGER NOT NULL,
            ledger_id     INTEGER,
            quantity      NUMERIC(15,3) DEFAULT 0,
            rate          NUMERIC(15,2) DEFAULT 0,
            amount        NUMERIC(15,2) DEFAULT 0,
            uom_id        INTEGER,
            ref_no        VARCHAR(100),
            narration     TEXT,
            location_id   INTEGER,
            to_location_id INTEGER,
            created_by    INTEGER,
            created_at    TIMESTAMP DEFAULT NOW(),
            updated_at    TIMESTAMP DEFAULT NOW()
        );
        """
        await conn.execute(text(alter_ddl))
        await conn.commit()

    return schema


async def get_year_schemas(engine: AsyncEngine) -> list[str]:
    """Return list of all financial year schemas."""
    async with engine.begin() as conn:
        result = await conn.execute(
            text(
                "SELECT schema_name FROM information_schema.schemata "
                "WHERE schema_name LIKE 'fy_%' ORDER BY schema_name"
            )
        )
        return [row[0] for row in result.fetchall()]


def parse_year_schema(fy: str) -> str:
    """Convert '2026_2027' -> 'fy_2026_2027'"""
    return f"fy_{fy}"
