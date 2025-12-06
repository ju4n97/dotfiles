#!/usr/bin/env bash
set -euo pipefail

bind_shortcut() {
    local command="$1"
    local key="$2"
    local property="/commands/custom/$key"
    local channel="xfce4-keyboard-shortcuts"

    xfconf-query -c "$channel" -p "$property" --create -t string -s "$command"
    xfconf-query -c "$channel" -p "/commands/custom/override" --create -t bool -s true
}

main() {
    echo "==> Configuring XFCE4 custom keyboard shortcuts..."

    bind_shortcut 'flameshot gui' 'Print'
    bind_shortcut 'rofi -show combi -combi-modes "window,run,ssh" -modes combi' '<Super>Space'
    bind_shortcut 'rofi -modi emoji -show emoji' '<Super><Shift>E'
    bind_shortcut 'sh -c "xcolor | xsel -ib"' '<Super><Shift>C'
    bind_shortcut 'sh -c "find ~/Desktop/github.com -mindepth 2 -maxdepth 2 -type d | rofi -dmenu -i | xargs -r -I{} code {}"' '<Super><Shift>X'

    echo "==> XFCE4 shortcuts configured."
    echo "==> If not active immediately, run: xfsettingsd --replace &"
}

main "$@"
