#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$HOME/.local/bin"

usage() {
    echo "Usage: $0 [--reflector | --fonts | --swap | --firewall | --bluetooth | --docker | --pacman-hooks | --devtools | --zsh | --xdg-user-dirs | --xfce4-shortcuts | --xfce4-middle-button | --wacom]"
    exit 1
}

main() {
    local called=0

    for arg in "$@"; do
        case "$arg" in
        --reflector)
            echo "==> Running reflector setup..."
            bash "$SCRIPTS_DIR/setup-reflector.sh"
            called=1
            ;;
        --fonts)
            echo "==> Running font setup..."
            bash "$SCRIPTS_DIR/setup-fonts.sh"
            called=1
            ;;
        --swap)
            echo "==> Running swap + OOM configuration..."
            bash "$SCRIPTS_DIR/setup-swap-oom.sh"
            called=1
            ;;
        --firewall)
            echo "==> Running firewall setup..."
            bash "$SCRIPTS_DIR/setup-firewall.sh"
            called=1
            ;;  
        --bluetooth)
            echo "==> Running Bluetooth setup..."
            bash "$SCRIPTS_DIR/setup-bluetooth.sh"
            called=1
            ;;
        --docker)
            echo "==> Running Docker setup..."
            bash "$SCRIPTS_DIR/setup-docker.sh"
            called=1
            ;;
        --pacman-hooks)
            echo "==> Setting up package list backup hook..."
            bash "$SCRIPTS_DIR/setup-pacman-hooks.sh"
            called=1
            ;;
        --devtools)
            echo "==> Running devtools setup..."
            bash "$SCRIPTS_DIR/setup-devtools.sh"
            called=1
            ;;
        --zsh)
            echo "==> Running Zsh setup..."
            bash "$SCRIPTS_DIR/setup-zsh.sh"
            called=1
            ;;
        --xdg-user-dirs)
            echo "==> Setting up xdg-user-dirs..."
            bash "$SCRIPTS_DIR/setup-xdg-user-dirs.sh"
            called=1
            ;;
        --xfce4-shortcuts)
            echo "==> Setting up Xfce4 shortcuts..."
            bash "$SCRIPTS_DIR/setup-xfce4-shortcuts.sh"
            called=1
            ;;
        --xfce4-middle-button)
            echo "==> Setting up Xfce4 middle button..."
            bash "$SCRIPTS_DIR/setup-xfce4-middle-button.sh"
            called=1
            ;;
        --wacom)
            echo "==> Running Wacom setup..."
            bash "$SCRIPTS_DIR/setup-wacom.sh"
            called=1
            ;;
        *)
            usage
            ;;
        esac
    done

    if [[ $called -eq 0 ]]; then
        usage
    fi
}

main "$@"
