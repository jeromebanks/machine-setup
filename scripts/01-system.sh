#!/usr/bin/env bash
# 01-system.sh — Xcode CLI tools, Homebrew, macOS system preferences

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/scripts/lib/log.sh"
source "$SCRIPT_DIR/scripts/lib/check.sh"
source "$SCRIPT_DIR/scripts/lib/backup.sh"

require_macos

log_section "System Setup"

# --- Xcode CLI Tools ---
log_step 1 "Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
  log_success "Xcode CLI tools already installed"
else
  log_info "Installing Xcode CLI tools..."
  if [[ "$DRY_RUN" != "true" ]]; then
    xcode-select --install
    log_info "Follow the dialog to complete installation, then re-run bootstrap."
    exit 0
  fi
fi

# --- Homebrew ---
log_step 2 "Homebrew"
if command_exists brew; then
  log_success "Homebrew already installed — updating"
  [[ "$DRY_RUN" != "true" ]] && brew update
else
  log_info "Installing Homebrew..."
  if [[ "$DRY_RUN" != "true" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add Homebrew to PATH for Apple Silicon
    if is_arm; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
fi

# --- Brewfile ---
log_step 3 "Brew bundle (Brewfile)"
if [[ "$DRY_RUN" != "true" ]]; then
  # Refresh sudo credential immediately before bundle so pkg-based casks
  # (e.g. Docker Desktop) don't prompt mid-install.
  sudo -v 2>/dev/null || true
  brew bundle --file="$SCRIPT_DIR/Brewfile"
fi

# --- macOS System Preferences ---
log_step 4 "macOS system preferences"
if [[ "$DRY_RUN" != "true" ]]; then
  # Key repeat: fast
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15

  # Finder: show hidden files, path bar, status bar
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Dock: auto-hide, minimize to app icon
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock minimize-to-application -bool true

  # Screenshots: save to ~/Desktop/Screenshots
  mkdir -p "$HOME/Desktop/Screenshots"
  defaults write com.apple.screencapture location "$HOME/Desktop/Screenshots"

  log_success "System preferences applied"
fi

log_success "System setup complete"
