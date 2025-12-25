#!/usr/bin/env bash
set -euo pipefail

RESOLVED_CONF_DIR="/etc/systemd/resolved.conf.d"
RESOLVED_CONF_FILE="$RESOLVED_CONF_DIR/cloudflare.conf"
NM_DNS_CONF="/etc/NetworkManager/conf.d/dns.conf"

configure_systemd_resolved() {
    echo "==> Configuring systemd-resolved..."
    sudo mkdir -p "$RESOLVED_CONF_DIR"
    
    tmp=$(mktemp)
    cat > "$tmp" <<'EOF'
[Resolve]
DNS=1.1.1.1 1.0.0.1 2606:4700:4700::1111
FallbackDNS=8.8.8.8 8.8.4.4
DNSOverTLS=opportunistic
DNSSEC=allow-downgrade
EOF
    
    if ! sudo cmp -s "$tmp" "$RESOLVED_CONF_FILE"; then
        echo "==> Updating systemd-resolved configuration..."
        sudo install -m 644 "$tmp" "$RESOLVED_CONF_FILE"
    else
        echo "==> systemd-resolved configuration already matches desired state."
    fi
    rm "$tmp"
}

enable_systemd_resolved() {
    echo "==> Enabling systemd-resolved..."
    sudo systemctl enable --now systemd-resolved.service
    
    if [ ! -L /etc/resolv.conf ] || [ "$(readlink /etc/resolv.conf)" != "/run/systemd/resolve/stub-resolv.conf" ]; then
        echo "==> Linking /etc/resolv.conf to systemd-resolved..."
        sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
    else
        echo "==> /etc/resolv.conf already linked correctly."
    fi
}

configure_networkmanager() {
    echo "==> Configuring NetworkManager..."
    sudo mkdir -p "$(dirname "$NM_DNS_CONF")"
    
    tmp=$(mktemp)
    cat > "$tmp" <<'EOF'
[main]
dns=systemd-resolved
EOF
    
    if ! sudo cmp -s "$tmp" "$NM_DNS_CONF"; then
        echo "==> Updating NetworkManager DNS configuration..."
        sudo install -m 644 "$tmp" "$NM_DNS_CONF"
    else
        echo "==> NetworkManager DNS configuration already matches desired state."
    fi
    rm "$tmp"
}

restart_services() {
    echo "==> Restarting services..."
    sudo systemctl restart systemd-resolved.service
    sudo systemctl restart NetworkManager.service
}

main() {
    echo "==> Setting up DNS with systemd-resolved and Cloudflare..."
    configure_systemd_resolved
    enable_systemd_resolved
    configure_networkmanager
    restart_services    
    echo "==> DNS configuration complete."
}

main "$@"