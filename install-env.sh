#!/usr/bin/env bash
set -euo pipefail

if ! command -v nvidia-smi &>/dev/null; then
    echo "Warning: nvidia-smi not found. Run ./install-packages.sh first." >&2
fi

ENV_FILE="/etc/environment"

VARS=(
    "LIBVA_DRIVER_NAME=nvidia"
    "NVD_BACKEND=direct"
    "MOZ_DISABLE_RDD_SANDBOX=1"
)

for var in "${VARS[@]}"; do
    key="${var%%=*}"
    if grep -q "^${key}=" "$ENV_FILE" 2>/dev/null; then
        sudo sed -i "s|^${key}=.*|${var}|" "$ENV_FILE"
    else
        echo "$var" | sudo tee -a "$ENV_FILE" > /dev/null
    fi
done

echo "Updated $ENV_FILE. Reboot or start a new login session for changes to take effect."