#!/usr/bin/env bash
set -euo pipefail

docker_packages=(
    docker
    docker-compose
)

install_docker_packages() {
    echo "==> Installing Docker packages..."
    sudo pacman -S --needed --noconfirm "${docker_packages[@]}"
}

enable_docker_service() {
    echo "==> Enabling Docker service..."
    sudo systemctl enable --now docker.service
    sudo usermod -aG docker "$USER"
    echo "==> Added $USER to 'docker' group. You may need to re-login."
}

main() {
    echo "==> Setting up Docker..."
    install_docker_packages
    enable_docker_service
    echo "==> Docker setup complete."
}

main "$@"
