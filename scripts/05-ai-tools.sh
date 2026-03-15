#!/usr/bin/env bash
# 05-ai-tools.sh — Claude Code, OpenAI Codex CLI, Cursor, GitHub Copilot

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/scripts/lib/log.sh"
source "$SCRIPT_DIR/scripts/lib/check.sh"
source "$SCRIPT_DIR/scripts/lib/prompt.sh"

log_section "AI Coding Tools"

ZSHRC_LOCAL="$HOME/.zshrc.local"

# Ensure ~/.zshrc.local exists — skip in dry-run
if [[ "$DRY_RUN" != "true" ]]; then
  touch "$ZSHRC_LOCAL"
  chmod 600 "$ZSHRC_LOCAL"
fi

write_api_key() {
  local var_name="$1"
  local description="$2"

  if grep -q "^export $var_name=" "$ZSHRC_LOCAL" 2>/dev/null; then
    log_success "$var_name already set in ~/.zshrc.local"
    return
  fi

  if prompt_yn "Set $description API key now?"; then
    local key
    key=$(prompt_secret "$description API key:")
    echo "export $var_name=\"$key\"" >> "$ZSHRC_LOCAL"
    log_success "$var_name written to ~/.zshrc.local"
  else
    log_warn "Skipped $var_name — add manually to ~/.zshrc.local later"
  fi
}

# --- Node.js check (required for npm installs) ---
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

if ! command_exists node; then
  if [[ "$DRY_RUN" == "true" ]]; then
    log_warn "[DRY RUN] Node.js not found — would fail at runtime. Run 03-languages.sh first."
  else
    log_error "Node.js not found. Run 03-languages.sh first."
    exit 1
  fi
fi

# --- Claude Code ---
log_step 1 "Claude Code"
if command_exists claude; then
  log_success "Claude Code already installed: $(claude --version 2>/dev/null || echo 'installed')"
else
  log_info "Installing Claude Code..."
  [[ "$DRY_RUN" != "true" ]] && npm install -g @anthropic-ai/claude-code
fi

if [[ "$DRY_RUN" != "true" ]]; then
  write_api_key "ANTHROPIC_API_KEY" "Anthropic (Claude)"
fi

# --- OpenAI Codex CLI ---
log_step 2 "OpenAI Codex CLI"
if command_exists codex; then
  log_success "OpenAI Codex CLI already installed"
else
  log_info "Installing OpenAI Codex CLI..."
  [[ "$DRY_RUN" != "true" ]] && npm install -g @openai/codex
fi

if [[ "$DRY_RUN" != "true" ]]; then
  write_api_key "OPENAI_API_KEY" "OpenAI"
fi

# --- Cursor ---
log_step 3 "Cursor"
if brew_installed cursor; then
  log_success "Cursor already installed"
else
  log_info "Installing Cursor..."
  [[ "$DRY_RUN" != "true" ]] && brew install --cask cursor
fi

# --- GitHub Copilot CLI ---
log_step 4 "GitHub Copilot CLI"
if command_exists gh && gh extension list 2>/dev/null | grep -q "copilot"; then
  log_success "GitHub Copilot CLI already installed"
else
  log_info "Installing GitHub Copilot CLI extension..."
  if [[ "$DRY_RUN" != "true" ]]; then
    gh extension install github/gh-copilot 2>/dev/null || log_warn "gh copilot install failed — may need gh auth first"
  fi
fi

log_success "AI tools setup complete"
log_info "Secrets written to: ~/.zshrc.local (never commit this file)"
