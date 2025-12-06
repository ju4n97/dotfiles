#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="/etc/X11/xorg.conf.d/middle-mouse-button.conf"

write_config() {
    echo "==> Ensuring X11 middle mouse emulation config..."

    sudo mkdir -p /etc/X11/xorg.conf.d

    tmp=$(mktemp)
    cat > "$tmp" <<EOF
Section "InputClass"
   Identifier "middle button"
   MatchIsPointer "on"
   MatchDriver "libinput"
   Option "MiddleEmulation" "on"
EndSection
EOF

    if ! sudo cmp -s "$tmp" "$CONFIG_FILE"; then
        echo "==> Writing config..."
        sudo install -m 644 "$tmp" "$CONFIG_FILE"
    else
        echo "==> Config already matches desired state."
    fi

    rm "$tmp"
}

main() {
    write_config
    echo "==> Config ensured at $CONFIG_FILE"
    echo "==> Reboot to apply changes."
}

main "$@"
