#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$HOME/.local/bin"

usage() {
    echo "Usage: $0 [--reflector | --fonts | --swap | --firewall | --dns | --network-optimizations | --bluetooth | --docker | --pacman-hooks | --devtools | --zsh | --xdg-user-dirs | --shortcuts-xfce4]"
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
        --dns)
            echo "==> Setting up DNS..."
            bash "$SCRIPTS_DIR/setup-dns.sh"
            called=1
            ;;
        --network-optimizations)
            echo "==> Setting up network optimizations..."
            bash "$SCRIPTS_DIR/setup-network-optimizations.sh"
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
        --shortcuts-xfce4)
            echo "==> Setting up Xfce4 shortcuts..."
            bash "$SCRIPTS_DIR/setup-shortcuts-xfce4.sh"
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
