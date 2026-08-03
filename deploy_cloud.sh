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

echo "[1/4] Pulling & Building Docker Containers (Non-conflicting Ports 8081 & 8001)..."
docker compose -f docker-compose.prod.yml build --no-cache

echo "[2/4] Launching OrbX Nexus Containers..."
docker compose -f docker-compose.prod.yml up -d

echo "[3/4] Waiting for PostgreSQL & Backend to initialize..."
sleep 8

echo "[4/4] Verifying running containers..."
docker compose -f docker-compose.prod.yml ps

echo ""
echo "===================================================="
echo " SUCCESS! OrbX Nexus ERP is now running in Cloud.   "
echo "===================================================="
echo " Frontend URL : http://<YOUR_SERVER_IP>:8081"
echo " Backend API  : http://<YOUR_SERVER_IP>:8001/api/v1/docs"
echo " Default Admin: admin / admin@orbx"
echo "===================================================="
