#!/usr/bin/env bash
# chromebook-setup.sh — Set up ChromeOS Linux (Crostini) as a client for remote Mac access
# Run inside the Linux terminal on your Chromebook

set -euo pipefail

REPO_OWNER="jeromebanks"  # Update before sharing
MAC_TAILSCALE_HOST="${MAC_TAILSCALE_HOST:-}"  # Set or prompted below

log() { echo "[$(date '+%H:%M:%S')] $*"; }
ok()  { echo "[OK] $*"; }
err() { echo "[ERROR] $*" >&2; }

# Must be Debian/Ubuntu
if ! command -v apt-get &>/dev/null; then
  err "This script requires a Debian/Ubuntu system (ChromeOS Linux / Crostini)."
  exit 1
fi

log "=== Chromebook Client Setup ==="

# --- System update ---
log "Updating package list..."
sudo apt-get update -qq

# --- Tailscale ---
log "Installing Tailscale..."
if command -v tailscale &>/dev/null; then
  ok "Tailscale already installed"
else
  curl -fsSL https://tailscale.com/install.sh | sh
fi
# Connect (user will be prompted to authenticate in browser)
if ! tailscale status &>/dev/null; then
  log "Starting Tailscale (follow browser prompt to authenticate)..."
  sudo tailscale up
fi

# --- SSH keypair ---
log "SSH keypair setup"
if [[ -f "$HOME/.ssh/id_ed25519" ]]; then
  ok "SSH key already exists: $HOME/.ssh/id_ed25519"
else
  ssh-keygen -t ed25519 -C "chromebook-$(hostname)" -f "$HOME/.ssh/id_ed25519" -N ""
  ok "SSH key generated"
fi

echo ""
echo "=== Your public key (add this to your Mac's authorized_keys) ==="
cat "$HOME/.ssh/id_ed25519.pub"
echo "================================================================="
echo ""
echo "On your Mac, run: ./bootstrap.sh --only remote"
echo "and choose 'Add an authorized public key', then paste the key above."
echo ""
read -r -p "Press Enter once you have added the key to your Mac..."

# --- Get Mac Tailscale hostname ---
if [[ -z "$MAC_TAILSCALE_HOST" ]]; then
  read -r -p "Enter your Mac's Tailscale hostname (e.g. mac-mini.tail12345.ts.net): " MAC_TAILSCALE_HOST
fi

# --- SSH config ---
log "Writing ~/.ssh/config entry"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
touch "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"

if grep -q "Host mac" "$HOME/.ssh/config" 2>/dev/null; then
  ok "SSH config entry for 'mac' already exists"
else
  cat >> "$HOME/.ssh/config" <<EOF

Host mac
  HostName $MAC_TAILSCALE_HOST
  User $(whoami)
  IdentityFile ~/.ssh/id_ed25519
  ServerAliveInterval 60
EOF
  ok "SSH config written — connect with: ssh mac"
fi

# --- VNC viewer ---
log "Installing TigerVNC viewer"
if command -v vncviewer &>/dev/null; then
  ok "TigerVNC viewer already installed"
else
  sudo apt-get install -y -qq tigervnc-viewer
fi

# --- Optional: Claude Code + OpenAI Codex ---
if command -v node &>/dev/null; then
  read -r -p "Install Claude Code and OpenAI Codex CLI on this Chromebook? [y/N] " install_ai
  if [[ "${install_ai,,}" == "y" ]]; then
    npm install -g @anthropic-ai/claude-code @openai/codex
    ok "AI CLI tools installed"
  fi
else
  log "Node.js not found — skipping AI CLI tools (install nvm first if you want them)"
fi

echo ""
echo "=== Setup Complete ==="
echo "Connect via SSH:  ssh mac"
echo "Connect via VNC:  vncviewer $MAC_TAILSCALE_HOST:5900"
echo ""
