#!/usr/bin/env bash
# claude-remote.sh — Run Claude Code on the Mac Mini from any remote client
#
# Connects via SSH and launches Claude Code inside a persistent tmux session.
# If a session is already running (e.g. after a dropped connection), reattaches.
#
# Usage:
#   claude-remote.sh [ssh-host] [claude args...]
#
# Examples:
#   claude-remote.sh                        # connect to 'mac' (default), start claude
#   claude-remote.sh mac                    # explicit host
#   claude-remote.sh mac --continue         # resume last claude session
#   claude-remote.sh mac "fix this bug"     # pass a prompt
#
# Install as a command:
#   sudo install -m 755 claude-remote.sh /usr/local/bin/claude-mac

set -euo pipefail

SSH_HOST="${1:-mac}"
shift 2>/dev/null || true   # remaining args passed to claude
CLAUDE_ARGS="${*:-}"

TMUX_SESSION="claude"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

info()    { echo -e "${BLUE}[claude-remote]${RESET} $*"; }
success() { echo -e "${GREEN}[claude-remote]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[claude-remote]${RESET} $*"; }

# --- Check SSH host is reachable ---
info "Connecting to $SSH_HOST..."
if ! ssh -q -o ConnectTimeout=5 -o BatchMode=yes "$SSH_HOST" exit 2>/dev/null; then
  echo ""
  echo "Cannot reach '$SSH_HOST'. Check:"
  echo "  1. Tailscale is running on both devices: tailscale status"
  echo "  2. SSH is configured: cat ~/.ssh/config | grep -A4 'Host $SSH_HOST'"
  echo "  3. Your key is authorized on the Mac"
  exit 1
fi

# --- Build the remote command ---
# On the Mac: check if tmux session exists, attach or create
REMOTE_CMD=$(cat <<REMOTE
  # Ensure tmux is available
  if ! command -v tmux &>/dev/null; then
    echo "tmux not found on Mac — install it: brew install tmux"
    exit 1
  fi

  # Ensure claude is available
  if ! command -v claude &>/dev/null; then
    # Try sourcing nvm in case claude is installed via npm
    export NVM_DIR="\$HOME/.nvm"
    [ -s "\$NVM_DIR/nvm.sh" ] && source "\$NVM_DIR/nvm.sh"
  fi

  if ! command -v claude &>/dev/null; then
    echo "Claude Code not found on Mac — run: npm install -g @anthropic-ai/claude-code"
    exit 1
  fi

  CLAUDE_CMD="claude ${CLAUDE_ARGS}"

  if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
    echo "[claude-remote] Reattaching to existing tmux session '$TMUX_SESSION'..."
    tmux attach-session -t "$TMUX_SESSION"
  else
    echo "[claude-remote] Starting new tmux session '$TMUX_SESSION'..."
    tmux new-session -s "$TMUX_SESSION" "\$CLAUDE_CMD; exec \$SHELL"
  fi
REMOTE
)

# --- Connect ---
success "Launching Claude Code on $SSH_HOST (tmux session: $TMUX_SESSION)"
warn "Tip: if connection drops, re-run this script to reattach — your session keeps running"
echo ""

ssh -t "$SSH_HOST" "$REMOTE_CMD"
