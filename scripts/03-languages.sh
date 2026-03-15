#!/usr/bin/env bash
# 03-languages.sh — nvm (Node), pyenv (Python), SDKMAN (Java/Scala), Go, Rust

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/scripts/lib/log.sh"
source "$SCRIPT_DIR/scripts/lib/check.sh"

log_section "Language Runtimes"

# --- Node.js via nvm ---
log_step 1 "Node.js via nvm"
if [[ -d "$HOME/.nvm" ]]; then
  log_success "nvm already installed"
else
  log_info "Installing nvm..."
  if [[ "$DRY_RUN" != "true" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  fi
fi

if [[ "$DRY_RUN" != "true" ]]; then
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

  if command_exists nvm; then
    CURRENT_NODE=$(nvm current 2>/dev/null || echo "none")
    if [[ "$CURRENT_NODE" == "none" || "$CURRENT_NODE" == "system" ]]; then
      log_info "Installing Node LTS..."
      nvm install --lts
      nvm use --lts
      nvm alias default "lts/*"
    else
      log_success "Node already active: $CURRENT_NODE"
    fi
  fi
fi

# --- Python via pyenv ---
log_step 2 "Python via pyenv"
if command_exists pyenv; then
  log_success "pyenv already installed: $(pyenv --version)"
else
  log_info "Installing pyenv..."
  if [[ "$DRY_RUN" != "true" ]]; then
    brew install pyenv
  fi
fi

if [[ "$DRY_RUN" != "true" ]] && command_exists pyenv; then
  LATEST_PYTHON=$(pyenv install --list | grep -E '^\s+3\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
  if pyenv versions | grep -q "$LATEST_PYTHON"; then
    log_success "Python $LATEST_PYTHON already installed"
  else
    log_info "Installing Python $LATEST_PYTHON..."
    pyenv install "$LATEST_PYTHON"
    pyenv global "$LATEST_PYTHON"
  fi
fi

# --- Java + Scala via SDKMAN ---
log_step 3 "Java + Scala via SDKMAN"
if [[ -d "$HOME/.sdkman" ]]; then
  log_success "SDKMAN already installed"
else
  log_info "Installing SDKMAN..."
  if [[ "$DRY_RUN" != "true" ]]; then
    curl -s "https://get.sdkman.io" | bash
  fi
fi

if [[ "$DRY_RUN" != "true" ]] && [[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  # shellcheck source=/dev/null
  source "$HOME/.sdkman/bin/sdkman-init.sh"

  # Java LTS (21) — check if already installed (not just available)
  if sdk list java | grep "21.0.3-tem" | grep -q "installed"; then
    log_success "Java 21 already installed"
  else
    log_info "Installing Java 21 (LTS)..."
    sdk install java 21.0.3-tem || true
  fi

  # Scala
  if ! command_exists scala; then
    log_info "Installing Scala..."
    sdk install scala || true
  else
    log_success "Scala already installed: $(scala --version 2>&1)"
  fi
fi

# --- Go ---
log_step 4 "Go"
if command_exists go; then
  log_success "Go already installed: $(go version)"
else
  log_info "Installing Go..."
  [[ "$DRY_RUN" != "true" ]] && brew install go
fi

# --- Rust via rustup ---
log_step 5 "Rust via rustup"
if command_exists rustc; then
  log_success "Rust already installed: $(rustc --version)"
else
  log_info "Installing Rust via rustup..."
  if [[ "$DRY_RUN" != "true" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # shellcheck source=/dev/null
    source "$HOME/.cargo/env"
  fi
fi

log_success "Language runtimes setup complete"
