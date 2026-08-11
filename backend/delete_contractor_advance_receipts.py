import sys
import os
import asyncio
from sqlalchemy import text

sys.path.insert(0, os.path.dirname(__file__))

if sys.platform == "win32":
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

from app.db.session import engine

# Contract Voucher > Advance Receipt > Advance Receipt (Contractor)
LEDGER_TYPE = "Contractor"
PAYMENT_TYPE = "Receipt"

BACKUP_DIR = os.path.join(os.path.dirname(__file__), "backups")


async def main():
    print("============================================================")
    print("  Delete Contractor Advance Receipts (ledger_type=%s, payment_type=%s)" % (LEDGER_TYPE, PAYMENT_TYPE))
    print("============================================================")

    async with engine.begin() as conn:
        res = await conn.execute(text(
            "SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE 'fy_%' ORDER BY schema_name"
        ))
        schemas = [r[0] for r in res.fetchall()]

        if not schemas:
            print("No financial year schemas found. Nothing to do.")
            return

        os.makedirs(BACKUP_DIR, exist_ok=True)
        backup_path = os.path.join(BACKUP_DIR, "contractor_advance_receipts_before_clear.sql")

        total = 0
        with open(backup_path, "w", encoding="utf-8") as bf:
            for s in schemas:
                count_res = await conn.execute(text(
                    f"SELECT COUNT(*) FROM {s}.advance_payments "
                    f"WHERE ledger_type = :lt AND payment_type = :pt"
                ), {"lt": LEDGER_TYPE, "pt": PAYMENT_TYPE})
                count = count_res.scalar()
                if count == 0:
                    print(f"      - {s}: 0 records")
                    continue
                total += count
                print(f"      - {s}: {count} records")

                dump = await conn.execute(text(
                    f"SELECT * FROM {s}.advance_payments "
                    f"WHERE ledger_type = :lt AND payment_type = :pt"
                ), {"lt": LEDGER_TYPE, "pt": PAYMENT_TYPE})
                rows = dump.mappings().all()
                cols = list(rows[0].keys()) if rows else []
                if rows:
                    bf.write(f"-- Schema {s}: {len(rows)} records\n")
                    bf.write(f"INSERT INTO {s}.advance_payments ({', '.join(cols)}) VALUES\n")
                    values = []
                    for r in rows:
                        vals = []
                        for c in cols:
                            v = r[c]
                            if v is None:
                                vals.append("NULL")
                            elif isinstance(v, (int, float)):
                                vals.append(str(v))
                            else:
                                vals.append("'" + str(v).replace("'", "''") + "'")
                        values.append("(" + ", ".join(vals) + ")")
                    bf.write(",\n".join(values) + ";\n\n")

        print(f"\nTotal records to delete: {total} (in {len(schemas)} schemas)")
        if total == 0:
            print("Nothing to delete.")
            return

        backup_path = os.path.abspath(backup_path)
        print(f"Backup written to: {backup_path}")
        confirm = input(f"\nType 'DELETE' to permanently delete these {total} records: ").strip()
        if confirm != "DELETE":
            print("Aborted. No records deleted.")
            return

        for s in schemas:
            await conn.execute(text(
                f"DELETE FROM {s}.advance_payments WHERE ledger_type = :lt AND payment_type = :pt"
            ), {"lt": LEDGER_TYPE, "pt": PAYMENT_TYPE})

    print("\n[SUCCESS] Contractor Advance Receipts deleted.")

    async with engine.begin() as conn:
        res = await conn.execute(text(
            "SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE 'fy_%' ORDER BY schema_name"
        ))
        for s in [r[0] for r in res.fetchall()]:
            c = (await conn.execute(text(
                f"SELECT COUNT(*) FROM {s}.advance_payments WHERE ledger_type = :lt AND payment_type = :pt"
            ), {"lt": LEDGER_TYPE, "pt": PAYMENT_TYPE})).scalar()
            print(f"      - {s}: {c} records remaining")


if __name__ == "__main__":
    asyncio.run(main())
