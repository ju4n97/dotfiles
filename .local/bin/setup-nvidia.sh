#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT_FILE="/etc/environment"
MODPROBE_CONF="/etc/modprobe.d/nvidia.conf"
MKINITCPIO_CONF="/etc/mkinitcpio.conf"

write_environment() {
    echo "==> Writing NVIDIA Wayland environment variables..."
    local tmp
    tmp=$(mktemp)
    cat > "$tmp" <<EOF
LIBVA_DRIVER_NAME=nvidia
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia
WLR_NO_HARDWARE_CURSORS=1
NVD_BACKEND=direct
MOZ_ENABLE_WAYLAND=1
NIXOS_OZONE_WL=1
XDG_SESSION_TYPE=wayland
SWAY_UNSUPPORTED_GPU=true
EOF
    if ! sudo cmp -s "$tmp" "$ENVIRONMENT_FILE"; then
        echo "==> Updating $ENVIRONMENT_FILE..."
        sudo install -m 644 "$tmp" "$ENVIRONMENT_FILE"
    else
        echo "==> $ENVIRONMENT_FILE already up to date."
    fi
    rm "$tmp"
}

write_modprobe() {
    echo "==> Writing nvidia modprobe config..."
    local tmp
    tmp=$(mktemp)
    cat > "$tmp" <<EOF
options nvidia_drm modeset=1 fbdev=1
EOF
    if ! sudo cmp -s "$tmp" "$MODPROBE_CONF"; then
        sudo install -m 644 "$tmp" "$MODPROBE_CONF"
        echo "==> $MODPROBE_CONF written."
    else
        echo "==> $MODPROBE_CONF already up to date."
    fi
    rm "$tmp"
}

update_mkinitcpio() {
    echo "==> Checking mkinitcpio MODULES for early KMS..."
    local modules="nvidia nvidia_modeset nvidia_uvm nvidia_drm"
    if grep -qP "MODULES=\(.*nvidia_drm.*\)" "$MKINITCPIO_CONF"; then
        echo "==> NVIDIA modules already present in mkinitcpio.conf."
    else
        echo "==> Adding NVIDIA modules to MODULES array..."
        sudo sed -i "s/^MODULES=(\(.*\))/MODULES=(\1 $modules)/" "$MKINITCPIO_CONF"
        echo "==> Rebuilding initramfs..."
        sudo mkinitcpio -P
    fi
}

main() {
    echo "==> Configuring NVIDIA for Wayland..."
    write_environment
    write_modprobe
    update_mkinitcpio
    echo "==> NVIDIA setup complete. Reboot required."
}

main "$@"
