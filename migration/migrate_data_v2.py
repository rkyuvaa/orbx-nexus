import os
import sys
import json
import argparse
from datetime import datetime, date
from decimal import Decimal
from sqlalchemy import create_engine, text

try:
    import pyodbc
except ImportError:
    pyodbc = None

PG_URL = os.getenv("DATABASE_URL", "postgresql+psycopg://orbx:orbx_secret@localhost:5432/orbx_nexus")
MDB_PASSWORD = "gks0990gtn"
MDB_DIR = "d:/JWMS/Data/SRI METAL"

MDB_FILES = {
    "2023_2024": "2023-2024.Mdb",
    "2024_2025": "2024-2025.Mdb",
    "2025_2026": "2025-2026.Mdb",
    "2026_2027": "2026-2027.Mdb"
}

def clean_date(val):
    if val is None:
        return None
    if isinstance(val, str):
        try:
            return datetime.strptime(val, "%Y-%m-%d %H:%M:%S")
        except ValueError:
            try:
                return datetime.fromisoformat(val)
            except ValueError:
                return None
    return val

def clean_bool(val):
    if val is None:
        return False
    if isinstance(val, bool):
        return val
    if isinstance(val, int):
        return val != 0
    return str(val).lower() in ("true", "1", "yes")

def clean_num(val):
    return float(val) if val is not None else 0.0

def get_case_insensitive(d, key):
    key_lower = key.lower()
    for k, v in d.items():
        if k.lower() == key_lower:
            return v
    return None

class MockCursor:
    def __init__(self, data_store, current_year=None):
        self.data_store = data_store
        self.current_year = current_year
        self.results = []
        self.index = 0

    def execute(self, query, params=None):
        query_upper = query.upper()
        table_name = None
        for tbl in [
            "TBLCOMPANYMASTER", "TBLUNITMASTER", "TBLSTOCKITEM", "TBLACCOUNTSGROUP", 
            "TBLACCOUNTSLEDGER", "TBLCONTRACTORLEDGER", "TBLSTAFFLEDGER", 
            "TBLPRODUCTREGISTER", "TBLRATEREGISTER", "TBLCOMPANYVOUCHER", 
            "TBLVOUCHEROPERATIONS", "TBLPROCESSVOUCHER", "TBLPROCESSOPERATION", 
            "TBLLABOURBILL", "TBLSTAFFSALARYVOUCHER", "TBLADVANCEREGISTER", 
            "TBLJOBWORKREGISTER", "TBLJOBWORKOPERATION", "TBLEBREADING", "TBLSTOCKTRANSFER"
        ]:
            if tbl in query_upper:
                table_name = tbl
                break
        
        if not table_name:
            raise ValueError(f"Table name not found in query: {query}")
            
        rows = []
        if table_name in [
            "TBLCOMPANYMASTER", "TBLUNITMASTER", "TBLSTOCKITEM", "TBLACCOUNTSGROUP", 
            "TBLACCOUNTSLEDGER", "TBLCONTRACTORLEDGER", "TBLSTAFFLEDGER", 
            "TBLPRODUCTREGISTER", "TBLRATEREGISTER"
        ]:
            rows = get_case_insensitive(self.data_store.get("master", {}), table_name) or []
        else:
            year_key = self.current_year.replace("_", "-") if self.current_year else None
            year_data = get_case_insensitive(self.data_store.get("years", {}), year_key or "") or \
                        get_case_insensitive(self.data_store.get("years", {}), self.current_year or "")
            if year_data:
                rows = get_case_insensitive(year_data, table_name) or []

        if table_name == "TBLACCOUNTSLEDGER":
            if "ACLLEDGERTYPE <> 'PROCESS'" in query_upper:
                rows = [r for r in rows if r.get("aclLedgerType") != "Process"]
            elif "ACLLEDGERTYPE = 'PROCESS'" in query_upper:
                rows = [r for r in rows if r.get("aclLedgerType") == "Process"]

        if table_name == "TBLCOMPANYVOUCHER" and "CMVVOUCHERTYPECODE IN" in query_upper:
            rows = [r for r in rows if r.get("cmvVoucherTypeCode") in (2, 3, 4, 5, 17)]

        if table_name == "TBLVOUCHEROPERATIONS" and "VOUOVOUCHERTYPECODE IN" in query_upper:
            rows = [r for r in rows if r.get("vouoVoucherTypeCode") in (2, 3, 4, 5, 17)]

        if table_name == "TBLPROCESSVOUCHER" and "PRVVOUCHERTYPECODE = 6" in query_upper:
            rows = [r for r in rows if r.get("prvVoucherTypeCode") == 6]
        elif table_name == "TBLPROCESSVOUCHER" and "PRVVOUCHERTYPECODE = 7" in query_upper:
            rows = [r for r in rows if r.get("prvVoucherTypeCode") == 7]

        if "SUM(VOUOAMOUNT)" in query_upper:
            v_code = params[0]
            total_sum = sum(clean_num(r.get("vouoAmount")) for r in rows if r.get("vouoVoucherCode") == v_code)
            self.results = [(total_sum,)]
            self.index = 0
            return

        if params:
            v_code = params[0]
            if "PROVOUCHERCODE = ?" in query_upper:
                rows = [r for r in rows if r.get("proVoucherCode") == v_code]
            elif "VOUOVOUCHERCODE = ?" in query_upper:
                rows = [r for r in rows if r.get("vouoVoucherCode") == v_code]
            elif "LBRVOUCHERCODE = ?" in query_upper:
                rows = [r for r in rows if r.get("lbrVoucherCode") == v_code]
            elif "SSVVOUCHERCODE = ?" in query_upper:
                rows = [r for r in rows if r.get("ssvVoucherCode") == v_code]
            elif "ADVVOUCHERCODE = ?" in query_upper:
                rows = [r for r in rows if r.get("advVoucherCode") == v_code]
            elif "JOWVOUCHERCODE = ?" in query_upper:
                rows = [r for r in rows if r.get("jowVoucherCode") == v_code]
            elif "JWOPVOUCHERCODE = ?" in query_upper:
                rows = [r for r in rows if r.get("jwopVoucherCode") == v_code]
            elif "JWOVOUCHERCODE = ?" in query_upper:
                rows = [r for r in rows if r.get("jwoVoucherCode") == v_code]
            elif "STTVOUCHERCODE = ?" in query_upper:
                rows = [r for r in rows if r.get("sttVoucherCode") == v_code]
            elif "STIVOUCHERCODE = ?" in query_upper:
                rows = [r for r in rows if r.get("stiVoucherCode") == v_code]

        select_part = query.split("FROM")[0].replace("SELECT", "").strip()
        select_fields = [f.strip().split(".")[-1] for f in select_part.split(",")]
        select_fields = [f for f in select_fields if f and f != "*"]

        self.results = []
        for r in rows:
            row_tuple = tuple(get_case_insensitive(r, field) for field in select_fields)
            self.results.append(row_tuple)
        self.index = 0

    def fetchall(self):
        return self.results

    def fetchone(self):
        if self.index < len(self.results):
            res = self.results[self.index]
            self.index += 1
            return res
        return None

    def close(self):
        pass

