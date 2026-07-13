#!/usr/bin/env bash
set -euo pipefail

CHANNEL="xfce4-keyboard-shortcuts"

set_bool() {
    local property="$1"
    local value="$2"

    local current
    current="$(xfconf-query -c "$CHANNEL" -p "$property" 2>/dev/null || true)"

    if [[ "$current" == "$value" ]]; then
        echo "[=] $property"
        return
    fi

    if [[ -n "$current" ]]; then
        xfconf-query \
            -c "$CHANNEL" \
            -p "$property" \
            -s "$value"
    else
        xfconf-query \
            -c "$CHANNEL" \
            -p "$property" \
            --create \
            -t bool \
            -s "$value"
    fi

    echo "[+] $property"
}

set_string() {
    local property="$1"
    local value="$2"

    local current
    current="$(xfconf-query -c "$CHANNEL" -p "$property" 2>/dev/null || true)"

    if [[ "$current" == "$value" ]]; then
        echo "[=] $property"
        return
    fi

    if [[ -n "$current" ]]; then
        xfconf-query \
            -c "$CHANNEL" \
            -p "$property" \
            -s "$value"
    else
        xfconf-query \
            -c "$CHANNEL" \
            -p "$property" \
            --create \
            -t string \
            -s "$value"
    fi

    echo "[+] $property"
}

bind_shortcut() {
    local shortcut="$1"
    local command="$2"

    set_string "/commands/custom/$shortcut" "$command"
}

enable_custom_shortcuts() {
    set_bool "/commands/custom/override" "true"
}

configure_shortcuts() {
    bind_shortcut "Print" \
        "flameshot gui"

    bind_shortcut "<Super>Space" \
        'rofi -show combi -combi-modes "window,run,ssh" -modes combi'

    bind_shortcut "<Super><Shift>E" \
        "rofimoji" 
  
    bind_shortcut "<Super><Shift>C" \
        'sh -c "xcolor | xsel -ib"'

    bind_shortcut "<Super><Shift>X" \
        'sh -c "find ~/Projects -mindepth 1 -maxdepth 1 -type d | rofi -dmenu -i | xargs -r code-oss"'
}

main() {
    echo "==> Keyboard"

    enable_custom_shortcuts
    configure_shortcuts
}

main "$@"