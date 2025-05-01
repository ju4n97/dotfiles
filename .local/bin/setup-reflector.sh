#!/usr/bin/env bash
set -euo pipefail

REFLECTOR_CONF_DIR="/etc/xdg/reflector"
REFLECTOR_CONF_FILE="$REFLECTOR_CONF_DIR/reflector.conf"

install_reflector() {
  echo "==> Installing reflector..."
  sudo pacman -S --needed --noconfirm reflector
  sudo mkdir -p "$REFLECTOR_CONF_DIR"
}

write_reflector_conf() {
  echo "==> Writing optimized reflector configuration..."
  sudo tee "$REFLECTOR_CONF_FILE" >/dev/null <<EOF
--country CO,US,EC
--latest 50
--age 12
--protocol https
--completion-percent 100
--fastest 20
--sort rate
--save /etc/pacman.d/mirrorlist
--verbose
EOF
  sudo chmod 644 "$REFLECTOR_CONF_FILE"
}

enable_reflector_service() {
  echo "==> Enabling built-in reflector timer..."
  sudo systemctl daemon-reload
  sudo systemctl enable --now reflector.timer
  echo "==> Reflector timer enabled."
}

run_reflector_now() {
  echo "==> Running reflector now to update mirrors..."
  sudo systemctl start reflector.service &>/dev/null &
  echo "==> Mirrors updated."
}

main() {
  install_reflector
  write_reflector_conf
  enable_reflector_service
  run_reflector_now
  echo "==> Reflector is configured and running with the system's built-in timer."
}

main "$@"
