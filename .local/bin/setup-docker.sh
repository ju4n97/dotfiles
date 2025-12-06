#!/usr/bin/env bash
set -euo pipefail

docker_packages=(
    docker
    docker-compose
    docker-buildx
)

install_docker_packages() {
    echo "==> Installing Docker packages..."
    sudo pacman -S --needed --noconfirm "${docker_packages[@]}"
}

enable_docker_service() {
    echo "==> Enabling Docker service..."
    sudo systemctl enable docker.service
    sudo systemctl start docker.service

    if ! id -nG "$USER" | grep -qw docker; then
        sudo usermod -aG docker "$USER"
        echo "==> Added $USER to 'docker' group. Re-login required."
    else
        echo "==> $USER already in 'docker' group."
    fi
}

main() {
    echo "==> Setting up Docker..."
    install_docker_packages
    enable_docker_service
    echo "==> Docker setup complete."
}

main "$@"
