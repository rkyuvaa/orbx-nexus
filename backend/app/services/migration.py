import os
import json
import pyodbc
from datetime import datetime
from sqlalchemy import create_engine, text
from sqlalchemy.orm import Session

# Database connection settings
PG_URL = "postgresql+psycopg://orbx:orbx_secret@localhost:5432/orbx_nexus"
MDB_PASSWORD = "gks0990gtn"
MDB_DIR = "d:/JWMS/Data/SRI METAL"

MDB_FILES = {
    "2026-2027": "2026-2027.Mdb"
}

def clean_date(val):
    if val is None:
        return None
    if isinstance(val, str):
        try:
            return datetime.strptime(val, "%Y-%m-%d %H:%M:%S")
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

def run_migration():
    pg_engine = create_engine(PG_URL)
    print("Connected to PostgreSQL successfully.")
    
    # Extract zip file containing Mdb databases
    import zipfile
    zip_path = "d:/JWMS/Data/SRI METAL/2023-2024.zip"
    extract_to = "d:/JWMS/Data/SRI METAL"
    if os.path.exists(zip_path):
        print(f"Extracting Mdb files from {zip_path}...")
        try:
            with zipfile.ZipFile(zip_path, 'r') as zip_ref:
                zip_ref.extractall(extract_to)
            print("  Extraction complete.")
        except Exception as e:
            print(f"  Error extracting zip file: {e}")
            
    # Check if ODBC driver for Access is installed
    drivers = [x for x in pyodbc.drivers() if "Access" in x]
    if not drivers:
        print("ERROR: Microsoft Access ODBC Driver not found on this machine.")
        return
    
    driver = drivers[0]
    print(f"Using ODBC Driver: {driver}")
    
    latest_year = "2026-2027"
    latest_mdb_path = os.path.join(MDB_DIR, MDB_FILES[latest_year])
    
    print(f"\n--- Loading Master Data from {latest_year} ({latest_mdb_path}) ---")
    
    conn_str = f"Driver={{{driver}}};DBQ={latest_mdb_path};PWD={MDB_PASSWORD};"
    mdb_conn = pyodbc.connect(conn_str)
    mdb_cursor = mdb_conn.cursor()
    
    with Session(pg_engine) as session:
        # Clear existing data in correct sequence to prevent FK issues
        print("Cleaning old master tables...")
        session.execute(text("TRUNCATE master.rates, master.processes, master.products, master.ledgers, master.ledger_groups, master.units_of_measure, master.company CASCADE"))
        session.commit()
        
        # 1. Migrate Company Profile
        print("Migrating company profile...")
        try:
            mdb_cursor.execute("SELECT comCompanyName, comStreetCompany, comAreaCompany, comCityCompany, comStateCompany, comPINCode, comPhoneNo, comMobileNoOne, comFaxNo, comEMailID, comFinancialYearFrom, comBooksBeginningFrom FROM tblCompanyMaster")
            comp = mdb_cursor.fetchone()
            if comp:
                mdb_cursor.execute("SELECT sttCompanyVATTIN, sttCompanyCST, sttCompanyPAN, sttCompanyExcise, sttCompanyRange, sttCompanyDivision, sttCompanyCommissionerate, sttFormJJPrefix, sttFormJJSerialNo, sttAnnexurePrefix, sttAnnexureSerialNo FROM tblStatutoryTaxation")
                stat = mdb_cursor.fetchone()
                
                session.execute(text("""
                    INSERT INTO master.company (
                        name, address, city, state, pincode, phone, mobile, email, gstin, pan, 
                        financial_year_start_month, logo_path, created_at, updated_at
                    ) VALUES (
                        :name, :address, :city, :state, :pincode, :phone, :mobile, :email, :gstin, :pan,
                        4, null, now(), now()
                    )
                """), {
                    "name": comp[0], "address": f"{comp[1] or ''}, {comp[2] or ''}".strip(", "), "city": comp[3], "state": comp[4], "pincode": comp[5],
                    "phone": comp[6], "mobile": comp[7], "email": comp[9], "gstin": stat[0] if stat else None, "pan": stat[2] if stat else None
                })
            session.commit()
            print("  Company details migrated.")
        except Exception as e:
            session.rollback()
            print(f"  Error migrating company: {e}")

        # 2. Migrate Ledger Groups
        print("Migrating ledger groups (Two-pass)...")
        try:
            mdb_cursor.execute("SELECT acgGroupCode, acgGroupName, acgGroupType, acgUnderGroupCode, acgNatureOfGroup FROM tblAccountsGroup")
            groups = mdb_cursor.fetchall()
            
            # Pass 1: Insert all groups with parent_id = null
            for g in groups:
                session.execute(text("""
                    INSERT INTO master.ledger_groups (id, name, parent_id, group_type, is_system, created_at)
                    VALUES (:id, :name, null, :group_type, false, now())
                """), {
                    "id": g[0], "name": g[1], "group_type": g[2]
                })
            session.commit()
            
            # Pass 2: Update parent_id for each group
            for g in groups:
                parent_id = g[3] if g[3] != 0 else None
                if parent_id is not None:
                    session.execute(text("""
                        UPDATE master.ledger_groups 
                        SET parent_id = :parent_id 
                        WHERE id = :id
                    """), {
                        "id": g[0], "parent_id": parent_id
                    })
            session.commit()
            print(f"  Ledger groups migrated ({len(groups)} rows).")
        except Exception as e:
            session.rollback()
            print(f"  Error migrating ledger groups: {e}")

        # 3. Migrate Units of Measure
        print("Migrating units of measure...")
        try:
            mdb_cursor.execute("SELECT uomUnitCode, uomUnitSymbol, uomFormalName FROM tblUnitMaster")
            units = mdb_cursor.fetchall()
            for u in units:
                session.execute(text("""
                    INSERT INTO master.units_of_measure (id, symbol, name, created_at)
                    VALUES (:id, :symbol, :name, now())
                """), {
                    "id": u[0], "symbol": u[1], "name": u[2]
                })
            session.commit()
            print(f"  Units of measure migrated ({len(units)} rows).")
        except Exception as e:
            session.rollback()
            print(f"  Error migrating units: {e}")

        # 4. Migrate Products Register
        print("Migrating product register...")
        try:
            mdb_cursor.execute("SELECT prrProductCode, prrProductName, prrProductWeight, prrDeleted FROM tblProductRegister")
            products = mdb_cursor.fetchall()
            for p in products:
                session.execute(text("""
                    INSERT INTO master.products (id, name, product_code, description, uom_id, weight, is_active, created_at, updated_at)
                    VALUES (:id, :name, :code, null, 1, :weight, :is_active, now(), now())
                """), {
                    "id": p[0], "name": p[1], "code": str(p[0]), "weight": p[2], "is_active": not clean_bool(p[3])
                })
            session.commit()
            print(f"  Products migrated ({len(products)} rows).")
        except Exception as e:
            session.rollback()
            print(f"  Error migrating products: {e}")

        # 5. Migrate Processes (Stored in legacy as ledgers of type 'Process')
        print("Migrating processes...")
        try:
            mdb_cursor.execute("SELECT aclLedgerCode, aclLedgerName, aclProcessRate, aclJobworkRate, aclDeleted FROM tblAccountsLedger WHERE aclLedgerType = 'Process'")
            processes = mdb_cursor.fetchall()
            for p in processes:
                session.execute(text("""
                    INSERT INTO master.processes (id, name, process_code, product_id, sequence, description, is_active, created_at, company_rate, contractor_rate, gst_percent)
                    VALUES (:id, :name, :code, null, 0, null, :is_active, now(), :company_rate, :contractor_rate, 18.0)
                """), {
                    "id": p[0], "name": p[1], "code": str(p[0]), "is_active": not clean_bool(p[4]),
                    "company_rate": p[2] or 0.0, "contractor_rate": p[3] or 0.0
                })
            session.commit()
            print(f"  Processes migrated ({len(processes)} rows).")
        except Exception as e:
            session.rollback()
            print(f"  Error migrating processes: {e}")

        # Rates Master will be migrated after Contractor Ledgers are loaded (Step 10)

        # 7. Migrate Accounts Ledgers
        print("Migrating accounts ledgers (Customers/Suppliers)...")
        try:
            mdb_cursor.execute("SELECT aclLedgerCode, aclLedgerName, aclUnderGroupCode, aclMailingName, aclStreet, aclArea, aclCity, aclState, aclPINCode, aclPhoneNo, aclEMailID, aclVATTIN, aclPANNumber, aclDeleted FROM tblAccountsLedger WHERE aclLedgerType <> 'Process'")
            ledgers = mdb_cursor.fetchall()
            for l in ledgers:
                session.execute(text("""
                    INSERT INTO master.ledgers (
                        id, name, ledger_code, group_id, ledger_type, opening_balance, balance_type, 
                        phone, mobile, address, city, pincode, state, gstin, pan, is_active, created_at, updated_at
                    ) VALUES (
                        :id, :name, :code, :group_id, 'Account', 0, 'Dr', 
                        :phone, null, :address, :city, :pincode, :state, :gstin, :pan, :is_active, now(), now()
                    )
                """), {
                    "id": l[0], "name": l[1], "code": str(l[0]), "group_id": l[2],
                    "phone": l[9], "address": f"{l[4] or ''}, {l[5] or ''}".strip(", "), "city": l[6], "pincode": l[8], "state": l[7],
                    "gstin": l[11], "pan": l[12], "is_active": not clean_bool(l[13])
                })
            session.commit()
            print(f"  Accounts ledgers migrated ({len(ledgers)} rows).")
        except Exception as e:
            session.rollback()
            print(f"  Error migrating accounts ledgers: {e}")

        # 8. Migrate Staff Ledgers
        print("Migrating staff ledgers...")
        try:
            mdb_cursor.execute("SELECT stfStaffCode, stfStaffName, stfPhoneNo, stfStreet, stfArea, stfCity, stfState, stfPINCode, stfDeleted FROM tblStaffLedger")
            staff = mdb_cursor.fetchall()
            for s in staff:
                session.execute(text("""
                    INSERT INTO master.ledgers (
                        id, name, ledger_code, group_id, ledger_type, opening_balance, balance_type, 
                        phone, mobile, address, city, pincode, state, is_active, created_at, updated_at
                    ) VALUES (
                        :id, :name, :code, 29, 'Staff', 0, 'Dr', 
                        :phone, null, :address, :city, :pincode, :state, :is_active, now(), now()
                    )
                """), {
                    "id": 20000 + s[0], "name": s[1], "code": f"STF-{s[0]}",
                    "phone": s[2], "address": f"{s[3] or ''}, {s[4] or ''}".strip(", "), "city": s[5], "pincode": s[7], "state": s[6],
                    "is_active": not clean_bool(s[8])
                })
            session.commit()
            print(f"  Staff ledgers migrated ({len(staff)} rows).")
        except Exception as e:
            session.rollback()
            print(f"  Error migrating staff: {e}")

        # 9. Migrate Contractor Ledgers
        print("Migrating contractor ledgers...")
        try:
            mdb_cursor.execute("SELECT conContractorCode, conContractorName, conPhoneNo, conStreet, conArea, conCity, conState, conPINCode, conDeleted FROM tblContractorLedger")
            contractors = mdb_cursor.fetchall()
            for c in contractors:
                session.execute(text("""
                    INSERT INTO master.ledgers (
                        id, name, ledger_code, group_id, ledger_type, opening_balance, balance_type, 
                        phone, mobile, address, city, pincode, state, is_active, created_at, updated_at
                    ) VALUES (
                        :id, :name, :code, 30, 'Contractor', 0, 'Dr', 
                        :phone, null, :address, :city, :pincode, :state, :is_active, now(), now()
                    )
                """), {
                    "id": 30000 + c[0], "name": c[1], "code": f"CON-{c[0]}",
                    "phone": c[2], "address": f"{c[3] or ''}, {c[4] or ''}".strip(", "), "city": c[5], "pincode": c[7], "state": c[6],
                    "is_active": not clean_bool(c[8])
                })
            session.commit()
            print(f"  Contractor ledgers migrated ({len(contractors)} rows).")
        except Exception as e:
            session.rollback()
            print(f"  Error migrating contractors: {e}")

        # 10. Migrate Stock Item Master
        print("Migrating stock items...")
        try:
            mdb_cursor.execute("SELECT stiItemCode, stiItemName, stiUnitCode, stiQuantity, stiDeleted FROM tblStockItem")
            stock = mdb_cursor.fetchall()
            for s in stock:
                session.execute(text("""
                    INSERT INTO master.stock_items (id, name, item_code, uom_id, opening_stock, reorder_level, is_active, created_at, updated_at)
                    VALUES (:id, :name, :code, :uom_id, :qty, 0.0, :is_active, now(), now())
                    ON CONFLICT (id) DO NOTHING
                """), {
                    "id": s[0], "name": s[1], "code": str(s[0]), "uom_id": s[2], "qty": s[3] or 0.0, "is_active": not clean_bool(s[4])
                })
            session.commit()
            print(f"  Stock items migrated ({len(stock)} rows).")
        except Exception as e:
            session.rollback()
            print(f"  Error migrating stock items: {e}")

        # 10. Migrate Rates Master (placed here so ledgers already exist)
        print("Migrating contractor rates...")
        try:
            mdb_cursor.execute("""
                SELECT r.rtrLedgerCode, r.rtrProcessCode, d.prdProcessCode, r.rtrProcessRate
                FROM tblRateRegister r
                INNER JOIN tblProcessDetails d ON r.rtrProcessCode = d.prdProductCode
                WHERE d.prdDeleted = False
            """)
            rates = mdb_cursor.fetchall()
            count = 0
            for r in rates:
                # Ensure the referenced process exists to avoid FK violations
                res_p = session.execute(text("SELECT id FROM master.processes WHERE id = :id"), {"id": r[2]}).scalar()
                if not res_p:
                    continue
                
                # Ensure the referenced product exists to avoid FK violations
                res_pr = session.execute(text("SELECT id FROM master.products WHERE id = :id"), {"id": r[1]}).scalar()
                if not res_pr:
                    continue
                    
                ledger_id = 30000 + r[0]
                res_l = session.execute(text("SELECT id FROM master.ledgers WHERE id = :id"), {"id": ledger_id}).scalar()
                if not res_l:
                    res_l = session.execute(text("SELECT id FROM master.ledgers WHERE id = :id"), {"id": r[0]}).scalar()
                    if res_l:
                        ledger_id = r[0]
                    else:
                        continue
                session.execute(text("""
                    INSERT INTO master.rates (process_id, ledger_id, product_id, rate, uom_id, effective_from, effective_to, is_active, created_at)
                    VALUES (:process_id, :ledger_id, :product_id, :rate, 1, null, null, true, now())
                """), {
                    "process_id": r[2], "ledger_id": ledger_id, "product_id": r[1], "rate": r[3]
                })
                count += 1
            session.commit()
            print(f"  Contractor rates migrated ({count} rows).")
            
            # Update process product associations from tblProcessDetails
            print("Updating process product associations...")
            try:
                mdb_cursor.execute("SELECT DISTINCT prdProcessCode, prdProductCode FROM tblProcessDetails WHERE prdDeleted = False")
                prd_rows = mdb_cursor.fetchall()
                count = 0
                for row in prd_rows:
                    session.execute(text("UPDATE master.processes SET product_id = :pid WHERE id = :id"), {"pid": row[1], "id": row[0]})
                    count += 1
                session.commit()
                print(f"  Process product associations updated ({count} relations).")
            except Exception as e_prd:
                session.rollback()
                print(f"  Error updating process product associations: {e_prd}")
                
        except Exception as e:
            session.rollback()
            print(f"  Error migrating rates: {e}")

    mdb_cursor.close()
    mdb_conn.close()

    # 11. Migrate Transactions for all financial years
    print("\n--- Migrating Transaction Data (Vouchers) from all Years ---")
    
    for year, filename in MDB_FILES.items():
        mdb_path = os.path.join(MDB_DIR, filename)
        if not os.path.exists(mdb_path):
            print(f"File not found: {mdb_path}. Skipping.")
            continue
            
        print(f"\nProcessing year: {year}...")
        conn_str = f"Driver={{{driver}}};DBQ={mdb_path};PWD={MDB_PASSWORD};"
        mdb_conn = pyodbc.connect(conn_str)
        mdb_cursor = mdb_conn.cursor()
        
        schema = f"fy_{year.replace('-', '_')}"
        
        with Session(pg_engine) as session:
            # Clear old year-specific data
            print(f"  Cleaning old transaction tables in {schema}...")
            session.execute(text(f"TRUNCATE {schema}.voucher_lines, {schema}.vouchers, {schema}.labour_bills, {schema}.eb_readings, {schema}.stock_transfer, {schema}.stock_item_movements CASCADE"))
            session.execute(text(f"ALTER TABLE {schema}.stock_inward ALTER COLUMN product_id DROP NOT NULL"))
            session.execute(text(f"ALTER TABLE {schema}.stock_outward ALTER COLUMN product_id DROP NOT NULL"))
            session.commit()

            # A. Migrate Financial Vouchers (Payments, Receipts, Contra, Journal, Purchase)
            print("  Migrating financial vouchers...")
            voucher_id_map = {}
            try:
                mdb_cursor.execute("SELECT cmvVoucherCode, cmvVoucherTypeCode, cmvVoucherNo, cmvVoucherDate, cmvPartyAcCode, cmvNotes FROM tblCompanyVoucher")
                vouchers = mdb_cursor.fetchall()
                for v in vouchers:
                    v_type_map = {
                        1: "Opening", 2: "Payment", 3: "Receipt", 4: "Contra", 
                        5: "Journal", 8: "Labor Bill", 14: "Contractor Payment", 17: "Purchase"
                    }
                    v_type = v_type_map.get(v[1], "Payment")
                    
                    # Ensure target ledger exists to prevent constraint failures
                    ledger_id = v[4]
                    res_l = session.execute(text("SELECT id FROM master.ledgers WHERE id = :id"), {"id": ledger_id}).scalar()
                    if not res_l:
                        fallback_id = session.execute(text("SELECT id FROM master.ledgers LIMIT 1")).scalar()
                        ledger_id = fallback_id if fallback_id else ledger_id
                        
                    res = session.execute(text(f"""
                        INSERT INTO {schema}.vouchers (
                            voucher_no, voucher_type, voucher_date, ledger_id, amount, narration, ref_no, created_by, created_at, updated_at
                        ) VALUES (:v_no, :v_type, :v_date, :ledger_id, 0.0, :narr, null, 1, now(), now())
                        RETURNING id
                    """), {
                        "v_no": f"{v_type}-{v[0]}", "v_type": v_type, "v_date": clean_date(v[3]),
                        "ledger_id": ledger_id, "narr": v[5]
                    })
                    new_id = res.fetchone()[0]
                    voucher_id_map[v[0]] = new_id
                session.commit()
                
                # Migrate Lines
                mdb_cursor.execute("SELECT vouoVoucherCode, vouoAmountType, vouoLedgerCode, vouoAmount, vouoParticular FROM tblVoucherOperations")
                lines = mdb_cursor.fetchall()
                line_count = 0
                for l in lines:
                    v_id = voucher_id_map.get(l[0])
                    if not v_id:
                        continue
                    
                    res_ledger = session.execute(text("SELECT id FROM master.ledgers WHERE id = :id"), {"id": l[2]}).scalar()
                    if not res_ledger:
                        continue
                        
                    dr = l[3] if l[1] == 'Debit' else 0.0
                    cr = l[3] if l[1] == 'Credit' else 0.0
                    
                    session.execute(text(f"""
                        INSERT INTO {schema}.voucher_lines (voucher_id, ledger_id, dr_amount, cr_amount, narration)
                        VALUES (:v_id, :ledger_id, :dr, :cr, :narr)
                    """), {
                        "v_id": v_id, "ledger_id": l[2], "dr": dr, "cr": cr, "narr": l[4]
                    })
                    line_count += 1
                session.commit()
                print(f"    Vouchers loaded: {len(vouchers)} vouchers, {line_count} lines.")
            except Exception as e:
                session.rollback()
                print(f"    Error migrating vouchers for {year}: {e}")

            # B. Migrate Labour Bills
            print("  Migrating labour bills...")
            try:
                # Build inward_id_map dynamically from existing stock_inward table
                inward_id_map = {}
                try:
                    res_inwards = session.execute(text(f"SELECT id, inward_no FROM {schema}.stock_inward")).all()
                    mdb_cursor.execute("SELECT prvVoucherCode, prvVoucherNo FROM tblProcessVoucher WHERE prvVoucherTypeCode = 6")
                    legacy_inwards = mdb_cursor.fetchall()
                    legacy_no_to_code = {str(row[1]): row[0] for row in legacy_inwards}
                    
                    for iw_id, iw_no in res_inwards:
                        base_no = iw_no.split("-")[0]
                        leg_code = legacy_no_to_code.get(base_no)
                        if leg_code:
                            inward_id_map[leg_code] = iw_id
                except Exception as e_map:
                    print(f"    Warning: Could not build inward ID map: {e_map}")

                # Build outward_id_map dynamically from existing stock_outward table
                outward_id_map = {}
                try:
                    res_outwards = session.execute(text(f"SELECT id, outward_no FROM {schema}.stock_outward")).all()
                    mdb_cursor.execute("SELECT prvVoucherCode, prvVoucherNo FROM tblProcessVoucher WHERE prvVoucherTypeCode IN (7, 18)")
                    legacy_outwards = mdb_cursor.fetchall()
                    legacy_out_no_to_code = {str(row[1]): row[0] for row in legacy_outwards}
                    
                    for ow_id, ow_no in res_outwards:
                        base_no = ow_no.split("-")[0]
                        leg_code = legacy_out_no_to_code.get(base_no)
                        if leg_code:
                            outward_id_map[leg_code] = ow_id
                except Exception as e_out_map:
                    print(f"    Warning: Could not build outward ID map: {e_out_map}")

                # Fetch process voucher types to know if reference is inward or outward
                mdb_cursor.execute("SELECT prvVoucherCode, prvVoucherTypeCode FROM tblProcessVoucher")
                pv_types = {row[0]: row[1] for row in mdb_cursor.fetchall()}

                # Fetch all labour bill mappings from tblLabourBillDetail
                mdb_cursor.execute("SELECT lbdVoucherCode, lbdReferenceCode FROM tblLabourBillDetail WHERE lbdDeleted = False")
                lbd_rows = mdb_cursor.fetchall()
                
                # Fetch all legacy labour bill headers to build a fallback map
                mdb_cursor.execute("SELECT cmvVoucherCode, cmvVoucherNo FROM tblCompanyVoucher WHERE cmvVoucherTypeCode = 8")
                leg_bills = mdb_cursor.fetchall()
                leg_bill_no_to_code = {row[1]: row[0] for row in leg_bills}
                
                lbd_map = {}
                if lbd_rows:
                    for l in lbd_rows:
                        lbd_map.setdefault(l[1], []).append(l[0]) # jwoVoucherCode (lbdReferenceCode) -> list of lbdVoucherCodes
                else:
                    # Fallback for older years (like 2023-2024): jwoVoucherCode directly matches cmvVoucherNo
                    mdb_cursor.execute("SELECT DISTINCT jwoVoucherCode FROM tblJobworkOperation WHERE jwoDeleted = False")
                    distinct_jwo_codes = [row[0] for row in mdb_cursor.fetchall()]
                    for j_code in distinct_jwo_codes:
                        v_code = leg_bill_no_to_code.get(j_code)
                        if v_code:
                            lbd_map.setdefault(j_code, []).append(v_code)

                # Fetch all jobwork operations (bill line items) for this year
                mdb_cursor.execute("SELECT jwoVoucherCode, jwoProductCode, jwoProcessCode, jwoQuantity, jwoRate, jwoAmount, jwoProductWeight, jwoReferenceCode FROM tblJobworkOperation WHERE jwoDeleted = False")
                jwo_rows = mdb_cursor.fetchall()
                bill_lines = {}
                for r in jwo_rows:
                    jwo_vcode = r[0]
                    bill_codes = lbd_map.get(jwo_vcode, [])
                    for b_code in bill_codes:
                        item_obj = {
                            "product_id": r[1],
                            "process_id": r[2],
                            "quantity": abs(float(r[3] or 0.0)),
                            "rate": float(r[4] or 0.0),
                            "amount": float(r[5] or 0.0),
                            "weight": float(r[6] or 0.0),
                            "inward_id": inward_id_map.get(r[7]) if r[7] else None
                        }
                        bill_lines.setdefault(b_code, []).append(item_obj)

                # Fetch labour bill headers
                mdb_cursor.execute("SELECT cmvVoucherCode, cmvVoucherNo, cmvVoucherDate, cmvPartyAcCode, cmvNotes FROM tblCompanyVoucher WHERE cmvVoucherTypeCode = 8")
                bills = mdb_cursor.fetchall()
                inserted_bills = set()
                for b in bills:
                    res_ledger = session.execute(text("SELECT id FROM master.ledgers WHERE id = :id"), {"id": b[3]}).scalar()
                    if not res_ledger:
                        continue
                        
                    base_no = str(b[1])
                    bill_no = base_no
                    counter = 1
                    while bill_no in inserted_bills:
                        bill_no = f"{base_no}-{counter}"
                        counter += 1
                    inserted_bills.add(bill_no)

                    # Get lines and compute aggregated metrics
                    items_list = bill_lines.get(b[0], [])
                    total_qty = sum(item["quantity"] for item in items_list)
                    total_amt = sum(item["amount"] for item in items_list)
                    
                    first_item = items_list[0] if items_list else {}
                    gst_amt = round(total_amt * 0.18, 2)
                    cgst_amt = round(total_amt * 0.09, 2)
                    sgst_amt = round(total_amt * 0.09, 2)
                    net_amt = total_amt + gst_amt

                    # Find all referenced process vouchers mapped to this labour bill
                    cursor_refs = mdb_cursor.execute("SELECT lbdReferenceCode FROM tblLabourBillDetail WHERE lbdVoucherCode = ? AND lbdDeleted = False", b[0])
                    ref_codes = [row[0] for row in cursor_refs.fetchall()]
                    
                    # Split into inward and outward PG IDs
                    mapped_inward_ids = []
                    mapped_outward_ids = []
                    for rc in ref_codes:
                        v_type = pv_types.get(rc)
                        if v_type == 6: # Inward
                            iw_id = inward_id_map.get(rc)
                            if iw_id:
                                mapped_inward_ids.append(iw_id)
                        elif v_type in (7, 18): # Outward
                            ow_id = outward_id_map.get(rc)
                            if ow_id:
                                mapped_outward_ids.append(ow_id)
                    
                    # Determine inward_id for header
                    inward_id = None
                    if mapped_inward_ids:
                        inward_id = mapped_inward_ids[0]
                    else:
                        for item in items_list:
                            if item.get("inward_id"):
                                inward_id = item["inward_id"]
                                break

                    session.execute(text(f"""
                        INSERT INTO {schema}.labour_bills (
                            bill_no, bill_date, ledger_id, inward_id, product_id, process_id, quantity, rate, amount,
                            gst_percent, gst_amount, cgst_percent, cgst_amount, sgst_percent, sgst_amount, round_off,
                            net_amount, total_amount, narration, is_paid, payment_date, items, outward_ids, created_by, created_at, updated_at
                        ) VALUES (
                            :bill_no, :bill_date, :ledger_id, :inward_id, :product_id, :process_id, :qty, :rate, :amt,
                            18.0, :gst_amount, 9.0, :cgst_amount, 9.0, :sgst_amount, 0.0,
                            :net_amount, :total_amount, :narr, true, :bill_date, :items, :outward_ids, 1, now(), now()
                        )
                    """), {
                        "bill_no": bill_no, "bill_date": clean_date(b[2]), "ledger_id": b[3],
                        "inward_id": inward_id,
                        "product_id": first_item.get("product_id"),
                        "process_id": first_item.get("process_id"),
                        "qty": total_qty, "rate": first_item.get("rate") or 0.0, "amt": total_amt,
                        "gst_amount": gst_amt, "cgst_amount": cgst_amt, "sgst_amount": sgst_amt,
                        "net_amount": net_amt, "total_amount": net_amt,
                        "narr": b[4], "items": json.dumps(items_list),
                        "outward_ids": json.dumps(mapped_outward_ids)
                    })
                session.commit()
                print(f"    Labour bills loaded: {len(bills)} rows.")
            except Exception as e:
                session.rollback()
                print(f"    Error migrating labour bills: {e}")

            # C. Migrate EB Readings
            print("  Migrating electricity EB readings...")
            try:
                mdb_cursor.execute("SELECT ebrDate, ebrUnit FROM tblEBReading")
                readings = mdb_cursor.fetchall()
                for r in readings:
                    session.execute(text(f"""
                        INSERT INTO {schema}.eb_readings (
                            reading_date, meter_no, previous_reading, current_reading, units_consumed, rate_per_unit, amount, narration, created_by, created_at
                        ) VALUES (
                            :reading_date, 'METER-01', 0.0, :reading, :reading, 0.0, 0.0, 'Legacy Import', 1, now()
                        )
                    """), {
                        "reading_date": clean_date(r[0]), "reading": r[1]
                    })
                session.commit()
                print(f"    EB readings loaded: {len(readings)} rows.")
            except Exception as e:
                session.rollback()
                print(f"    Error migrating EB readings: {e}")

            # D. Migrate Stock Transfers
            print("  Migrating stock transfers...")
            try:
                mdb_cursor.execute("SELECT sttVoucherCode, sttVoucherNo, sttVoucherDate, sttNotes FROM tblStockTransfer WHERE sttDeleted = False")
                transfers = mdb_cursor.fetchall()
                for st in transfers:
                    mdb_cursor.execute("SELECT puoItemCode, puoQuantity FROM tblPurchaseOutward WHERE puoVoucherCode = ? AND puoDeleted = False", st[0])
                    lines = mdb_cursor.fetchall()
                    for idx, line in enumerate(lines):
                        base_no = f"TR-{st[1]}"
                        transfer_no = f"{base_no}-{idx+1}"
                        item_id = line[0]
                        res_item = session.execute(text("SELECT id FROM master.stock_items WHERE id = :id"), {"id": item_id}).scalar()
                        if not res_item:
                            continue
                            
                        session.execute(text(f"""
                            INSERT INTO {schema}.stock_transfer (
                                transfer_no, transfer_date, from_stock_item_id, to_stock_item_id, quantity, narration, created_by, created_at
                            ) VALUES (
                                :transfer_no, :transfer_date, :from_item, :to_item, :qty, :narr, 1, now()
                            )
                        """), {
                            "transfer_no": transfer_no, "transfer_date": clean_date(st[2]),
                            "from_item": item_id, "to_item": item_id, "qty": float(line[1] or 0.0),
                            "narr": st[3]
                        })
                session.commit()
                print(f"    Stock transfers loaded: {len(transfers)} rows.")
            except Exception as e:
                session.rollback()
                print(f"    Error migrating stock transfers: {e}")

            # E. Migrate Purchase Inward movements
            print("  Migrating purchase inward stock movements...")
            try:
                mdb_cursor.execute("""
                    SELECT p.puiVoucherCode, p.puiSNumber, p.puiItemCode, p.puiQuantity, p.puiRate, v.cmvVoucherNo, v.cmvVoucherDate, v.cmvPartyAcCode 
                    FROM tblPurchaseInward p
                    INNER JOIN tblCompanyVoucher v ON p.puiVoucherCode = v.cmvVoucherCode
                    WHERE p.puiDeleted = False
                """)
                puis = mdb_cursor.fetchall()
                for p in puis:
                    v_code, s_no, item_id, qty, rate, v_no, v_date, party_id = p
                    
                    res_item = session.execute(text("SELECT id FROM master.stock_items WHERE id = :id"), {"id": item_id}).scalar()
                    if not res_item:
                        continue
                        
                    res_ledger = session.execute(text("SELECT id FROM master.ledgers WHERE id = :id"), {"id": party_id}).scalar()
                    ledger_id = party_id if res_ledger else None
                    
                    m_no = f"PI-{v_no}-{s_no}"
                    session.execute(text(f"""
                        INSERT INTO {schema}.stock_item_movements (
                            movement_no, movement_date, movement_type, stock_item_id, ledger_id, quantity, rate, amount, uom_id, ref_no, narration, created_by, created_at, updated_at
                        ) VALUES (
                            :movement_no, :movement_date, 'Inward', :item_id, :ledger_id, :qty, :rate, :amount, 1, :ref_no, 'Imported legacy purchase inward', 1, now(), now()
                        )
                    """), {
                        "movement_no": m_no, "movement_date": clean_date(v_date), "item_id": item_id, "ledger_id": ledger_id,
                        "qty": float(qty or 0.0), "rate": float(rate or 0.0), "amount": float((qty or 0.0) * (rate or 0.0)),
                        "ref_no": str(v_code)
                    })
                session.commit()
                print(f"    Purchase inward movements loaded: {len(puis)} rows.")
            except Exception as e:
                session.rollback()
                print(f"    Error migrating purchase inward movements: {e}")

            # F. Migrate Stock Transfer Outward movements
            print("  Migrating stock transfer outward movements...")
            try:
                mdb_cursor.execute("""
                    SELECT p.puoVoucherCode, p.puoSNumber, p.puoItemCode, p.puoQuantity, t.sttVoucherNo, t.sttVoucherDate, t.sttStaffCode, t.sttNotes
                    FROM tblPurchaseOutward p
                    INNER JOIN tblStockTransfer t ON p.puoVoucherCode = t.sttVoucherCode
                    WHERE p.puoDeleted = False AND t.sttDeleted = False
                """)
                puos = mdb_cursor.fetchall()
                for p in puos:
                    v_code, s_no, item_id, qty, v_no, v_date, staff_id, notes = p
                    
                    res_item = session.execute(text("SELECT id FROM master.stock_items WHERE id = :id"), {"id": item_id}).scalar()
                    if not res_item:
                        continue
                        
                    staff_ledger_id = 20000 + staff_id
                    res_ledger = session.execute(text("SELECT id FROM master.ledgers WHERE id = :id"), {"id": staff_ledger_id}).scalar()
                    ledger_id = staff_ledger_id if res_ledger else None
                    
                    m_no = f"TR-OUT-{v_no}-{s_no}"
                    session.execute(text(f"""
                        INSERT INTO {schema}.stock_item_movements (
                            movement_no, movement_date, movement_type, stock_item_id, ledger_id, quantity, rate, amount, uom_id, ref_no, narration, created_by, created_at, updated_at
                        ) VALUES (
                            :movement_no, :movement_date, 'Outward', :item_id, :ledger_id, :qty, 0.0, 0.0, 1, :ref_no, :narr, 1, now(), now()
                        )
                    """), {
                        "movement_no": m_no, "movement_date": clean_date(v_date), "item_id": item_id, "ledger_id": ledger_id,
                        "qty": float(qty or 0.0), "ref_no": str(v_code), "narr": notes
                    })
                session.commit()
                print(f"    Stock transfer outward movements loaded: {len(puos)} rows.")
            except Exception as e:
                session.rollback()
                print(f"    Error migrating stock transfer outward movements: {e}")

        mdb_cursor.close()
        mdb_conn.close()

    print("\n================ MIGRATION PIPELINE COMPLETED ================")

if __name__ == "__main__":
    run_migration()
