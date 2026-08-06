import subprocess
import os

filepath = os.path.join(os.path.dirname(__file__), "backups", "orbx_nexus_production_seed.sql")

res = subprocess.run(
    ["docker", "exec", "orbx_nexus_postgres", "pg_dump", "-U", "orbx", "orbx_nexus"],
    capture_output=True,
    check=True
)

with open(filepath, "wb") as f:
    f.write(res.stdout)

print(f"[OK] Dumped {len(res.stdout)} bytes to {filepath} in raw UTF-8 format.")
