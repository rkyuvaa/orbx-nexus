#!/usr/bin/env bash
set -euo pipefail

echo "===================================================="
echo "    OrbX Nexus ERP — Cloud Server Automated Deploy  "
echo "===================================================="
echo ""

# Deploy only the exact, clean release already checked out on the server.
EXPECTED_REF="${1:-}"
if [[ -z "$EXPECTED_REF" ]]; then
    echo "[ERROR] Usage: $0 <expected-commit-or-ref>"
    exit 2
fi

if ! EXPECTED_COMMIT="$(git rev-parse --verify "${EXPECTED_REF}^{commit}" 2>/dev/null)"; then
    echo "[ERROR] The requested release ref does not resolve to a commit."
    exit 1
fi

CURRENT_COMMIT="$(git rev-parse HEAD)"
if [[ "$CURRENT_COMMIT" != "$EXPECTED_COMMIT" ]]; then
    echo "[ERROR] Checked-out commit ($CURRENT_COMMIT) does not match expected commit ($EXPECTED_COMMIT)."
    echo "Check out the reviewed release manually, then rerun this script."
    exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
    echo "[ERROR] Refusing to deploy a dirty worktree; no local changes will be discarded."
    git status --short
    exit 1
fi

# Nginx serves HTTPS directly on port 8090. The container mounts a dedicated
# cert copy so it never depends on the shared, root-only /etc/letsencrypt tree
# used by other services on this host.
LETSENCRYPT_DIR="/etc/letsencrypt/live/nexus.orbx.in"
CERT_DIR="/etc/orbx-nexus-certs"
mkdir -p "$CERT_DIR"
for cert_file in fullchain.pem privkey.pem; do
    if [[ -r "$LETSENCRYPT_DIR/$cert_file" ]]; then
        cp -L "$LETSENCRYPT_DIR/$cert_file" "$CERT_DIR/$cert_file"
    fi
done
chmod 644 "$CERT_DIR/fullchain.pem" 2>/dev/null
chmod 600 "$CERT_DIR/privkey.pem" 2>/dev/null
for required_cert in "$CERT_DIR/fullchain.pem" "$CERT_DIR/privkey.pem"; do
    if [[ ! -r "$required_cert" ]]; then
        echo "[ERROR] Required TLS file is missing or unreadable: $required_cert"
        exit 1
    fi
done

if ! openssl x509 -in "$CERT_DIR/fullchain.pem" -noout -checkend 0 >/dev/null; then
    echo "[ERROR] The nexus.orbx.in TLS certificate is expired or invalid."
    exit 1
fi
if ! openssl x509 -in "$CERT_DIR/fullchain.pem" -noout -checkhost nexus.orbx.in >/dev/null; then
    echo "[ERROR] The TLS certificate does not cover nexus.orbx.in."
    exit 1
fi

# 1. Ensure Docker is installed
if ! command -v docker &> /dev/null; then
    echo "[ERROR] Docker is not installed. Please install Docker first."
    exit 1
fi
if ! command -v curl &> /dev/null; then
    echo "[ERROR] curl is required for the post-deployment HTTPS check."
    exit 1
fi

# Validate the Compose file before taking a backup or changing containers.
echo "[1/4] Validating Docker Compose configuration..."
docker compose config --quiet
echo "[INFO] Port 8090 must be free; remove Caddy's nexus.orbx.in:8090 site first."

# Back up and verify the current database before application startup migrations run.
echo "[2/4] Creating a PostgreSQL backup..."
umask 077
BACKUP_DIR="$HOME/orbx-nexus-backups"
mkdir -p "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/orbx_nexus_predeploy_$(date -u +%Y%m%dT%H%M%SZ).dump"
if ! docker exec orbx_nexus_postgres pg_dump -U orbx -d orbx_nexus -Fc > "$BACKUP_FILE"; then
    echo "[ERROR] Database backup failed; deployment has been stopped."
    exit 1
fi
if [[ ! -s "$BACKUP_FILE" ]] || ! docker exec -i orbx_nexus_postgres pg_restore --list < "$BACKUP_FILE" >/dev/null; then
    echo "[ERROR] Database backup is empty or invalid; deployment has been stopped."
    echo "[INFO] Backup file: $BACKUP_FILE"
    exit 1
fi
chmod 600 "$BACKUP_FILE"
echo "[OK] Verified database backup: $BACKUP_FILE"

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

# 3. Build and start containers
echo "[3/4] Building & Launching OrbX Nexus Containers..."
docker compose up --build -d

# 4. Verify container status
echo "[4/4] Verifying running containers..."
docker compose ps
if ! curl --noproxy '*' --fail --silent --output /dev/null --connect-timeout 5 \
    --resolve nexus.orbx.in:8090:127.0.0.1 \
    https://nexus.orbx.in:8090/; then
    echo "[ERROR] Local HTTPS check failed. Inspect the container status and logs before retrying."
    exit 1
fi

echo ""
echo "===================================================="
echo " SUCCESS! OrbX Nexus ERP deployment is COMPLETE.    "
echo "===================================================="
echo " Frontend URL : https://nexus.orbx.in:8090/"
echo " Backend API  : https://nexus.orbx.in:8090/api/v1/docs"
echo " Database backup: $BACKUP_FILE"
echo "===================================================="
