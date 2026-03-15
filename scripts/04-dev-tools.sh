#!/usr/bin/env bash
# 04-dev-tools.sh — Git config, GitHub CLI, Docker, VS Code + extensions

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/scripts/lib/log.sh"
source "$SCRIPT_DIR/scripts/lib/check.sh"
source "$SCRIPT_DIR/scripts/lib/prompt.sh"

log_section "Dev Tools"

# --- Git ---
log_step 1 "Git"
if command_exists git; then
  log_success "Git already installed: $(git --version)"
else
  log_info "Installing Git..."
  [[ "$DRY_RUN" != "true" ]] && brew install git
fi

# Git identity (if not already configured)
if [[ "$DRY_RUN" != "true" ]]; then
  CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
  CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

  if [[ -z "$CURRENT_NAME" ]]; then
    GIT_NAME=$(prompt_text "Git user name:")
    git config --global user.name "$GIT_NAME"
  else
    log_success "Git name already set: $CURRENT_NAME"
  fi

  if [[ -z "$CURRENT_EMAIL" ]]; then
    GIT_EMAIL=$(prompt_text "Git email:")
    git config --global user.email "$GIT_EMAIL"
  else
    log_success "Git email already set: $CURRENT_EMAIL"
  fi

  # Sensible git defaults
  git config --global init.defaultBranch main
  git config --global pull.rebase false
  git config --global core.editor nvim
fi

# --- GitHub CLI ---
log_step 2 "GitHub CLI"
if command_exists gh; then
  log_success "gh already installed: $(gh --version | head -1)"
else
  log_info "Installing GitHub CLI..."
  [[ "$DRY_RUN" != "true" ]] && brew install gh
fi

if [[ "$DRY_RUN" != "true" ]] && ! gh auth status &>/dev/null; then
  log_info "Authenticating with GitHub (browser will open)..."
  gh auth login
fi

# --- Docker ---
log_step 3 "Docker Desktop"
if brew_installed docker; then
  log_success "Docker Desktop already installed"
else
  log_info "Installing Docker Desktop..."
  [[ "$DRY_RUN" != "true" ]] && brew install --cask docker
fi

# --- VS Code ---
log_step 4 "VS Code"
if command_exists code; then
  log_success "VS Code already installed"
else
  log_info "Installing VS Code..."
  [[ "$DRY_RUN" != "true" ]] && brew install --cask visual-studio-code
fi

# VS Code extensions
if [[ "$DRY_RUN" != "true" ]] && command_exists code; then
  EXTENSIONS=(
    "ms-vscode-remote.remote-ssh"
    "ms-vscode-remote.remote-containers"
    "GitHub.copilot"
    "GitHub.copilot-chat"
    "eamodio.gitlens"
    "esbenp.prettier-vscode"
    "dbaeumer.vscode-eslint"
    "ms-python.python"
    "golang.go"
    "rust-lang.rust-analyzer"
    "scalameta.metals"
  )
  log_step 5 "VS Code extensions"
  for ext in "${EXTENSIONS[@]}"; do
    if code --list-extensions | grep -qi "$ext"; then
      log_success "Extension already installed: $ext"
    else
      log_info "Installing extension: $ext"
      code --install-extension "$ext" --force
    fi
  done
fi

log_success "Dev tools setup complete"
