#!/usr/bin/env bash
set -euo pipefail

install_zsh() {
    echo "==> Installing Zsh..."
    sudo pacman -S --needed --noconfirm zsh
}

ensure_shells_list() {
    local zsh_path
    zsh_path="$(command -v zsh)"
    
    echo "==> Ensuring Zsh is in /etc/shells..."
    if ! grep -qx "$zsh_path" /etc/shells; then
        echo "==> Adding $zsh_path to /etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null
    fi
}

set_default_shell() {
    local zsh_path
    zsh_path="$(command -v zsh)"
    
    if [[ "$SHELL" != "$zsh_path" ]]; then
        echo "==> Changing default shell to Zsh..."
        sudo chsh -s "$zsh_path" "$USER"
    else
        echo "==> Zsh is already the default shell."
    fi
}

main() {
    install_zsh
    ensure_shells_list
    set_default_shell
    echo "==> Zsh setup complete."
}

main "$@"
