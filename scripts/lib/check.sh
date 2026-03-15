#!/usr/bin/env bash
# check.sh — Idempotency and environment check helpers

# Returns 0 if a command exists in PATH
command_exists() {
  command -v "$1" &>/dev/null
}

# Returns 0 if running on macOS
is_macos() {
  [[ "$(uname)" == "Darwin" ]]
}

# Returns 0 if running on Apple Silicon
is_arm() {
  [[ "$(uname -m)" == "arm64" ]]
}

# Returns 0 if a Homebrew formula or cask is installed
brew_installed() {
  brew list --formula "$1" &>/dev/null || brew list --cask "$1" &>/dev/null
}

# Returns 0 if a file or directory exists
path_exists() {
  [[ -e "$1" ]]
}

# Require macOS — exit with message if not
require_macos() {
  if ! is_macos; then
    echo "ERROR: This script requires macOS." >&2
    exit 1
  fi
}
