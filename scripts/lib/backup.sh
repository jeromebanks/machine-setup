#!/usr/bin/env bash
# backup.sh — Snapshot files before modification

BACKUP_ENABLED="${BACKUP_ENABLED:-true}"

# Backs up a single file to BACKUP_ROOT, preserving relative path from HOME
# BACKUP_ROOT resolved lazily inside the function to avoid git rev-parse at source time
# Usage: backup_file /path/to/file
backup_file() {
  local src="$1"

  if [[ "$BACKUP_ENABLED" == "false" ]]; then
    return 0
  fi

  if [[ ! -e "$src" ]]; then
    echo "backup_file: source not found: $src" >&2
    return 1
  fi

  # Resolve BACKUP_ROOT lazily inside the function
  if [[ -z "${BACKUP_ROOT:-}" ]]; then
    local repo_root
    repo_root="$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")"
    BACKUP_ROOT="$repo_root/backups/$(date '+%Y-%m-%d-%H-%M')"
  fi

  # Preserve path relative to HOME (or use basename for absolute paths)
  local rel
  if [[ "$src" == "$HOME"* ]]; then
    rel="${src#$HOME/}"
  else
    rel="$(basename "$src")"
  fi

  local dest="$BACKUP_ROOT/$rel"
  mkdir -p "$(dirname "$dest")"
  cp -a "$src" "$dest"
}

# Backs up multiple files
# Usage: backup_files file1 file2 ...
backup_files() {
  for f in "$@"; do
    backup_file "$f"
  done
}
