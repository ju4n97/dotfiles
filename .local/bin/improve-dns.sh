#!/usr/bin/env bash

# Backup current resolv.conf
sudo cp /etc/resolv.conf /etc/resolv.conf.backup

# Set up faster DNS servers
echo "nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 8.8.8.8
options timeout:1" | sudo tee /etc/resolv.conf

# Make it immutable to prevent overwriting
sudo chattr +i /etc/resolv.conf

echo "DNS settings updated to use Cloudflare and Google DNS"
echo "To restore original settings: sudo chattr -i /etc/resolv.conf && sudo cp /etc/resolv.conf.backup /etc/resolv.conf"
