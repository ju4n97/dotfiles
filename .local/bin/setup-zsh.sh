#!/usr/bin/env bash
set -euo pipefail

install_zsh() {
    echo "==> Installing Zsh..."
    sudo pacman -S --needed --noconfirm zsh
}

install_ohmyposh() {
    echo "==> Installing Oh My Posh..."
    yay -S --needed --noconfirm oh-my-posh
}

ensure_shells_list() {
    local zsh_path
    zsh_path="$(command -v zsh)"

    echo "==> Ensuring Zsh is in /etc/shells..."
    if [[ ! -f /etc/shells ]]; then
        echo "==> /etc/shells not found, creating it..."
        sudo touch /etc/shells
    fi

    if ! grep -qxF "$zsh_path" /etc/shells; then
        echo "==> Adding $zsh_path to /etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    else
        echo "==> Zsh already present in /etc/shells."
    fi
}

set_default_shell() {
    local zsh_path
    zsh_path="$(command -v zsh)"

    if [[ "$SHELL" != "$zsh_path" ]]; then
        echo "==> Changing default shell to Zsh..."
        chsh -s "$zsh_path"
    else
        echo "==> Zsh is already the default shell."
    fi
}

main() {
    echo "==> Setting up Zsh..."
    install_zsh
    install_ohmyposh
    ensure_shells_list
    set_default_shell
    echo "==> Zsh setup complete."
}

main "$@"
