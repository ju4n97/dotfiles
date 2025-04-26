#!/usr/bin/env bash
set -euo pipefail

pacman_pkgs=(
    git-filter-repo
    github-cli
    go
    helix
    make
    nodejs
    npm
)

aur_pkgs=(
    beekeeper-studio-bin
    postman-bin
    visual-studio-code-bin
)

install_pacman_pkgs() {
    echo "==> Installing devtools from official repos..."
    sudo pacman -S --needed --noconfirm "${pacman_pkgs[@]}"
}

install_aur_pkgs() {
    if ! command -v yay &>/dev/null; then
        echo "!! 'yay' not found. Please install it before running this script."
        exit 1
    fi
    echo "==> Installing AUR devtools..."
    yay -S --needed --noconfirm "${aur_pkgs[@]}"
}

install_bun() {
    echo "==> Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
}

install_gotask() {
    echo "==> Installing gotask..."
    go install github.com/go-task/task/v3/cmd/task@latest
}

main() {
    install_pacman_pkgs
    install_aur_pkgs
    install_bun
    install_gotask
    echo "==> Devtools setup complete."
}

main "$@"