class MockMdbConn:
    def __init__(self, data_store, current_year=None):
        self.data_store = data_store
        self.current_year = current_year

    def cursor(self):
        return MockCursor(self.data_store, self.current_year)

    def close(self):
        pass

def serialize_value(val):
    if isinstance(val, (datetime, date)):
        return val.isoformat()
    if isinstance(val, Decimal):
        return float(val)
    return val

def export_table(cursor, table_name):
    try:
        cursor.execute(f"SELECT * FROM {table_name}")
        cols = [column[0] for column in cursor.description]
        rows = cursor.fetchall()
        result = []
        for row in rows:
            row_dict = {}
            for i, val in enumerate(row):
                row_dict[cols[i]] = serialize_value(val)
            result.append(row_dict)
        return result
    except Exception as e:
        print(f"    Warning: Could not export {table_name}: {e}")
        return []

def run_export(export_path):
    if not pyodbc:
        print("ERROR: pyodbc is not installed on this machine, which is required for export.")
        sys.exit(1)

    drivers = [x for x in pyodbc.drivers() if "Access" in x]
    if not drivers:
        print("ERROR: Microsoft Access ODBC Driver not found on this machine.")
        sys.exit(1)
    driver = drivers[0]
    print(f"Using ODBC Driver: {driver}")

    dump_data = {
        "master": {},
        "years": {}
    }

    # 1. Export Master Tables
    latest_year = "2026_2027"
    latest_path = os.path.join(MDB_DIR, MDB_FILES[latest_year])
    if not os.path.exists(latest_path):
        print(f"ERROR: Latest year MDB file not found at {latest_path}")
        sys.exit(1)

    print(f"\n--- Exporting Master Data from {latest_path} ---")
    conn_str = f"Driver={{{driver}}};DBQ={latest_path};PWD={MDB_PASSWORD};"
    mdb_conn = pyodbc.connect(conn_str)
    cursor = mdb_conn.cursor()

    master_tables = [
        "tblCompanyMaster", "tblUnitMaster", "tblStockItem", "tblAccountsGroup",
        "tblAccountsLedger", "tblContractorLedger", "tblStaffLedger",
        "tblProductRegister", "tblRateRegister"
    ]
    for table in master_tables:
        print(f"  Exporting table: {table}...")
        dump_data["master"][table] = export_table(cursor, table)

    cursor.close()
    mdb_conn.close()

    # 2. Export Transaction Tables per Year
    for fy_key, mdb_filename in MDB_FILES.items():
        mdb_path = os.path.join(MDB_DIR, mdb_filename)
        if not os.path.exists(mdb_path):
            print(f"Skipping {fy_key} (file {mdb_filename} not found).")
            continue

        print(f"\n--- Exporting {fy_key} from {mdb_path} ---")
        conn_str = f"Driver={{{driver}}};DBQ={mdb_path};PWD={MDB_PASSWORD};"
        mdb_conn = pyodbc.connect(conn_str)
        cursor = mdb_conn.cursor()

        dump_data["years"][fy_key] = {}
        transaction_tables = [
            "tblCompanyVoucher", "tblVoucherOperations", "tblProcessVoucher",
            "tblProcessOperation", "tblJobworkOperation", "tblEBReading", "tblStockTransfer"
        ]
        for table in transaction_tables:
            print(f"  Exporting table: {table}...")
            dump_data["years"][fy_key][table] = export_table(cursor, table)

        cursor.close()
        mdb_conn.close()

    print(f"\nWriting exported data to: {export_path}")
    with open(export_path, "w", encoding="utf-8") as f:
        json.dump(dump_data, f, ensure_ascii=False, indent=2)
    print("Export completed successfully!")

