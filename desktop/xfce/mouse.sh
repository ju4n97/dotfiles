#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="/etc/X11/xorg.conf.d"
CONFIG_FILE="$CONFIG_DIR/40-libinput-middle-emulation.conf"

install_xorg_config() {
    local file="$1"
    local content="$2"

    local target="$CONFIG_DIR/$file"

    sudo mkdir -p "$CONFIG_DIR"

    if [[ -f "$target" ]] && [[ "$(cat "$target")" == "$content" ]]; then
        echo "[=] $file"
        return
    fi

    printf '%s\n' "$content" | sudo tee "$target" >/dev/null

    echo "[+] $file"
}

enable_middle_click_emulation() {
    read -r -d '' config <<'EOF' || true
Section "InputClass"
    Identifier "libinput middle mouse emulation"
    MatchIsPointer "on"
    MatchDriver "libinput"
    Option "MiddleEmulation" "on"
EndSection
EOF

    install_xorg_config \
        "40-libinput-middle-emulation.conf" \
        "$config"
}

main() {
    echo "==> Mouse"

    enable_middle_click_emulation

    echo "[-] Log out or reboot for changes to take effect."
}

main "$@"