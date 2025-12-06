#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$HOME/.local/bin"

usage() {
    cat <<EOF
Usage: $0 [options]

Options:
  --reflector
  --earlyoom
  --fonts
  --swap
  --firewall
  --bluetooth
  --docker
  --pacman-hooks
  --devtools
  --zsh
  --xdg-user-dirs
  --xfce4-shortcuts
  --xfce4-middle-button
  --wacom
EOF
    exit 1
}

run_script() {
    local script="$1"
    local title="$2"

    echo "==> $title"
    if [[ ! -f "$SCRIPTS_DIR/$script" ]]; then
        echo "ERROR: Missing script: $SCRIPTS_DIR/$script"
        exit 1
    fi
    bash "$SCRIPTS_DIR/$script"
}

main() {
    local called=0

    for arg in "$@"; do
        case "$arg" in
            --reflector)
                run_script "setup-reflector.sh" "Running reflector setup..."
                ;;
            --earlyoom)
                run_script "setup-earlyoom.sh" "Running earlyoom setup..."
                ;;
            --fonts)
                run_script "setup-fonts.sh" "Running font setup..."
                ;;
            --swap)
                run_script "setup-swap-oom.sh" "Running swap + OOM configuration..."
                ;;
            --firewall)
                run_script "setup-firewall.sh" "Running firewall setup..."
                ;;
            --bluetooth)
                run_script "setup-bluetooth.sh" "Running Bluetooth setup..."
                ;;
            --docker)
                run_script "setup-docker.sh" "Running Docker setup..."
                ;;
            --pacman-hooks)
                run_script "setup-pacman-hooks.sh" "Setting up pacman hooks..."
                ;;
            --devtools)
                run_script "setup-devtools.sh" "Installing devtools..."
                ;;
            --zsh)
                run_script "setup-zsh.sh" "Running Zsh setup..."
                ;;
            --xdg-user-dirs)
                run_script "setup-xdg-user-dirs.sh" "Configuring XDG user directories..."
                ;;
            --xfce4-shortcuts)
                run_script "setup-xfce4-shortcuts.sh" "Applying Xfce4 shortcuts..."
                ;;
            --xfce4-middle-button)
                run_script "setup-xfce4-middle-button.sh" "Configuring Xfce4 middle-button behavior..."
                ;;
            --wacom)
                run_script "setup-wacom.sh" "Running Wacom setup..."
                ;;
            *)
                usage
                ;;
        esac

        called=1
    done

    [[ $called -eq 0 ]] && usage
}

main "$@"
