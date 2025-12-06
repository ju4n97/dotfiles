#!/usr/bin/env bash
set -euo pipefail

install_earlyoom() {
    echo "==> Installing earlyoom..."
    sudo pacman -S --needed --noconfirm earlyoom
}

configure_earlyoom() {
    echo "==> Configuring earlyoom..."

    local override_file="/etc/systemd/system/earlyoom.service.d/override.conf"

    sudo mkdir -p "$(dirname "$override_file")"

    sudo tee "$override_file" >/dev/null <<EOF
[Service]
Environment=EARLYOOM_ARGS=-r 2 -s 5
EOF

    sudo systemctl daemon-reload
}

enable_earlyoom() {
    echo "==> Enabling earlyoom service..."
    sudo systemctl enable --now earlyoom.service
}

main() {
    echo "==> Setting up earlyoom..."
    install_earlyoom
    configure_earlyoom
    enable_earlyoom
    echo "==> earlyoom setup complete."
}

main "$@"
