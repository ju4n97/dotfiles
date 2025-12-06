#!/usr/bin/env bash
set -euo pipefail

map_wacom_devices() {
  echo "==> Mapping Wacom devices to primary monitor..."

  monitor=$(xrandr | awk '/ primary / {print $1}') || {
    echo "No primary monitor detected."
    exit 1
  }

  readarray -t devices < <(xsetwacom list devices | awk -F'\t' '{gsub(/[ \t]+$/, "", $1); print $1}')

  for device in "${devices[@]}"; do
    xsetwacom set "$device" MapToOutput "$monitor"
  done

  echo "==> Wacom devices mapped to $monitor."
}

enable_wacom_service() {
  if systemctl --user is-enabled wacom-mapping.service &>/dev/null; then
    echo "==> Wacom mapping service already enabled."
    return
  fi

  echo "==> Enabling Wacom mapping service..."
  systemctl --user daemon-reload
  systemctl --user enable --now wacom-mapping.service
  echo "==> Wacom mapping service enabled."
}

main() {
  map_wacom_devices
  enable_wacom_service
  echo "==> Wacom mapping setup complete and persistent across reboots."
}

main "$@"
