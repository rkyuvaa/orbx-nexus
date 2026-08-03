#!/usr/bin/env bash
set -e

echo "===================================================="
echo "    OrbX Nexus ERP — Cloud Server Deployment       "
echo "===================================================="
echo ""

# 1. Ensure Docker & Docker Compose are installed
if ! command -v docker &> /dev/null; then
    echo "[ERROR] Docker is not installed. Please install Docker first."
    exit 1
fi

# 2. Automatically create 2GB swap space if host memory/swap is low (prevents Node OOM crash)
SWAP_SIZE=$(free -m | awk '/^Swap:/ {print $2}')
if [ -z "$SWAP_SIZE" ] || [ "$SWAP_SIZE" -lt 500 ]; then
    echo "[INFO] Low RAM/Swap detected on server. Adding 2GB swap space for smooth compilation..."
    sudo fallocate -l 2G /swapfile 2>/dev/null || sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile 2>/dev/null || true
    sudo swapon /swapfile 2>/dev/null || true
    echo "[OK] 2GB Swap space enabled."
fi

echo "[1/5] Pulling & Building Docker Containers (Non-conflicting Ports 8081 & 8001)..."
docker compose -f docker-compose.prod.yml build

echo "[2/5] Launching OrbX Nexus Containers..."
docker compose -f docker-compose.prod.yml up -d

echo "[3/5] Waiting for PostgreSQL & Backend to initialize..."
sleep 10

echo "[4/5] Initializing clean database & setting default admin user..."
docker exec orbx_nexus_backend python flush_data.py

echo "[5/5] Verifying running containers..."
docker compose -f docker-compose.prod.yml ps

echo ""
echo "===================================================="
echo " SUCCESS! OrbX Nexus ERP is now running in Cloud.   "
echo "===================================================="
echo " Frontend URL : http://<YOUR_SERVER_IP>:8081"
echo " Backend API  : http://<YOUR_SERVER_IP>:8001/api/v1/docs"
echo " Default Admin: admin / admin@orbx"
echo "===================================================="
