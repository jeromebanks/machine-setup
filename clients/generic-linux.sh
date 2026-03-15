#!/usr/bin/env bash
# generic-linux.sh — Set up any Debian/Ubuntu Linux machine as a remote client
# For friends or other dev machines

set -euo pipefail

if ! command -v apt-get &>/dev/null; then
  echo "ERROR: Requires Debian/Ubuntu (apt-get)." >&2
  exit 1
fi

echo "=== Generic Linux Client Setup ==="

sudo apt-get update -qq

# Tailscale
if ! command -v tailscale &>/dev/null; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi
sudo tailscale up

# SSH key
if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  ssh-keygen -t ed25519 -C "$(hostname)" -f "$HOME/.ssh/id_ed25519" -N ""
fi
echo "Your public key:"
cat "$HOME/.ssh/id_ed25519.pub"

read -r -p "Mac Tailscale hostname: " MAC_HOST
read -r -p "Mac username: " MAC_USER

mkdir -p ~/.ssh && chmod 700 ~/.ssh
touch ~/.ssh/config && chmod 600 ~/.ssh/config

if grep -q "Host mac" ~/.ssh/config 2>/dev/null; then
  echo "[OK] SSH config entry for 'mac' already exists"
else
  cat >> ~/.ssh/config <<EOF

Host mac
  HostName $MAC_HOST
  User $MAC_USER
  IdentityFile ~/.ssh/id_ed25519
EOF
  echo "[OK] SSH config written — connect with: ssh mac"
fi

sudo apt-get install -y -qq tigervnc-viewer

echo "Done. Connect with: ssh mac"
