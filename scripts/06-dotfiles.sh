#!/usr/bin/env bash
# 06-dotfiles.sh — Install chezmoi and apply dotfiles from this repo

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/scripts/lib/log.sh"
source "$SCRIPT_DIR/scripts/lib/check.sh"
source "$SCRIPT_DIR/scripts/lib/backup.sh"
source "$SCRIPT_DIR/scripts/lib/prompt.sh"

log_section "Dotfiles (chezmoi)"

# --- Install chezmoi ---
log_step 1 "chezmoi"
if command_exists chezmoi; then
  log_success "chezmoi already installed: $(chezmoi --version)"
else
  log_info "Installing chezmoi..."
  [[ "$DRY_RUN" != "true" ]] && brew install chezmoi
fi

if [[ "$DRY_RUN" == "true" ]]; then
  log_info "[DRY RUN] Would run: chezmoi init --source=$SCRIPT_DIR/dotfiles"
  log_info "[DRY RUN] Would run: chezmoi apply --dry-run"
  exit 0
fi

# --- Backup existing dotfiles ---
log_step 2 "Backup existing dotfiles"
DOTFILES_TO_BACKUP=("$HOME/.zshrc" "$HOME/.gitconfig")
for f in "${DOTFILES_TO_BACKUP[@]}"; do
  [[ -f "$f" ]] && backup_file "$f" && log_success "Backed up: $f"
done

# --- Init chezmoi with this repo's dotfiles directory ---
log_step 3 "chezmoi init"
CHEZMOI_SOURCE="$SCRIPT_DIR/dotfiles"
chezmoi init --source="$CHEZMOI_SOURCE"

# --- Show diff before applying ---
log_step 4 "chezmoi diff"
chezmoi diff || true

if prompt_yn "Apply these dotfile changes?" "y"; then
  log_step 5 "chezmoi apply"
  chezmoi apply
  log_success "Dotfiles applied"
else
  log_warn "Dotfiles skipped — run 'chezmoi apply' manually when ready"
fi

log_success "Dotfiles setup complete"
