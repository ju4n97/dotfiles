#!/usr/bin/env bash
set -euo pipefail

configure_dns() {
    echo "==> Configuring systemd-resolved DNS..."

    sudo mkdir -p /etc/systemd/resolved.conf.d
    sudo tee /etc/systemd/resolved.conf.d/dns.conf >/dev/null <<EOF
[Resolve]
DNS=1.1.1.1 8.8.8.8
FallbackDNS=1.0.0.1 8.8.4.4
DNSStubListener=yes
EOF

    echo "==> Enabling and restarting systemd-resolved..."
    sudo systemctl enable --now systemd-resolved

    sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

    echo "==> DNS servers configured to: 1.1.1.1, 8.8.8.8 (systemd-resolved enabled)"
}

main() {
    configure_dns
}

main "$@"
