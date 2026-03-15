# Claude Code

AI coding assistant from Anthropic.

**Install:** `npm install -g @anthropic-ai/claude-code`
**Config:** `~/.claude/` — settings, plugins, skills, MCP servers
**API key:** Set `ANTHROPIC_API_KEY` in `~/.zshrc.local`
**Plugins:** Install via `/plugin` command in Claude Code, or run `08-claude-ecosystem.sh`
**MCP servers:** Configured in `config/claude/mcp-servers.json`, installed by `08-claude-ecosystem.sh`
**Skills:** Stored in `~/.claude/skills/`, installed from `skills/` by `08-claude-ecosystem.sh`

**Key commands:**
- `claude` — start a session
- `/plugin` — install plugins
- `/help` — list commands
