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

    if ! sudo ufw status | grep -q "Status: active"; then
        sudo ufw --force enable
        echo "==> Firewall enabled."
    else
        echo "==> Firewall already enabled."
    fi

    sudo systemctl enable --now ufw.service
}

main() {
    echo "==> Setting up firewall..."
    install_firewall
    configure_firewall
    echo "==> Firewall is active and enabled on boot."
}

main "$@"
