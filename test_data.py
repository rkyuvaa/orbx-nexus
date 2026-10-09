import psycopg
import json
import traceback

def run():
    try:
        conn = psycopg.connect('postgresql://orbx:orbx_secret@localhost:5432/orbx_nexus')
        conn.autocommit = True
        
        inw = conn.execute("SELECT id, inward_no, serial_no, ref_no, items, process_id FROM fy_2026_2027.stock_inward WHERE inward_no = '0571' OR serial_no = 'FJO2126'").fetchone()
        
        with open('debug_output.txt', 'w') as f:
            if not inw:
                f.write("Inward not found\n")
                return
            
            inw_id = inw[0]
            f.write(f"Found Inward: {inw}\n")
            
            outs = conn.execute("SELECT id, outward_no, process_id, items, inward_id, inward_ids FROM fy_2026_2027.stock_outward WHERE inward_id = %s OR items::text LIKE %s", (inw_id, f'%{inw_id}%')).fetchall()
            f.write("Found Outwards:\n")
            for out in outs:
                f.write(f"Outward ID: {out[0]}, No: {out[1]}, Process ID: {out[2]}, Inward ID: {out[4]}, Inward IDs: {out[5]}\n")
                f.write(f"Items: {out[3]}\n")
            
        conn.close()
    except Exception as e:
        with open('debug_output.txt', 'w') as f:
            f.write("Error: " + str(e) + "\n" + traceback.format_exc())

if __name__ == '__main__':
    run()
