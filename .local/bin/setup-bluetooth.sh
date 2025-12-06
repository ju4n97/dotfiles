#!/usr/bin/env bash
set -euo pipefail

bluetooth_packages=(
    bluez
    bluez-utils
    blueman
)

enable_bluetooth_services() {
    echo "==> Enabling Bluetooth services..."
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
}

install_bluetooth_packages() {
    echo "==> Installing Bluetooth packages..."
    sudo pacman -S --needed --noconfirm "${bluetooth_packages[@]}"
}

main() {
    echo "==> Setting up Bluetooth..."
    install_bluetooth_packages
    enable_bluetooth_services
    echo "==> Bluetooth setup complete."
}

main "$@"
