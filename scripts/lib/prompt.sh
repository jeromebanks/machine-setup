#!/usr/bin/env bash
# prompt.sh — Interactive prompts for user input

# Yes/no prompt. Returns 0 for yes, 1 for no.
# Usage: prompt_yn "Question?" [default: y|n]
prompt_yn() {
  local question="$1"
  local default="${2:-n}"
  local hint

  if [[ "$default" == "y" ]]; then
    hint="[Y/n]"
  else
    hint="[y/N]"
  fi

  local answer
  printf "%s %s " "$question" "$hint" >&2
  read -r answer
  answer="${answer:-$default}"

  [[ "$(echo "$answer" | tr '[:upper:]' '[:lower:]')" == "y" ]]
}

# Text prompt. Echoes the entered value to stdout.
# Usage: value=$(prompt_text "Label:")
prompt_text() {
  local label="$1"
  local value
  printf "%s " "$label" >&2
  read -r value
  echo "$value"
}

# Secret prompt (no echo). Writes value to stdout.
# Usage: secret=$(prompt_secret "API Key:")
prompt_secret() {
  local label="$1"
  local value
  printf "%s " "$label" >&2
  read -r -s value
  printf "\n" >&2  # newline after hidden input
  echo "$value"
}
