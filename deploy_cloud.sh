#!/usr/bin/env bash
set -e

echo "===================================================="
echo "    OrbX Nexus ERP — Cloud Server Automated Deploy  "
echo "===================================================="
echo ""

# 1. Ensure Docker is installed
if ! command -v docker &> /dev/null; then
    echo "[ERROR] Docker is not installed. Please install Docker first."
    exit 1
fi

# 2. Automatically create 2GB swap space if host memory/swap is low (prevents Node OOM crash)
SWAP_SIZE=$(free -m | awk '/^Swap:/ {print $2}')
if [ -z "$SWAP_SIZE" ] || [ "$SWAP_SIZE" -lt 500 ]; then
    echo "[INFO] Enabling 2GB swap space for compilation safety..."
    sudo fallocate -l 2G /swapfile 2>/dev/null || sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile 2>/dev/null || true
    sudo swapon /swapfile 2>/dev/null || true
    echo "[OK] 2GB Swap space enabled."
fi

# 3. Pull latest code from GitHub
echo "[1/4] Pulling latest updates from GitHub..."
git checkout -- .
git pull origin main

# 4. Build and start containers
echo "[2/4] Building & Launching OrbX Nexus Containers..."
docker compose up --build -d

# 5. Restore product weights and seed data if script exists
echo "[3/4] Checking database seed data & product weights..."
sleep 5
if [ -f "backend/backups/update_product_weights.sql" ]; then
    echo "[INFO] Updating product weights..."
    docker cp backend/backups/update_product_weights.sql orbx_nexus_postgres:/tmp/w.sql 2>/dev/null || true
    docker exec -i orbx_nexus_postgres psql -U orbx -d orbx_nexus -f /tmp/w.sql 2>/dev/null || true
fi

# 6. Verify container status
echo "[4/4] Verifying running containers..."
docker compose ps

echo ""
echo "===================================================="
echo " SUCCESS! OrbX Nexus ERP deployment is COMPLETE.    "
echo "===================================================="
echo " Frontend URL : http://51.20.69.41:8081"
echo " Backend API  : http://51.20.69.41:8001/api/v1/docs"
echo " Default Admin: admin / admin@orbx"
echo "===================================================="
