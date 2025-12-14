#!/usr/bin/env bash
set -euo pipefail

STEAM_PKGS=(
    steam
    lib32-nvidia-utils
    lib32-vulkan-icd-loader
    vulkan-tools
)

enable_multilib() {
    if grep -q "^\[multilib\]" /etc/pacman.conf; then
        echo "==> multilib already enabled."
        return
    fi

    echo "==> Enabling multilib repository..."
    sudo sed -i '/^\#\[multilib\]/,/^\#Include/ s/^#//' /etc/pacman.conf
    sudo pacman -Sy --noconfirm
}

verify_nvidia() {
    echo "==> Verifying NVIDIA driver..."
    if ! command -v nvidia-smi &>/dev/null; then
        echo "!! NVIDIA driver not detected. Aborting."
        exit 1
    fi
}

install_steam_pkgs() {
    echo "==> Installing Steam and required dependencies..."
    sudo pacman -S --needed --noconfirm "${STEAM_PKGS[@]}"
}

verify_vulkan() {
    echo "==> Verifying Vulkan..."
    if ! command -v vulkaninfo &>/dev/null; then
        echo "!! vulkaninfo missing. Vulkan may not be functional."
        exit 1
    fi
}

post_install_notes() {
    cat <<EOF

==> Steam setup complete.

Next steps:
1. Launch Steam
2. Settings -> Compatibility
3. Enable "Steam Play for all titles"

EOF
}

main() {
    enable_multilib
    verify_nvidia
    install_steam_pkgs
    verify_vulkan
    post_install_notes
}

main "$@"
