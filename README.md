# machine-setup

Semi-automated Mac development setup. Covers AI coding tools (Claude Code, OpenAI Codex, Cursor), languages (Node, Python, Java, Scala, Go, Rust), remote access (SSH, VNC, Tailscale), and the full Claude ecosystem (MCP servers, plugins, skills).

## Quick Start

### New Mac

```bash
git clone https://github.com/jeromebanks/machine-setup.git ~/dev/machine-setup
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
curl -fsSL https://raw.githubusercontent.com/jeromebanks/machine-setup/main/clients/chromebook-setup.sh | bash
```

## What's Installed

### System Utilities (via Homebrew)

| Package | Description |
|---|---|
| `git` | Version control |
| `curl` / `wget` | HTTP clients |
| `jq` | JSON processor |
| `tree` | Directory tree viewer |
| `htop` | Interactive process viewer |
| `bats-core` | Bash testing framework |
| `chezmoi` | Dotfile manager |

### Shell & Terminal

| Tool | How installed | Description |
|---|---|---|
| Zsh | Homebrew | Default shell |
| Oh My Zsh | install script | Zsh framework + plugins |
| zsh-autosuggestions | git clone | Fish-style suggestions |
| zsh-syntax-highlighting | git clone | Shell syntax colors |
| Starship | Homebrew | Cross-shell prompt |
| tmux | Homebrew | Terminal multiplexer |
| Neovim | Homebrew | Modern vim |
| iTerm2 | Homebrew Cask | macOS terminal emulator |
| JetBrains Mono Nerd Font | Homebrew Cask | Programmer font with icons |

### Language Runtimes

| Language | Manager | Notes |
|---|---|---|
| Node.js (LTS) | nvm | Version manager handles multiple versions |
| Python (latest 3.x) | pyenv | Version manager handles multiple versions |
| Java 21 LTS | SDKMAN | Temurin distribution |
| Scala | SDKMAN | Via SDKMAN |
| Go | Homebrew | Latest stable |
| Rust | rustup | Includes cargo |

### Dev Tools

| Tool | How installed | Description |
|---|---|---|
| Git | Homebrew | Latest version + configured global defaults |
| GitHub CLI (`gh`) | Homebrew | Manage repos, PRs, issues from terminal |
| Docker Desktop | Homebrew Cask | Container runtime |
| VS Code | Homebrew Cask | Editor |

**VS Code extensions installed automatically:**
- Remote - SSH, Remote - Containers
- GitHub Copilot + Copilot Chat
- GitLens, Prettier, ESLint
- Python, Go, Rust Analyzer, Scala (Metals)

### AI Coding Tools

| Tool | How installed | Description |
|---|---|---|
| Claude Code | npm global | Anthropic's AI coding CLI |
| OpenAI Codex CLI | npm global | OpenAI's coding CLI |
| Cursor | Homebrew Cask | AI-first code editor |
| GitHub Copilot CLI | gh extension | Copilot in the terminal |

API keys are stored in `~/.zshrc.local` (never committed).

### Remote Access

| Tool | How installed | Description |
|---|---|---|
| SSH server | macOS built-in | Enabled via `systemsetup` |
| Screen Sharing (VNC) | macOS built-in | Enabled via `launchctl` |
| Tailscale | Homebrew Cask | Zero-config VPN, works from anywhere |

### Claude Ecosystem

**MCP Servers** (10 total, installed via `claude mcp add`):

| Server | Purpose |
|---|---|
| `filesystem` | Local file access |
| `github` | GitHub API |
| `web-search` | Brave Search |
| `postgres` | PostgreSQL |
| `sqlite` | SQLite |
| `duckdb` | Analytical SQL on CSV/Parquet |
| `supabase` | Supabase projects |
| `playwright` | Browser automation |
| `puppeteer` | Headless browser |
| `tree-sitter` | Code AST parsing |

**Plugins** (7 total): `superpowers`, `context7`, `playwright`, `github`, `skill-creator`, `ralph-loop`, `greptile`

**Skills**: `mac-bootstrap`, `mac-remote`, `mac-languages`, `client-setup`

## Connecting from Other Devices

- **Chromebook** — see [`CHROMEBOOK_QUICKSTART.md`](CHROMEBOOK_QUICKSTART.md)
- **iPad** — see [`IPAD_QUICKSTART.md`](IPAD_QUICKSTART.md)
- **Any Linux machine** — run `bash clients/generic-linux.sh`

## Rollback

See `docs/rollback.md` for per-component rollback instructions.

## Sharing / Open Source

Fork this repo, update `config/claude/plugins.json` and the Brewfile to match your preferences, and share the URL with friends who can run the Chromebook or generic-linux client scripts to connect.
