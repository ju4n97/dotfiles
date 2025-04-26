#!/usr/bin/env bash
set -euo pipefail

install_zsh() {
    echo "==> Installing Zsh and helpers..."
    sudo pacman -S --needed --noconfirm zsh
}

set_default_shell() {
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        echo "==> Changing default shell to Zsh..."
        chsh -s "$(which zsh)"
    else
        echo "==> Zsh is already the default shell."
    fi
}

main() {
    install_zsh
    set_default_shell
    echo "==> Zsh setup complete."
}

main "$@"
