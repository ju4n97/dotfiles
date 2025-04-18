#!/usr/bin/env bash

# Check if BBR is already enabled
if grep -q "tcp_bbr" /etc/modules-load.d/modules.conf; then
    echo "BBR module already configured to load at boot"
else
    echo "tcp_bbr" | sudo tee -a /etc/modules-load.d/modules.conf
fi

# Load the BBR module now
sudo modprobe tcp_bbr

# Configure sysctl parameters for BBR
cat <<EOF | sudo tee /etc/sysctl.d/99-network-performance.conf
# Enable BBR TCP congestion control
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

# Increase the maximum TCP buffer sizes
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864

# Enable TCP Fast Open
net.ipv4.tcp_fastopen = 3

# Disable TCP slow start after idle
net.ipv4.tcp_slow_start_after_idle = 0
EOF

# Apply the new sysctl settings
sudo sysctl --system

echo "TCP BBR configuration applied. To revert, remove the created files and reboot."
echo "Created files:"
echo "- /etc/sysctl.d/99-network-performance.conf"
echo "- Check entry in /etc/modules-load.d/modules.conf"
