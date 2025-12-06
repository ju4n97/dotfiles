#!/usr/bin/env bash
set -euo pipefail

REFLECTOR_CONF_DIR="/etc/xdg/reflector"
REFLECTOR_CONF_FILE="$REFLECTOR_CONF_DIR/reflector.conf"

install_reflector() {
    echo "==> Installing reflector..."
    sudo pacman -S --needed --noconfirm reflector
    sudo mkdir -p "$REFLECTOR_CONF_DIR"
}

write_reflector_conf() {
    echo "==> Ensuring reflector configuration..."

    tmp=$(mktemp)
    cat > "$tmp" <<EOF
--country CO,US,EC
--latest 50
--age 12
--protocol https
--completion-percent 100
--fastest 20
--sort rate
--save /etc/pacman.d/mirrorlist
--verbose
EOF

    if ! sudo cmp -s "$tmp" "$REFLECTOR_CONF_FILE"; then
        echo "==> Updating reflector.conf..."
        sudo install -m 644 "$tmp" "$REFLECTOR_CONF_FILE"
    else
        echo "==> reflector.conf already matches desired state."
    fi

    rm "$tmp"
}

enable_reflector_service() {
    echo "==> Enabling reflector timer..."
    sudo systemctl daemon-reload
    sudo systemctl enable --now reflector.timer
}

run_reflector_now() {
    echo "==> Updating mirrorlist..."
    sudo systemctl start reflector.service
}

main() {
    echo "==> Configuring reflector..."
    install_reflector
    write_reflector_conf
    enable_reflector_service
    run_reflector_now
    echo "==> Reflector configured and mirrorlist refreshed."
}

main "$@"
