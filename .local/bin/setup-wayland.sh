#!/usr/bin/env bash
set -euo pipefail

install_packages() {
    echo "==> Installing Wayland support packages..."
    sudo pacman -S --needed --noconfirm \
        xdg-desktop-portal \
        xdg-desktop-portal-wlr \
        xdg-desktop-portal-gtk \
        qt6-wayland \
        qt5-wayland
}

main() {
    echo "==> Configuring Wayland environment..."
    install_packages
    echo "==> Wayland setup complete."
    echo "==> Note: xdg-desktop-portal services are D-Bus activated and start automatically."
}

main "$@"
