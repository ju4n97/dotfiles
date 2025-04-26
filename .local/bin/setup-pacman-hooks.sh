#!/usr/bin/env bash
set -euo pipefail

HOOKS_DIR="/etc/pacman.d/hooks"

install_pkglist_hook() {
    echo "==> Installing pacman hook for backup..."
    sudo mkdir -p "$HOOKS_DIR"
    sudo tee "$HOOKS_DIR/pkglist-backup.hook" >/dev/null <<EOF
[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = Package
Target = *

[Action]
Description = Backup package list after every pacman transaction...
When = PostTransaction
Exec = /usr/bin/bash -c "pacman -Qqen > /home/$(logname)/pacman.bk.txt && pacman -Qqem > /home/$(logname)/aur.bk.txt"
EOF
}

main() {
    install_pkglist_hook
    echo "==> Pacman hooks setup complete."
}

main "$@"
