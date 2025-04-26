#!/usr/bin/env bash
set -euo pipefail

tune_sysctl() {
    echo "==> Applying sysctl network optimizations..."

    sudo tee /etc/sysctl.d/99-network-performance.conf >/dev/null <<EOF
# Increase TCP max buffer size
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216

# Increase Linux autotuning TCP buffer limits
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216

# Enable TCP Window Scaling
net.ipv4.tcp_window_scaling = 1

# Enable TCP Fast Open (faster handshakes)
net.ipv4.tcp_fastopen = 3

# Reduce TCP FIN timeout
net.ipv4.tcp_fin_timeout = 15

# Enable BBR congestion control
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
EOF

    sudo sysctl --system
}

main() {
    tune_sysctl
    echo "==> Network performance tweaks applied."
    echo "==> You can verify BBR with: sysctl net.ipv4.tcp_congestion_control"
}

main "$@"
