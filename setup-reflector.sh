#!/usr/bin/env bash
set -euo pipefail

echo "[+] Installing reflector"
sudo pacman -S --noconfirm reflector

echo "[+] Creating reflector.service"
sudo tee /etc/systemd/system/reflector.service >/dev/null <<'EOF'
[Unit]
Description=Update Arch Linux mirrorlist with Reflector
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/reflector --country $(curl -s https://ipapi.co/country/) \
  --protocol https --latest 20 --number 10 --sort rate \
  --save /etc/pacman.d/mirrorlist
EOF

echo "[+] Creating reflector.timer"
sudo tee /etc/systemd/system/reflector.timer >/dev/null <<'EOF'
[Unit]
Description=Run reflector weekly

[Timer]
OnBootSec=10min
OnUnitActiveSec=7d
Persistent=true

[Install]
WantedBy=timers.target
EOF

echo "[+] Enabling reflector.timer"
sudo systemctl daemon-reexec
sudo systemctl enable --now reflector.timer

echo "[+] Reflector timer setup complete"
