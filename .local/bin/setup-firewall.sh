#!/usr/bin/env bash
set -euo pipefail

install_firewall() {
    echo "==> Installing ufw..."
    sudo pacman -S --needed --noconfirm ufw
}

configure_firewall() {
    echo "==> Enabling basic firewall rules..."
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw enable
    sudo systemctl enable --now ufw.service
}

main() {
    echo "==> Setting up firewall..."
    install_firewall
    configure_firewall
    echo "==> Firewall is active and enabled on boot."
}

main "$@"
