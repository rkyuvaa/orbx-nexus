import pyodbc

conn_str = r"Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=D:\JWMS\Data\SRI METAL\2026-2027.Mdb;PWD=gks0990gtn;"
conn = pyodbc.connect(conn_str)
cursor = conn.cursor()

print("--- Product Register Columns ---")
for col in cursor.columns(table='tblProductRegister'):
    print(col.column_name)

print("\n--- Stock Item Master Columns ---")
for col in cursor.columns(table='tblStockItemMaster'):
    print(col.column_name)

print("\n--- Sample product rows ---")
cursor.execute("SELECT TOP 5 * FROM tblProductRegister")
cols = [column[0] for column in cursor.description]
for r in cursor.fetchall():
    print(dict(zip(cols, r)))
