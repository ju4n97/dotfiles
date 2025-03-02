#!/usr/bin/env bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Use sudo or switch to root user."
    exit 1
fi

# Determine the target user
TARGET_USER="${SUDO_USER:-$(logname 2>/dev/null)}"
if [ -z "$TARGET_USER" ] || [ "$TARGET_USER" == "root" ]; then
    echo "Error: Could not determine target user. Run the script with sudo."
    exit 1
fi

# Check if the OS is Arch Linux or an Arch-based distro
if ! grep -Eq '^ID(_LIKE)?=arch' /etc/os-release; then
    echo "This script is designed for Arch Linux and Arch-based distributions only."
    exit 1
fi

# System update function
update_system() {
    echo "Updating system packages..."
    pacman -Syu --noconfirm
}

# Update user directories
update_user_dirs() {
    echo "Updating XDG user directories for ${TARGET_USER}..."
    sudo -u "$TARGET_USER" xdg-user-dirs-update
}

# Enable and start system services
enable_services() {
    local services=(
        ufw.service
        bluetooth.service
        docker.service
    )

    for service in "${services[@]}"; do
        echo "Enabling and starting ${service}..."
        systemctl enable --now "${service}"
    done
}

# Configure and enable UFW firewall
configure_firewall() {
    echo "Configuring UFW firewall..."
    ufw default deny incoming
    ufw default allow outgoing
    ufw enable
}

# Add user to Docker group
add_user_to_docker() {
    echo "Adding user '${TARGET_USER}' to the 'docker' group..."
    usermod -aG docker "${TARGET_USER}"
}

# Change default shell to Zsh
set_default_shell() {
    local zsh_path
    zsh_path=$(which zsh)

    if ! grep -q "${zsh_path}" /etc/shells; then
        echo "Adding ${zsh_path} to /etc/shells..."
        echo "${zsh_path}" | tee -a /etc/shells
    fi

    echo "Changing default shell to Zsh for ${TARGET_USER}..."
    chsh -s "${zsh_path}" "${TARGET_USER}"
}

main() {
    update_system
    update_user_dirs
    enable_services
    configure_firewall
    add_user_to_docker
    set_default_shell
    echo "System setup completed. Make sure to log out and back in for changes to take effect."
}

main
