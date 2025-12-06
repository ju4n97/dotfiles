#!/usr/bin/env bash
set -euo pipefail

pacman_fonts=(
    gnu-free-fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    otf-monaspace-nerd
    ttf-dejavu
    ttf-droid
    ttf-firacode-nerd
    ttf-font-awesome
    ttf-hack-nerd
    ttf-inconsolata
    ttf-jetbrains-mono-nerd
    ttf-liberation
    ttf-nerd-fonts-symbols
    ttf-nerd-fonts-symbols-mono
    ttf-roboto
    ttf-ubuntu-font-family
    ttf-ubuntu-mono-nerd
    ttf-ubuntu-nerd
)

aur_fonts=(
    ttf-ms-fonts
)

install_pacman_fonts() {
    if [[ ${#pacman_fonts[@]} -gt 0 ]]; then
        echo "==> Installing fonts from official repositories..."
        sudo pacman -S --needed --noconfirm "${pacman_fonts[@]}"
    fi
}

install_aur_fonts() {
    if [[ ${#aur_fonts[@]} -gt 0 ]]; then
        if ! command -v yay &>/dev/null; then
            echo "!! 'yay' not found. Please install an AUR helper before proceeding."
            exit 1
        fi

        echo "==> Installing fonts from AUR..."
        yay -S --needed --noconfirm "${aur_fonts[@]}"
    fi
}

refresh_font_cache() {
    echo "==> Refreshing font cache..."
    fc-cache -f >/dev/null
}

main() {
    echo "==> Starting font installation..."
    install_pacman_fonts
    install_aur_fonts
    refresh_font_cache
    echo "==> Font installation complete."
}

main "$@"
