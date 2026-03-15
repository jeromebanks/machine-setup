#!/usr/bin/env bash
# bootstrap.sh — Mac development setup entry point
# Usage: ./bootstrap.sh [--only <module>] [--skip <module>] [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/lib/log.sh"
source "$SCRIPT_DIR/scripts/lib/check.sh"

require_macos

# --- Argument parsing ---
DRY_RUN=false
ONLY=""
SKIP=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --only)    ONLY="$2"; shift ;;
    --skip)    SKIP="$2"; shift ;;
    --help|-h)
      echo "Usage: ./bootstrap.sh [--only <module>] [--skip <module>] [--dry-run]"
      echo ""
      echo "Modules: system, shell, languages, dev, ai, dotfiles, remote, claude"
      exit 0
      ;;
    *) log_warn "Unknown flag: $1" ;;
  esac
  shift
done

export DRY_RUN SCRIPT_DIR

# --- Module map: name -> script ---
get_module_script() {
  case "$1" in
    system)    echo "01-system.sh" ;;
    shell)     echo "02-shell.sh" ;;
    languages) echo "03-languages.sh" ;;
    dev)       echo "04-dev-tools.sh" ;;
    ai)        echo "05-ai-tools.sh" ;;
    dotfiles)  echo "06-dotfiles.sh" ;;
    remote)    echo "07-remote-access.sh" ;;
    claude)    echo "08-claude-ecosystem.sh" ;;
    *)         echo "" ;;
  esac
}

ORDERED_MODULES=(system shell languages dev ai dotfiles remote claude)

# --- Run ---
run_module() {
  local name="$1"
  local file
  file="$(get_module_script "$name")"

  if [[ -z "$file" ]]; then
    log_warn "Unknown module: $name"
    return
  fi

  local path="$SCRIPT_DIR/scripts/$file"

  if [[ ! -f "$path" ]]; then
    log_warn "Module script not found: $path — skipping"
    return
  fi

  log_section "Module: $name ($file)"

  if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY RUN] Would run: $path"
    return
  fi

  bash "$path"
}

log_section "Mac Setup Bootstrap"
log_info "DRY_RUN=$DRY_RUN  ONLY='$ONLY'  SKIP='$SKIP'"

for module in "${ORDERED_MODULES[@]}"; do
  if [[ -n "$ONLY" && "$ONLY" != "$module" ]]; then
    continue
  fi
  if [[ -n "$SKIP" && "$SKIP" == "$module" ]]; then
    log_info "Skipping: $module"
    continue
  fi
  run_module "$module"
done

log_success "Bootstrap complete."
