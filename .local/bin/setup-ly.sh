#!/usr/bin/env bash
set -euo pipefail

LY_CONFIG="/etc/ly/config.ini"

install_ly() {
    echo "==> Installing ly..."
    sudo pacman -S --needed --noconfirm ly
}

configure_ly() {
    echo "==> Checking ly config..."
    if [[ ! -f "$LY_CONFIG" ]]; then
        echo "ERROR: $LY_CONFIG not found. Is ly installed?"
        exit 1
    fi
    # Ensure wayland sessions path is set
    if ! grep -q "^waylandsessions" "$LY_CONFIG"; then
        echo "==> Setting waylandsessions path..."
        sudo sed -i 's|^#waylandsessions.*|waylandsessions = /usr/share/wayland-sessions|' "$LY_CONFIG"
    else
        echo "==> waylandsessions already configured."
    fi
}

switch_dm() {
    echo "==> Switching display manager to ly..."
    # Disable any currently enabled DM
    for dm in lightdm sddm gdm lxdm; do
        if systemctl is-enabled "${dm}.service" &>/dev/null; then
            echo "==> Disabling ${dm}..."
            sudo systemctl disable "${dm}.service"
        fi
    done
    if ! systemctl is-enabled "ly@tty2.service" &>/dev/null; then
        sudo systemctl enable ly@tty2.service
        echo "==> ly enabled on tty2."
    else
        echo "==> ly@tty2 already enabled."
    fi
}

main() {
    echo "==> Configuring display manager..."
    install_ly
    configure_ly
    switch_dm
    echo "==> Display manager setup complete."
}

main "$@"
