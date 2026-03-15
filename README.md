# machine-setup

Semi-automated Mac development setup. Covers AI coding tools (Claude Code, OpenAI Codex, Cursor), languages (Node, Python, Java, Scala, Go, Rust), remote access (SSH, VNC, Tailscale), and the full Claude ecosystem (MCP servers, plugins, skills).

## Quick Start

### New Mac

```bash
git clone https://github.com/YOUR_USERNAME/machine-setup.git ~/dev/machine-setup
cd ~/dev/machine-setup
chmod +x bootstrap.sh
./bootstrap.sh
```

### Specific module only

```bash
./bootstrap.sh --only ai        # AI coding tools only
./bootstrap.sh --only remote    # Remote access only
./bootstrap.sh --skip dotfiles  # Everything except dotfiles
./bootstrap.sh --dry-run        # Preview without making changes
```

### From a Chromebook

```bash
# In ChromeOS Linux (Crostini terminal):
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/machine-setup/main/clients/chromebook-setup.sh | bash
```

## What's Installed

| Category | Tools |
|---|---|
| Shell | Zsh, Oh My Zsh, iTerm2, tmux, Neovim, Starship |
| Languages | Node (nvm), Python (pyenv), Java+Scala (SDKMAN), Go, Rust |
| Dev Tools | Git, GitHub CLI, Docker, VS Code |
| AI Tools | Claude Code, OpenAI Codex CLI, Cursor, GitHub Copilot |
| Remote Access | SSH server, Screen Sharing, Tailscale |
| Claude Ecosystem | 10 MCP servers, 7 plugins, curated skills |

## Rollback

See `docs/rollback.md` for per-component rollback instructions.

## Sharing / Open Source

Fork this repo, update `config/claude/plugins.json` and the Brewfile to match your preferences, and share the URL with friends who can run the Chromebook or generic-linux client scripts to connect.
