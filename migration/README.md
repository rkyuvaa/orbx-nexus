# OrbX Nexus — Legacy Access Data Migration ETL

This directory contains the production-grade ETL script designed to migrate historical and transactional data from the legacy MS Access desktop database files (`.Mdb`) into the new PostgreSQL schema-per-year structure of OrbX Nexus ERP.

## Prerequisites

To run the migration script, you must have the following dependencies installed on the host machine:

1. **Python 3.10+**
2. **Microsoft Access Database Engine** (ODBC Driver)
   - [Download link](https://www.microsoft.com/en-us/download/details.aspx?id=54920) (Install the 64-bit version matching your Python architecture).
3. **Python Libraries**:
   ```bash
   pip install pyodbc sqlalchemy psycopg
   ```

## Directory Structure & Configuration

- **Legacy Access Files**: Place the year-specific Access database files inside:
  `D:\JWMS\Data\SRI METAL\`
  - `2023-2024.Mdb`
  - `2024-2025.Mdb`
  - `2025-2026.Mdb`
  - `2026-2027.Mdb`

- **PostgreSQL Connection**: Configured in `migrate_data_v2.py`:
  `postgresql+psycopg://orbx:orbx_secret@localhost:5432/orbx_nexus`

## How it Works

The migration is executed in two major phases:

### 1. Master Data Extraction & Loading (Idempotent)
Populated from the latest year (`2026-2027.Mdb`) where the master registers are most up-to-date:
- **Company Master**: Mapped to `master.company`.
- **Units of Measure**: Mapped to `master.units_of_measure`.
- **Stock Items**: Mapped to `master.stock_items`.
- **Ledger Groups**: Mapped to `master.ledger_groups` (using a two-pass parser to cleanly resolve hierarchical parent-child relationships).
- **Ledgers**: Mapped to `master.ledgers` with appropriate `ledger_type` (`Account`, `Contractor`, `Staff`).
- **Products & Processes**: Mapped to `master.products` and `master.processes`.
- **Process Rates**: Mapped to `master.rates`.

### 2. Transaction Data Consolidating (Schema-per-Year)
Iterates over each financial year database and populates the corresponding schema:
- `2023-2024.Mdb` -> `fy_2023_2024` schema
- `2024-2025.Mdb` -> `fy_2024_2025` schema
- `2025-2026.Mdb` -> `fy_2025_2026` schema
- `2026-2027.Mdb` -> `fy_2026_2027` schema

The following transaction types are migrated:
- **Double-Entry Vouchers**: `Payment`, `Receipt`, `Contra`, `Journal`, `Purchase`.
- **Stock Inward & Outward Notes**: Tracked per product/process/contractor.
- **Contractor Labour Bills**: With GST and totals.
- **Staff Salary Vouchers**: Payroll summaries.
- **Advance Payments**: Staff and Contractor advances/receipts.
- **Contractor Job Work Entries**: Register and Payment transactions.
- **EB Readings**: Electricity meter logs.
- **Stock Transfers**: Internal item movement.

## Running the Migration

1. Ensure the PostgreSQL container is running:
   ```bash
   docker-compose up -d postgres
   ```
2. Make sure the database tables are created (run the FastAPI backend once to trigger the schema/table checks).
3. Run the migration script:
   ```bash
   python D:\OrbX Nexus\migration\migrate_data_v2.py
   ```
