#!/usr/bin/env bash
set -euo pipefail

install_xdg_user_dirs() {
    echo "==> Installing xdg-user-dirs..."
    sudo pacman -S --needed --noconfirm xdg-user-dirs
}

create_user_dirs() {
    echo "==> Creating user directories..."
    xdg-user-dirs-update
}

main() {
    echo "==> Setting up xdg-user-dirs..."
    install_xdg_user_dirs
    create_user_dirs
    echo "==> xdg-user-dirs setup complete."
}

main "$@"
