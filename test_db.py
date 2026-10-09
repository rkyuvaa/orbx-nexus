import psycopg
conn = psycopg.connect('postgresql://orbx:orbx_secret@localhost:5432/orbx_nexus')
res = conn.execute("SELECT id, inward_ids, process_id, items FROM fy_2026_2027.stock_outward WHERE ledger_id = (SELECT id FROM master.ledgers WHERE name LIKE '%TEXMO%' LIMIT 1) ORDER BY id DESC LIMIT 5").fetchall()
for r in res:
    print(r)
conn.close()
