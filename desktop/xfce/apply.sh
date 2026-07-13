#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[+] Applying XFCE configuration..."

"$ROOT/mouse.sh"
"$ROOT/keyboard.sh"

echo "[+] Done."