#!/usr/bin/env bash
set -euo pipefail

# Function to bind a command to a specific key combination in XFCE4
# Arguments:
#   $1: The command string to execute. Use 'sh -c "..."' for complex commands with pipes/redirection.
#   $2: The key combination string (e.g., "<Primary><Alt>t", "<Super>e", "<Shift>F10").
bind_shortcut() {
    local command="$1"
    local key="$2"
    local property="/commands/custom/$key"
    local channel="xfce4-keyboard-shortcuts"

    echo "  Binding '$key' to command: '$command'"

    xfconf-query -c "$channel" -p "$property" --create -t string -s "$command"
    xfconf-query -c "$channel" -p "/commands/custom/override" --create -t bool -s true
}

echo "[+] Setting up XFCE4 custom keyboard shortcuts..."

bind_shortcut 'flameshot gui' 'Print'
bind_shortcut 'rofi -show combi -combi-modes "window,run,ssh" -modes combi' '<Super>space'
bind_shortcut 'rofi -modi emoji -show emoji' '<Super><Shift>E'
bind_shortcut 'sh -c "xcolor | xsel -ib"' '<Super><Shift>C'
bind_shortcut 'sh -c "find ~/Desktop/github.com -mindepth 2 -maxdepth 2 -type d | rofi -dmenu -i | xargs -r -I{} code {}"' '<Super><Shift>X'

echo "[+] XFCE4 shortcuts configured."
echo "[!] Note: You might need to log out and log back in or run 'xfsettingsd --replace &' for changes to take full effect immediately."
