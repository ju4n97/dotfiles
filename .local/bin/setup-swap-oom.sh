#!/usr/bin/env bash
set -euo pipefail

ZRAM_CONF_DIR="/etc/systemd/zram-generator.conf.d"
ZRAM_CONF_FILE="$ZRAM_CONF_DIR/zram.conf"
SYSCTL_CONF="/etc/sysctl.d/99-swappiness.conf"

install_zram_config() {
    echo "==> Configuring zram..."
    sudo mkdir -p "$ZRAM_CONF_DIR"
    sudo tee "$ZRAM_CONF_FILE" >/dev/null <<EOF
[zram0]
zram-size = ram
compression-algorithm = zstd
EOF
    sudo systemctl daemon-reexec
    sudo systemctl restart systemd-zram-setup@zram0.service
}

tune_swappiness() {
    echo "==> Setting vm.swappiness to 180..."
    echo 'vm.swappiness=180' | sudo tee "$SYSCTL_CONF" >/dev/null
}

enable_earlyoom() {
    echo "==> Installing and enabling earlyoom..."
    sudo pacman -S --needed --noconfirm earlyoom
    sudo systemctl enable --now earlyoom
}

verify_swap() {
    echo "==> Verifying swap setup..."
    swapon --show || echo "!! No active swap detected"
}

main() {
    echo "==> Starting system memory optimization setup..."
    install_zram_config
    tune_swappiness
    enable_earlyoom
    verify_swap
    echo "==> Memory configuration complete."
}

main "$@"
