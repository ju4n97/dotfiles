#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_ROOT="$ROOT/packages"

read_packages() {
    local file

    for file in "$@"; do
        [[ -f "$file" ]] || continue

        grep -Ev '^\s*($|#)' "$file"
    done
}

install_arch() {
    mapfile -t pkgs < <(
        read_packages \
            "$PKG_ROOT"/_common/*.txt \
            "$PKG_ROOT"/arch/*.txt |
        sort -u
    )

    sudo pacman -Syu --needed "${pkgs[@]}"
}

install_void() {
    local valid=()

    mapfile -t pkgs < <(
        read_packages \
            "$PKG_ROOT"/_common/*.txt \
            "$PKG_ROOT"/void/*.txt |
        sort -u
    )

    for pkg in "${pkgs[@]}"; do
        if xbps-query -Rs "^${pkg}$" >/dev/null 2>&1; then
            valid+=("$pkg")
        else
            printf 'Skipping unknown package: %s\n' "$pkg"
        fi
    done

    ((${#valid[@]})) || {
        echo "No valid packages found."
        exit 1
    }

    sudo xbps-install -Su "${valid[@]}"
}

if command -v pacman >/dev/null 2>&1; then
    install_arch
elif command -v xbps-install >/dev/null 2>&1; then
    install_void
else
    echo "Unsupported distribution."
    exit 1
fi