def migrate(json_store=None):
    engine = create_engine(PG_URL)
    print("Connected to PostgreSQL database successfully.")
    
    if json_store is not None:
        print("Using JSON data store for legacy Access data.")
        latest_year = "2026_2027"
        mdb_conn = MockMdbConn(json_store, current_year=latest_year)
        cursor = mdb_conn.cursor()
    else:
        if not pyodbc:
            print("ERROR: pyodbc is not installed and no JSON import file was specified.")
            return
        drivers = [x for x in pyodbc.drivers() if "Access" in x]
        if not drivers:
            print("ERROR: Microsoft Access ODBC Driver not found on this machine.")
            return
        driver = drivers[0]
        print(f"Using ODBC Driver: {driver}")
        
        latest_year = "2026_2027"
        latest_path = os.path.join(MDB_DIR, MDB_FILES[latest_year])
        print(f"\n--- Loading Master Data from {latest_path} ---")
        
        conn_str = f"Driver={{{driver}}};DBQ={latest_path};PWD={MDB_PASSWORD};"
        mdb_conn = pyodbc.connect(conn_str)
        cursor = mdb_conn.cursor()
    
    # Truncate all master tables
    with engine.begin() as conn:
        print("Truncating master tables...")
        conn.execute(text("TRUNCATE master.rates, master.processes, master.products, master.stock_items, master.ledgers, master.ledger_groups, master.units_of_measure, master.company CASCADE;"))
    
    uom_map = {}
    stock_item_map = {}
    group_map = {}
    ledger_map = {}
    product_map = {}
    process_map = {}
    
    # A. Company Info
    print("Migrating company info...")
    try:
        cursor.execute("SELECT comCompanyName, comStreetCompany, comAreaCompany, comCityCompany, comStateCompany, comPINCode, comPhoneNo, comMobileNoOne, comEMailID FROM tblCompanyMaster")
        comp = cursor.fetchone()
        if comp:
            address = f"{comp[1] or ''} {comp[2] or ''}".strip()
            with engine.begin() as conn:
                conn.execute(text("""
                    INSERT INTO master.company (id, name, address, city, state, pincode, phone, mobile, email, financial_year_start_month)
                    VALUES (1, :name, :address, :city, :state, :pin, :phone, :mobile, :email, 4)
                """), {
                    "name": comp[0], "address": address, "city": comp[3], "state": comp[4], "pin": comp[5],
                    "phone": comp[6] or "", "mobile": comp[7] or "", "email": comp[8] or ""
                })
            print("  Company loaded successfully.")
    except Exception as e:
        print(f"  Error migrating company: {e}")
        
    # B. Units of Measure
    print("Migrating units of measure...")
    try:
        cursor.execute("SELECT uomUnitCode, uomUnitSymbol, uomFormalName FROM tblUnitMaster")
        with engine.begin() as conn:
            for row in cursor.fetchall():
                old_id, symbol, name = row
                res = conn.execute(text("""
                    INSERT INTO master.units_of_measure (name, symbol)
                    VALUES (:name, :symbol) RETURNING id
                """), {"name": name or symbol, "symbol": symbol})
                new_id = res.fetchone()[0]
                uom_map[old_id] = new_id
        print(f"  Units of measure loaded ({len(uom_map)} rows).")
    except Exception as e:
        print(f"  Error migrating units of measure: {e}")
        
    # C. Stock Items
    print("Migrating stock items...")
    try:
        cursor.execute("SELECT stiItemCode, stiItemName, stiUnitCode, stiQuantity, stiDeleted FROM tblStockItem")
        count = 0
        with engine.begin() as conn:
            for row in cursor.fetchall():
                old_code, name, unit_code, qty, deleted = row
                res = conn.execute(text("""
                    INSERT INTO master.stock_items (name, item_code, uom_id, opening_stock, reorder_level, is_active)
                    VALUES (:name, :code, :uom_id, :qty, 0, :active) RETURNING id
                """), {
                    "name": name, "code": str(old_code), "uom_id": uom_map.get(unit_code), "qty": clean_num(qty), "active": not clean_bool(deleted)
                })
                new_id = res.fetchone()[0]
                stock_item_map[old_code] = new_id
                count += 1
        print(f"  Stock items loaded ({count} rows).")
    except Exception as e:
        print(f"  Error migrating stock items: {e}")

    # D. Ledger Groups
    print("Migrating ledger groups...")
    try:
        cursor.execute("SELECT acgGroupCode, acgGroupName, acgGroupType, acgUnderGroupCode, acgDeleted FROM tblAccountsGroup")
        groups = cursor.fetchall()
        
        legacy_under_group_map = {}
        with engine.begin() as conn:
            for row in groups:
                old_code, name, g_type, under_code, deleted = row
                gt = g_type or "Liability"
                if gt not in ("Assets", "Liability", "Income", "Expense"):
                    gt = "Liability"
                    
                res = conn.execute(text("""
                    INSERT INTO master.ledger_groups (name, group_type, is_system)
                    VALUES (:name, :type, false) RETURNING id
                """), {
                    "name": name, "type": gt
                })
                new_id = res.fetchone()[0]
                group_map[old_code] = new_id
                legacy_under_group_map[old_code] = under_code
        
        with engine.begin() as conn:
            for old_code, under_code in legacy_under_group_map.items():
                if under_code and under_code in group_map:
                    conn.execute(text("""
                        UPDATE master.ledger_groups SET parent_id = :parent_id WHERE id = :id
                    """), {
                        "parent_id": group_map[under_code], "id": group_map[old_code]
                    })
        print(f"  Ledger groups loaded ({len(group_map)} rows).")
    except Exception as e:
        print(f"  Error migrating ledger groups: {e}")

    # E. Ledgers
    print("Migrating ledgers (Accounts, Contractors, Staff)...")
    # 1. Accounts Ledgers
    try:
        cursor.execute("SELECT aclLedgerCode, aclLedgerName, aclUnderGroupCode, aclPhoneNo, aclStreet, aclArea, aclCity, aclState, aclPINCode, aclVATTIN, aclPANNumber, aclACNumber, aclNotes, aclDeleted FROM tblAccountsLedger WHERE aclLedgerType <> 'Process'")
        count = 0
        with engine.begin() as conn:
            for row in cursor.fetchall():
                old_code, name, group_code, phone, street, area, city, state, pin, vat, pan, ac_num, notes, deleted = row
                address = f"{street or ''} {area or ''}".strip()
                res = conn.execute(text("""
                    INSERT INTO master.ledgers (name, ledger_code, group_id, ledger_type, opening_balance, balance_type, phone, mobile, address, city, state, pincode, gstin, pan, bank_account_no, is_active)
                    VALUES (:name, :code, :group_id, 'Account', 0, 'Dr', :phone, :mobile, :addr, :city, :state, :pin, :gstin, :pan, :ac, :active) RETURNING id
                """), {
                    "name": name, "code": str(old_code), "group_id": group_map.get(group_code), "phone": phone or "", "mobile": phone or "", "addr": address, "city": city or "", "state": state or "", "pin": pin or "", "gstin": vat or "", "pan": pan or "", "ac": ac_num or "", "active": not clean_bool(deleted)
                })
                new_id = res.fetchone()[0]
                ledger_map[f"acc_{old_code}"] = new_id
                count += 1
        print(f"    Account ledgers loaded ({count} rows).")
    except Exception as e:
        print(f"    Error migrating account ledgers: {e}")

    # 2. Contractor Ledgers
    try:
        cursor.execute("SELECT conContractorCode, conContractorName, conMailingName, conACNumber, conStreet, conArea, conCity, conState, conPINCode, conPhoneNo, conEMailID, conNotes, conDeleted FROM tblContractorLedger")
        count = 0
        with engine.begin() as conn:
            grp_res = conn.execute(text("SELECT id FROM master.ledger_groups WHERE name LIKE '%Creditor%' OR name LIKE '%Contractor%' LIMIT 1"))
            grp_row = grp_res.fetchone()
            contractor_group_id = grp_row[0] if grp_row else (list(group_map.values())[0] if group_map else 1)

            for row in cursor.fetchall():
                old_code, name, mail, ac, street, area, city, state, pin, phone, email, notes, deleted = row
                address = f"{street or ''} {area or ''}".strip()
                res = conn.execute(text("""
                    INSERT INTO master.ledgers (name, ledger_code, group_id, ledger_type, opening_balance, balance_type, phone, mobile, address, city, state, pincode, bank_account_no, is_active)
                    VALUES (:name, :code, :group_id, 'Contractor', 0, 'Dr', :phone, :mobile, :addr, :city, :state, :pin, :ac, :active) RETURNING id
                """), {
                    "name": name, "code": f"CON_{old_code}", "group_id": contractor_group_id, "phone": phone or "", "mobile": phone or "", "addr": address, "city": city or "", "state": state or "", "pin": pin or "", "ac": ac or "", "active": not clean_bool(deleted)
                })
                new_id = res.fetchone()[0]
                ledger_map[f"con_{old_code}"] = new_id
                count += 1
        print(f"    Contractor ledgers loaded ({count} rows).")
    except Exception as e:
        print(f"    Error migrating contractor ledgers: {e}")

    # 3. Staff Ledgers
    try:
        cursor.execute("SELECT stfStaffCode, stfStaffName, stfMailingName, stfACNumber, stfStreet, stfArea, stfCity, stfState, stfPINCode, stfPhoneNo, stfEMailID, stfNotes, stfDeleted FROM tblStaffLedger")
        count = 0
        with engine.begin() as conn:
            grp_res = conn.execute(text("SELECT id FROM master.ledger_groups WHERE name LIKE '%Staff%' OR name LIKE '%Salaries%' LIMIT 1"))
            grp_row = grp_res.fetchone()
            staff_group_id = grp_row[0] if grp_row else (list(group_map.values())[0] if group_map else 1)

            for row in cursor.fetchall():
                old_code, name, mail, ac, street, area, city, state, pin, phone, email, notes, deleted = row
                address = f"{street or ''} {area or ''}".strip()
                res = conn.execute(text("""
                    INSERT INTO master.ledgers (name, ledger_code, group_id, ledger_type, opening_balance, balance_type, phone, mobile, address, city, state, pincode, bank_account_no, is_active)
                    VALUES (:name, :code, :group_id, 'Staff', 0, 'Dr', :phone, :mobile, :addr, :city, :state, :pin, :ac, :active) RETURNING id
                """), {
                    "name": name, "code": f"STF_{old_code}", "group_id": staff_group_id, "phone": phone or "", "mobile": phone or "", "addr": address, "city": city or "", "state": state or "", "pin": pin or "", "ac": ac or "", "active": not clean_bool(deleted)
                })
                new_id = res.fetchone()[0]
                ledger_map[f"stf_{old_code}"] = new_id
                count += 1
        print(f"    Staff ledgers loaded ({count} rows).")
    except Exception as e:
        print(f"    Error migrating staff ledgers: {e}")

    # F. Products
    print("Migrating products...")
    try:
        cursor.execute("SELECT prrProductCode, prrProductName, prrProductWeight, prrCompanyCode, prrDeleted FROM tblProductRegister")
        count = 0
        with engine.begin() as conn:
            for row in cursor.fetchall():
                old_code, name, weight, comp_code, deleted = row
                res = conn.execute(text("""
                    INSERT INTO master.products (name, product_code, weight, is_active)
                    VALUES (:name, :code, :weight, :active) RETURNING id
                """), {
                    "name": name, "code": str(old_code), "weight": clean_num(weight), "active": not clean_bool(deleted)
                })
                new_id = res.fetchone()[0]
                product_map[old_code] = new_id
                count += 1
        print(f"  Products loaded ({count} rows).")
    except Exception as e:
        print(f"  Error migrating products: {e}")

    # G. Processes
    print("Migrating processes...")
    try:
        cursor.execute("SELECT aclLedgerCode, aclLedgerName, aclNotes, aclDeleted FROM tblAccountsLedger WHERE aclLedgerType = 'Process'")
        count = 0
        with engine.begin() as conn:
            for row in cursor.fetchall():
                old_code, name, notes, deleted = row
                res = conn.execute(text("""
                    INSERT INTO master.processes (name, process_code, sequence, description, is_active, company_rate, contractor_rate, gst_percent)
                    VALUES (:name, :code, 0, :desc, :active, 0.0, 0.0, 0.0) RETURNING id
                """), {
                    "name": name, "code": str(old_code), "desc": notes or "", "active": not clean_bool(deleted)
                })
                new_id = res.fetchone()[0]
                process_map[old_code] = new_id
                count += 1
        print(f"  Processes loaded ({count} rows).")
    except Exception as e:
        print(f"  Error migrating processes: {e}")

    # H. Rates
    print("Migrating rates...")
    try:
        cursor.execute("SELECT rtrLedgerCode, rtrProcessCode, rtrProcessRate FROM tblRateRegister")
        count = 0
        with engine.begin() as conn:
            for row in cursor.fetchall():
                ledger_code, process_code, rate = row
                ledg_id = ledger_map.get(f"con_{ledger_code}")
                proc_id = process_map.get(process_code)
                if proc_id:
                    conn.execute(text("""
                        INSERT INTO master.rates (process_id, ledger_id, rate, is_active)
                        VALUES (:proc_id, :ledger_id, :rate, true)
                    """), {
                        "proc_id": proc_id, "ledger_id": ledg_id, "rate": clean_num(rate)
                    })
                    count += 1
        print(f"  Rates loaded ({count} rows).")
    except Exception as e:
        print(f"  Error migrating rates: {e}")

    cursor.close()
    mdb_conn.close()

    # 2. Migrate Transaction Data from all years
    print("\n--- Migrating Transaction Data (Vouchers) from all Years ---")
    
    prefix_map = {
        "Payment": "PAY",
        "Receipt": "REC",
        "Contra": "CON",
        "Journal": "JOU",
        "Purchase": "PUR"
    }

    for year, filename in MDB_FILES.items():
        schema = f"fy_{year}"
        if json_store is not None:
            print(f"\nProcessing Year Schema: {schema} from JSON store...")
            mdb_conn = MockMdbConn(json_store, current_year=year)
            cursor = mdb_conn.cursor()
        else:
            mdb_path = os.path.join(MDB_DIR, filename)
            if not os.path.exists(mdb_path):
                print(f"File not found: {mdb_path}. Skipping.")
                continue
                
            print(f"\nProcessing Year Schema: {schema} ({filename})...")
            conn_str = f"Driver={{{driver}}};DBQ={mdb_path};PWD={MDB_PASSWORD};"
            mdb_conn = pyodbc.connect(conn_str)
            cursor = mdb_conn.cursor()
        
        schema = f"fy_{year}"
        
        with engine.begin() as conn:
            conn.execute(text(f"TRUNCATE {schema}.voucher_lines, {schema}.vouchers, {schema}.stock_outward, {schema}.stock_inward, {schema}.stock_transfer, {schema}.labour_bills, {schema}.salary_vouchers, {schema}.advance_payments, {schema}.job_work_entries CASCADE;"))

        # A. Accounts Vouchers
        print("  Migrating company vouchers...")
        voucher_id_map = {}
        try:
            cursor.execute("""
                SELECT cmvVoucherCode, cmvVoucherTypeCode, cmvVoucherNo, cmvVoucherDate, cmvPartyAcCode, cmvNotes, cmvInwardNumber 
                FROM tblCompanyVoucher 
                WHERE cmvVoucherTypeCode IN (2, 3, 4, 5, 17)
            """)
            vouchers = cursor.fetchall()
            vtype_map = {2: "Payment", 3: "Receipt", 4: "Contra", 5: "Journal", 17: "Purchase"}
            
            with engine.begin() as conn:
                for row in vouchers:
                    old_code, vtype_code, v_no, v_date, party_code, notes, ref_no = row
                    vtype = vtype_map.get(vtype_code, "Payment")
                    pfx = prefix_map.get(vtype, "VOU")
                    
                    ledg_id = ledger_map.get(f"acc_{party_code}") or ledger_map.get(f"con_{party_code}") or ledger_map.get(f"stf_{party_code}")
                    if not ledg_id:
                        continue
                        
                    res = conn.execute(text(f"""
                        INSERT INTO {schema}.vouchers (voucher_no, voucher_type, voucher_date, ledger_id, amount, narration, ref_no)
                        VALUES (:v_no, :v_type, :v_date, :ledger_id, 0, :notes, :ref) RETURNING id
                    """), {
                        "v_no": f"{pfx}_{v_no}_{old_code}", "v_type": vtype, "v_date": clean_date(v_date), "ledger_id": ledg_id, "notes": notes or "", "ref": ref_no or ""
                    })
                    new_id = res.fetchone()[0]
                    voucher_id_map[old_code] = new_id
                    
            cursor.execute("""
                SELECT vouoVoucherCode, vouoLedgerCode, vouoAmountType, vouoAmount, vouoParticular 
                FROM tblVoucherOperations 
                WHERE vouoVoucherTypeCode IN (2, 3, 4, 5, 17)
            """)
            lines = cursor.fetchall()
            line_count = 0
            with engine.begin() as conn:
                for line in lines:
                    old_vcode, l_code, amt_type, amount, narration = line
                    new_vid = voucher_id_map.get(old_vcode)
                    if not new_vid:
                        continue
                    
                    l_id = ledger_map.get(f"acc_{l_code}") or ledger_map.get(f"con_{l_code}") or ledger_map.get(f"stf_{l_code}")
                    if not l_id:
                        continue
                        
                    dr = clean_num(amount) if amt_type in ("By", "Dr") else 0.0
                    cr = clean_num(amount) if amt_type in ("To", "Cr") else 0.0
                    
                    conn.execute(text(f"""
                        INSERT INTO {schema}.voucher_lines (voucher_id, ledger_id, dr_amount, cr_amount, narration)
                        VALUES (:vid, :lid, :dr, :cr, :narr)
                    """), {
                        "vid": new_vid, "lid": l_id, "dr": abs(dr), "cr": abs(cr), "narr": narration or ""
                    })
                    conn.execute(text(f"""
                        UPDATE {schema}.vouchers SET amount = amount + :amt WHERE id = :vid
                    """), {
                        "amt": abs(dr) if dr > 0 else abs(cr), "vid": new_vid
                    })
                    line_count += 1
            print(f"    Migrated {len(voucher_id_map)} vouchers, {line_count} lines.")
        except Exception as e:
            print(f"    Error migrating accounts vouchers: {e}")
            
        # B. Stock Inward (Type 6)
        print("  Migrating stock inward...")
        try:
            cursor.execute("""
                SELECT prvVoucherCode, prvVoucherNo, prvVoucherDate, prvSupplierCode, prvNotes 
                FROM tblProcessVoucher 
                WHERE prvVoucherTypeCode = 6
            """)
            inwards = cursor.fetchall()
            inward_count = 0
            with engine.begin() as conn:
                for row in inwards:
                    v_code, v_no, v_date, supplier_code, notes = row
                    
                    cursor.execute("""
                        SELECT proProductCode, proProcessCode, proQuantity, proProductWeight 
                        FROM tblProcessOperation 
                        WHERE proVoucherCode = ? AND proQtyType = 'In'
                    """, (v_code,))
                    ops = cursor.fetchall()
                    for idx, op in enumerate(ops):
                        prod_code, proc_code, qty, weight = op
                        prod_id = product_map.get(prod_code)
                        proc_id = process_map.get(proc_code)
                        ledg_id = ledger_map.get(f"con_{supplier_code}") or ledger_map.get(f"acc_{supplier_code}")
                        
                        if prod_id and ledg_id:
                            conn.execute(text(f"""
                                INSERT INTO {schema}.stock_inward (inward_no, inward_date, product_id, process_id, ledger_id, quantity, rate, amount, narration)
                                VALUES (:in_no, :date, :prod_id, :proc_id, :ledger_id, :qty, 0, 0, :notes)
                            """), {
                                "in_no": f"IN_{v_no}_{prod_code}_{v_code}_{idx}", "date": clean_date(v_date), "prod_id": prod_id, "proc_id": proc_id, "ledger_id": ledg_id, "qty": abs(clean_num(qty)), "notes": notes or ""
                            })
                            inward_count += 1
            print(f"    Migrated {inward_count} stock inward notes.")
        except Exception as e:
            print(f"    Error migrating stock inward: {e}")
            
        # C. Stock Outward (Type 7)
        print("  Migrating stock outward...")
        try:
            cursor.execute("""
                SELECT prvVoucherCode, prvVoucherNo, prvVoucherDate, prvSupplierCode, prvNotes 
                FROM tblProcessVoucher 
                WHERE prvVoucherTypeCode = 7
            """)
            outwards = cursor.fetchall()
            outward_count = 0
            with engine.begin() as conn:
                for row in outwards:
                    v_code, v_no, v_date, supplier_code, notes = row
                    
                    cursor.execute("""
                        SELECT proProductCode, proProcessCode, proQuantity 
                        FROM tblProcessOperation 
                        WHERE proVoucherCode = ? AND proQtyType = 'Out'
                    """, (v_code,))
                    ops = cursor.fetchall()
                    for idx, op in enumerate(ops):
                        prod_code, proc_code, qty = op
                        prod_id = product_map.get(prod_code)
                        proc_id = process_map.get(proc_code)
                        ledg_id = ledger_map.get(f"con_{supplier_code}") or ledger_map.get(f"acc_{supplier_code}")
                        
                        if prod_id and ledg_id:
                            conn.execute(text(f"""
                                INSERT INTO {schema}.stock_outward (outward_no, outward_date, product_id, process_id, ledger_id, quantity, rate, amount, narration)
                                VALUES (:out_no, :date, :prod_id, :proc_id, :ledger_id, :qty, 0, 0, :notes)
                            """), {
                                "out_no": f"OUT_{v_no}_{prod_code}_{v_code}_{idx}", "date": clean_date(v_date), "prod_id": prod_id, "proc_id": proc_id, "ledger_id": ledg_id, "qty": abs(clean_num(qty)), "notes": notes or ""
                            })
                            outward_count += 1
            print(f"    Migrated {outward_count} stock outward notes.")
        except Exception as e:
            print(f"    Error migrating stock outward: {e}")

        # D. Labour Bills (Type 8)
        print("  Migrating labour bills...")
        try:
            cursor.execute("""
                SELECT cmvVoucherCode, cmvVoucherNo, cmvVoucherDate, cmvPartyAcCode, cmvNotes, cmvGSTRate 
                FROM tblCompanyVoucher 
                WHERE cmvVoucherTypeCode = 8
            """)
            bills = cursor.fetchall()
            bill_count = 0
            with engine.begin() as conn:
                for row in bills:
                    v_code, v_no, v_date, party_code, notes, gst_rate = row
                    ledg_id = ledger_map.get(f"con_{party_code}") or ledger_map.get(f"acc_{party_code}")
                    if not ledg_id:
                        continue
                        
                    cursor.execute("""
                        SELECT prdProductCode, prdProcessCode, prdBilledQuantity 
                        FROM tblProcessDetails 
                        WHERE prdVoucherCode = ?
                    """, (v_code,))
                    details = cursor.fetchall()
                    for idx, det in enumerate(details):
                        prod_code, proc_code, qty = det
                        prod_id = product_map.get(prod_code)
                        proc_id = process_map.get(proc_code)
                        
                        conn.execute(text(f"""
                            INSERT INTO {schema}.labour_bills (bill_no, bill_date, ledger_id, product_id, process_id, quantity, rate, amount, gst_percent, gst_amount, total_amount, narration)
                            VALUES (:bill_no, :date, :ledger_id, :prod_id, :proc_id, :qty, 0, 0, :gst, 0, 0, :notes)
                        """), {
                            "bill_no": f"LB_{v_no}_{prod_code}_{v_code}_{idx}", "date": clean_date(v_date), "ledger_id": ledg_id, "prod_id": prod_id, "proc_id": proc_id, "qty": abs(clean_num(qty)), "gst": clean_num(gst_rate), "notes": notes or ""
                        })
                        bill_count += 1
            print(f"    Migrated {bill_count} labour bills.")
        except Exception as e:
            print(f"    Error migrating labour bills: {e}")

        # E. Salary Vouchers (Type 11)
        print("  Migrating salary vouchers...")
        try:
            cursor.execute("""
                SELECT cmvVoucherCode, cmvVoucherNo, cmvVoucherDate, cmvPartyAcCode, cmvNotes 
                FROM tblCompanyVoucher 
                WHERE cmvVoucherTypeCode = 11
            """)
            salaries = cursor.fetchall()
            sal_count = 0
            with engine.begin() as conn:
                for row in salaries:
                    v_code, v_no, v_date, party_code, notes = row
                    ledg_id = ledger_map.get(f"stf_{party_code}")
                    if not ledg_id:
                        continue
                        
                    cursor.execute("SELECT SUM(vouoAmount) FROM tblVoucherOperations WHERE vouoVoucherCode = ?", (v_code,))
                    salary_amt = cursor.fetchone()[0]
                    
                    date_val = clean_date(v_date)
                    month = date_val.month if date_val else 4
                    year_val = date_val.year if date_val else 2026
                    
                    conn.execute(text(f"""
                        INSERT INTO {schema}.salary_vouchers (voucher_no, voucher_date, ledger_id, month, year, net_salary, narration)
                        VALUES (:v_no, :date, :ledger_id, :month, :year, :salary, :notes)
                    """), {
                        "v_no": f"SAL_{v_no}_{v_code}", "date": date_val, "ledger_id": ledg_id, "month": month, "year": year_val, "salary": abs(clean_num(salary_amt)), "notes": notes or ""
                    })
                    sal_count += 1
            print(f"    Migrated {sal_count} salary vouchers.")
        except Exception as e:
            print(f"    Error migrating salaries: {e}")

        # F. Advance Payments & Receipts (Types 9, 10, 12, 13)
        print("  Migrating advance payments & receipts...")
        try:
            cursor.execute("""
                SELECT cmvVoucherCode, cmvVoucherTypeCode, cmvVoucherNo, cmvVoucherDate, cmvPartyAcCode, cmvNotes 
                FROM tblCompanyVoucher 
                WHERE cmvVoucherTypeCode IN (9, 10, 12, 13)
            """)
            advances = cursor.fetchall()
            adv_count = 0
            with engine.begin() as conn:
                for row in advances:
                    v_code, vtype_code, v_no, v_date, party_code, notes = row
                    payment_type = "Payment" if vtype_code in (9, 12) else "Receipt"
                    ledger_type = "Staff" if vtype_code in (9, 10) else "Contractor"
                    
                    ledg_id = ledger_map.get(f"stf_{party_code}") if ledger_type == "Staff" else ledger_map.get(f"con_{party_code}")
                    if not ledg_id:
                        continue
                        
                    cursor.execute("SELECT SUM(vouoAmount) FROM tblVoucherOperations WHERE vouoVoucherCode = ?", (v_code,))
                    amount = cursor.fetchone()[0]
                    
                    conn.execute(text(f"""
                        INSERT INTO {schema}.advance_payments (voucher_no, voucher_date, ledger_id, payment_type, ledger_type, amount, narration)
                        VALUES (:v_no, :date, :ledger_id, :pay_type, :ledg_type, :amount, :notes)
                    """), {
                        "v_no": f"ADV_{v_no}_{v_code}", "date": clean_date(v_date), "ledger_id": ledg_id, "pay_type": payment_type, "ledg_type": ledger_type, "amount": abs(clean_num(amount)), "notes": notes or ""
                    })
                    adv_count += 1
            print(f"    Migrated {adv_count} advance payments.")
        except Exception as e:
            print(f"    Error migrating advance payments: {e}")

        # G. Job Work Entries (Types 14, 15)
        print("  Migrating job work entries...")
        try:
            cursor.execute("""
                SELECT cmvVoucherCode, cmvVoucherTypeCode, cmvVoucherNo, cmvVoucherDate, cmvPartyAcCode, cmvNotes 
                FROM tblCompanyVoucher 
                WHERE cmvVoucherTypeCode IN (14, 15)
            """)
            jobworks = cursor.fetchall()
            jw_count = 0
            with engine.begin() as conn:
                for row in jobworks:
                    v_code, vtype_code, v_no, v_date, party_code, notes = row
                    entry_type = "Payment" if vtype_code == 14 else "Register"
                    
                    ledg_id = ledger_map.get(f"con_{party_code}")
                    if not ledg_id:
                        continue
                        
                    cursor.execute("""
                        SELECT jwoProductCode, jwoProcessCode, jwoQuantity, jwoRate, jwoAmount 
                        FROM tblJobworkOperation 
                        WHERE jwoVoucherCode = ?
                    """, (v_code,))
                    j_ops = cursor.fetchall()
                    for idx, jp in enumerate(j_ops):
                        prod_code, proc_code, qty, rate, amount = jp
                        prod_id = product_map.get(prod_code)
                        proc_id = process_map.get(proc_code)
                        
                        conn.execute(text(f"""
                            INSERT INTO {schema}.job_work_entries (entry_no, entry_date, ledger_id, product_id, process_id, quantity, rate, amount, entry_type, narration)
                            VALUES (:entry_no, :date, :ledger_id, :prod_id, :proc_id, :qty, :rate, :amount, :type, :notes)
                        """), {
                            "entry_no": f"JW_{v_no}_{prod_code or '0'}_{v_code}_{idx}", "date": clean_date(v_date), "ledger_id": ledg_id, "prod_id": prod_id, "proc_id": proc_id, "qty": abs(clean_num(qty)), "rate": clean_num(rate), "amount": abs(clean_num(amount)), "type": entry_type, "notes": notes or ""
                        })
                        jw_count += 1
            print(f"    Migrated {jw_count} job work entries.")
        except Exception as e:
            print(f"    Error migrating jobwork entries: {e}")

        # I. Stock Transfers
        print("  Migrating stock transfers...")
        try:
            cursor.execute("SELECT sttVoucherCode, sttVoucherNo, sttVoucherDate, sttNotes FROM tblStockTransfer")
            transfers = cursor.fetchall()
            st_count = 0
            with engine.begin() as conn:
                for row in transfers:
                    v_code, v_no, date_val, notes = row
                    
                    cursor.execute("""
                        SELECT jwoProductCode, jwoQuantity 
                        FROM tblJobworkOperation 
                        WHERE jwoVoucherCode = ?
                    """, (v_code,))
                    jp = cursor.fetchone()
                    prod_id = product_map.get(jp[0]) if jp else None
                    qty = abs(clean_num(jp[1])) if jp else 0.0
                    
                    if prod_id:
                        conn.execute(text(f"""
                            INSERT INTO {schema}.stock_transfer (transfer_no, transfer_date, from_stock_item_id, to_stock_item_id, quantity, narration)
                            VALUES (:t_no, :date, :from_id, :to_id, :qty, :notes)
                        """), {
                            "t_no": f"ST_{v_no}_{v_code}", "date": clean_date(date_val), "from_id": prod_id, "to_id": prod_id, "qty": qty, "notes": notes or ""
                        })
                        st_count += 1
            print(f"    Stock transfers loaded ({st_count} rows).")
        except Exception as e:
            print(f"    Error migrating stock transfers: {e}")

        cursor.close()
        mdb_conn.close()

    print("\n================ MIGRATION SUCCESSFULLY COMPLETED ================")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="OrbX Nexus Legacy Access Data Migration ETL")
    parser.add_argument("--export", type=str, help="Export Access data to a JSON file (runs on Windows)")
    parser.add_argument("--import-file", type=str, help="Import data from a JSON file (runs on server/container)")
    
    args = parser.parse_args()
    
    if args.export:
        run_export(args.export)
    elif args.import_file:
        if not os.path.exists(args.import_file):
            print(f"ERROR: Import file not found: {args.import_file}")
            sys.exit(1)
        with open(args.import_file, "r", encoding="utf-8") as f:
            data = json.load(f)
        migrate(json_store=data)
    else:
        migrate()
