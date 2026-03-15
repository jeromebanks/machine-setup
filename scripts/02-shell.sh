#!/usr/bin/env bash
# 02-shell.sh — Zsh, Oh My Zsh, iTerm2, tmux, Neovim, Starship

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/scripts/lib/log.sh"
source "$SCRIPT_DIR/scripts/lib/check.sh"

log_section "Shell Setup"

# --- Zsh ---
log_step 1 "Zsh"
if command_exists zsh; then
  log_success "zsh already installed: $(zsh --version)"
else
  log_info "Installing zsh via Homebrew..."
  [[ "$DRY_RUN" != "true" ]] && brew install zsh
fi

# Set zsh as default shell if not already
if [[ "$SHELL" != *"zsh" ]]; then
  log_info "Setting zsh as default shell..."
  if [[ "$DRY_RUN" != "true" ]]; then
    ZSH_PATH="$(command -v zsh)"
    if ! grep -q "$ZSH_PATH" /etc/shells; then
      echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi
    chsh -s "$ZSH_PATH"
  fi
fi

# --- Oh My Zsh ---
log_step 2 "Oh My Zsh"
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  log_success "Oh My Zsh already installed"
else
  log_info "Installing Oh My Zsh..."
  if [[ "$DRY_RUN" != "true" ]]; then
    RUNZSH=no CHSH=no sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
fi

# --- Oh My Zsh plugins ---
log_step 3 "Oh My Zsh plugins (zsh-autosuggestions, zsh-syntax-highlighting)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  dest="$ZSH_CUSTOM/plugins/$plugin"
  if [[ -d "$dest" ]]; then
    log_success "$plugin already installed"
  else
    log_info "Installing $plugin..."
    if [[ "$DRY_RUN" != "true" ]]; then
      case "$plugin" in
        zsh-autosuggestions)
          git clone https://github.com/zsh-users/zsh-autosuggestions "$dest" ;;
        zsh-syntax-highlighting)
          git clone https://github.com/zsh-users/zsh-syntax-highlighting "$dest" ;;
      esac
    fi
  fi
done

# --- Starship prompt ---
log_step 4 "Starship prompt"
if command_exists starship; then
  log_success "Starship already installed: $(starship --version)"
else
  log_info "Installing Starship..."
  [[ "$DRY_RUN" != "true" ]] && brew install starship
fi

# --- tmux ---
log_step 5 "tmux"
if command_exists tmux; then
  log_success "tmux already installed: $(tmux -V)"
else
  log_info "Installing tmux..."
  [[ "$DRY_RUN" != "true" ]] && brew install tmux
fi

# --- Neovim ---
log_step 6 "Neovim"
if command_exists nvim; then
  log_success "Neovim already installed: $(nvim --version | head -1)"
else
  log_info "Installing Neovim..."
  [[ "$DRY_RUN" != "true" ]] && brew install neovim
fi

# --- iTerm2 ---
log_step 7 "iTerm2"
if brew_installed iterm2; then
  log_success "iTerm2 already installed"
else
  log_info "Installing iTerm2..."
  [[ "$DRY_RUN" != "true" ]] && brew install --cask iterm2
fi

log_success "Shell setup complete"
