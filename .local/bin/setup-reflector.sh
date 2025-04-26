#!/usr/bin/env bash
set -euo pipefail

REFLECTOR_CONF_DIR="/etc/xdg/reflector"
REFLECTOR_CONF_FILE="$REFLECTOR_CONF_DIR/reflector.conf"
TIMER_UNIT="/etc/systemd/system/reflector-update.timer"
SERVICE_UNIT="/etc/systemd/system/reflector-update.service"

install_reflector() {
  echo "==> Installing reflector..."
  sudo pacman -S --needed --noconfirm reflector
  sudo mkdir -p "$REFLECTOR_CONF_DIR"
}

write_reflector_conf() {
  echo "==> Writing reflector configuration..."
  sudo tee "$REFLECTOR_CONF_FILE" >/dev/null <<EOF
--country CO,US,EC
--latest 20
--age 12
--protocol https
--sort rate
--save /etc/pacman.d/mirrorlist
EOF
  sudo chmod 644 "$REFLECTOR_CONF_FILE"
}

create_service_unit() {
  echo "==> Creating systemd service..."
  sudo tee "$SERVICE_UNIT" >/dev/null <<EOF
[Unit]
Description=Update pacman mirrorlist with reflector
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/reflector --config $REFLECTOR_CONF_FILE
RemainAfterExit=yes
EOF
}

create_timer_unit() {
  echo "==> Creating systemd timer..."
  sudo tee "$TIMER_UNIT" >/dev/null <<EOF
[Unit]
Description=Run reflector every 3 days

[Timer]
OnCalendar=Mon,Thu *-*-* 06:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF
}

enable_reflector_service() {
  echo "==> Enabling reflector timer..."
  sudo systemctl daemon-reload
  sudo systemctl enable --now reflector-update.timer
  echo "==> Reflector timer enabled."
}

main() {
  install_reflector
  write_reflector_conf
  create_service_unit
  create_timer_unit
  enable_reflector_service
  echo "==> Reflector is configured to run every 3 days."
}

main "$@"
