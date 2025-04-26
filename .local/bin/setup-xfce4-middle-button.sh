#!/usr/bin/env bash
set -euo pipefail

echo "==> Creating X11 middle mouse emulation config..."
sudo mkdir -p /etc/X11/xorg.conf.d
cat <<EOF | sudo tee /etc/X11/xorg.conf.d/middle-mouse-button.conf
Section "InputClass"
   Identifier "middle button"
   MatchIsPointer "on"
   MatchDriver "libinput"
   Option "MiddleEmulation" "on"
EndSection
EOF
echo "==> Config created at /etc/X11/xorg.conf.d/middle-mouse-button.conf"
echo "==> Reboot to apply changes"
