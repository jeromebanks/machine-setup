#!/usr/bin/env bash
# 08-claude-ecosystem.sh — MCP servers, Claude Code plugins, skills

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/scripts/lib/log.sh"
source "$SCRIPT_DIR/scripts/lib/check.sh"
source "$SCRIPT_DIR/scripts/lib/prompt.sh"

log_section "Claude Ecosystem"

CONFIG_DIR="$SCRIPT_DIR/config/claude"
SKILLS_DEST="$HOME/.claude/skills"
CLAUDE_SKILLS_SRC="$SCRIPT_DIR/skills"

# --- Dependency checks ---
if ! command_exists jq; then
  log_error "jq not found. Run 01-system.sh (brew bundle) first."
  exit 1
fi

# --- Claude Code check ---
if ! command_exists claude; then
  log_error "Claude Code not found. Run 05-ai-tools.sh first."
  exit 1
fi

# --- Load Node (for npx) ---
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

# --- MCP Servers ---
log_step 1 "MCP Servers"
if [[ "$DRY_RUN" == "true" ]]; then
  log_info "[DRY RUN] Would install MCP servers from $CONFIG_DIR/mcp-servers.json"
else
  SERVER_NAMES=$(jq -r '.servers[].name' "$CONFIG_DIR/mcp-servers.json")
  while IFS= read -r name; do
    PACKAGE=$(jq -r --arg n "$name" '.servers[] | select(.name==$n) | .package' "$CONFIG_DIR/mcp-servers.json")
    if claude mcp list 2>/dev/null | grep -q "^$name"; then
      log_success "MCP server already installed: $name"
    else
      log_info "Installing MCP server: $name ($PACKAGE)"
      claude mcp add "$name" "npx" "-y" "$PACKAGE" 2>/dev/null || \
        log_warn "Failed to install MCP server: $name — install manually"
    fi
  done <<< "$SERVER_NAMES"
fi

# --- Claude Code Plugins ---
log_step 2 "Claude Code Plugins"
if [[ "$DRY_RUN" == "true" ]]; then
  log_info "[DRY RUN] Would install plugins from $CONFIG_DIR/plugins.json"
else
  PLUGIN_NAMES=$(jq -r '.plugins[].name' "$CONFIG_DIR/plugins.json")
  while IFS= read -r plugin; do
    if claude plugin list 2>/dev/null | grep -q "^$plugin"; then
      log_success "Plugin already installed: $plugin"
    else
      log_info "Installing plugin: $plugin"
      claude plugin install "$plugin" 2>/dev/null || \
        log_warn "Plugin install failed: $plugin — install manually via /plugin"
    fi
  done <<< "$PLUGIN_NAMES"
fi

# --- Claude Skills ---
log_step 3 "Claude Skills (from skills/ directory)"
if [[ "$DRY_RUN" == "true" ]]; then
  log_info "[DRY RUN] Would copy skills to $SKILLS_DEST"
else
  mkdir -p "$SKILLS_DEST"
  for skill_file in "$CLAUDE_SKILLS_SRC"/*.md; do
    [[ -f "$skill_file" ]] || continue
    dest="$SKILLS_DEST/$(basename "$skill_file")"
    cp "$skill_file" "$dest"
    log_success "Installed skill: $(basename "$skill_file")"
  done
fi

log_success "Claude ecosystem setup complete"
log_info "Plugins requiring manual steps:"
log_info "  - greptile: requires GREPTILE_API_KEY in ~/.zshrc.local"
log_info "  - web-search: requires BRAVE_API_KEY in ~/.zshrc.local"
log_info "  - supabase: requires SUPABASE_ACCESS_TOKEN in ~/.zshrc.local"
