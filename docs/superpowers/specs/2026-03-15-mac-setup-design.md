# Mac Development Setup — Design Spec

**Date:** 2026-03-15
**Status:** Approved
**Approach:** Shell scripts + chezmoi (Option A)

---

## Overview

A semi-automated Mac setup repository for a personal development environment focused on AI coding tools (Claude Code, OpenAI Codex, Cursor, Copilot), remote access, and full-stack development. Designed primarily for personal use but structured to be shareable and forkable. Supports idempotent installs (safe to run on machines with existing tooling) and rollback for any change made.

---

## Repository Structure

```
machine-setup/
├── README.md
├── bootstrap.sh                  # Entry point
├── Brewfile                      # All Homebrew installs
│
├── scripts/
│   ├── lib/                      # Shared helpers: logging, prompts, backup, checks
│   ├── 01-system.sh              # Xcode CLI tools, Homebrew, system preferences
│   ├── 02-shell.sh               # Zsh, Oh My Zsh, iTerm2, tmux, Neovim
│   ├── 03-languages.sh           # nvm (Node), pyenv (Python), SDKMAN (Java/Scala), Go, Rust
│   ├── 04-dev-tools.sh           # Git config, GitHub CLI, Docker, VS Code + extensions
│   ├── 05-ai-tools.sh            # Claude Code, OpenAI Codex CLI, Cursor, GitHub Copilot
│   ├── 06-dotfiles.sh            # chezmoi install + apply
│   ├── 07-remote-access.sh       # SSH server, Screen Sharing, Tailscale
│   └── 08-claude-ecosystem.sh    # MCP servers, Claude Code plugins, skills
│
├── config/
│   └── claude/
│       ├── plugins.json          # Pinned plugin list with versions
│       ├── mcp-servers.json      # MCP server configs
│       └── skills/               # Curated skill .md files to install
│
├── dotfiles/                     # chezmoi source directory
│   ├── dot_zshrc
│   ├── dot_gitconfig.tmpl        # Template: prompts for name/email
│   ├── dot_config/
│   │   ├── nvim/
│   │   └── tmux/
│   └── private_dot_ssh/          # chezmoi-encrypted SSH config
│
├── clients/
│   ├── chromebook-setup.sh       # Client setup for ChromeOS Linux (Crostini)
│   ├── generic-linux.sh          # Client setup for any Debian/Ubuntu machine
│   └── ipad-guide.md             # Manual steps for iPad (app list + config)
│
├── skills/
│   ├── mac-bootstrap.md          # /mac-bootstrap skill
│   ├── mac-remote.md             # /mac-remote skill
│   ├── mac-languages.md          # /mac-languages skill
│   └── client-setup.md           # /client-setup skill
│
├── docs/
│   ├── tools/                    # Per-tool setup notes
│   ├── remote-access.md          # SSH, VNC, Tailscale connection guide
│   ├── rollback.md               # How to undo any change
│   └── superpowers/
│       └── specs/
│           └── 2026-03-15-mac-setup-design.md  # This file
│
└── backups/                      # Auto-created snapshots before changes (gitignored)
```

---

## Bootstrap Flow

### Entry Point

`bootstrap.sh` accepts flags for full or partial runs:

```bash
./bootstrap.sh                   # Run all scripts in order
./bootstrap.sh --only ai         # Run only 05-ai-tools.sh
./bootstrap.sh --skip remote     # Skip 07-remote-access.sh
./bootstrap.sh --dry-run         # Show what would happen, no changes made
```

### Script Execution Order

1. `01-system.sh` — must run first (Homebrew is a prerequisite for everything else)
2. `02-shell.sh` — shell environment before language managers
3. `03-languages.sh` — runtimes before dev tools
4. `04-dev-tools.sh` — Git/Docker/VS Code
5. `05-ai-tools.sh` — AI coding tools
6. `06-dotfiles.sh` — chezmoi (applies after tools are installed)
7. `07-remote-access.sh` — remote access (can run independently)
8. `08-claude-ecosystem.sh` — MCP, plugins, skills (requires Claude Code from step 5)

### Idempotency Rules

Every script checks before acting:
- Homebrew formulae/casks: `brew list` check before install
- Version manager installs (nvm, pyenv, SDKMAN): check if version exists before installing
- Config files: chezmoi diffs and prompts before overwriting
- System settings: read current value before writing

### Shared Helpers (`scripts/lib/`)

- `log.sh` — colored output, step counters, success/error/warning
- `backup.sh` — snapshots any file to `backups/YYYY-MM-DD-HH-MM/` before modification
- `prompt.sh` — interactive yes/no, text input, secret input (no echo)
- `check.sh` — `command_exists`, `brew_installed`, `is_macos`, `is_arm` helpers

---

## Sensitive Values

Never stored in the repo. Prompted interactively at runtime:

| Value | Where it goes |
|---|---|
| Git name / email | chezmoi template renders `~/.gitconfig` |
| Claude API key | `~/.zshrc.local` (gitignored, sourced by `.zshrc`) |
| OpenAI API key | `~/.zshrc.local` |
| SSH key passphrase | Entered at key generation, stored in macOS Keychain |
| Tailscale auth key | Used at `tailscale up`, not persisted |

`~/.zshrc.local` is the pattern for all machine-local secrets — `.zshrc` sources it if it exists.

---

## Rollback Strategy

**Before any config change:** `scripts/lib/backup.sh` snapshots the file to `backups/YYYY-MM-DD-HH-MM/`. Restore with:
```bash
cp backups/2026-03-15-14-30/dot_zshrc ~/.zshrc
```

**Dotfiles via chezmoi:**
```bash
chezmoi cd          # enter chezmoi git repo
git log             # see all changes
git revert HEAD     # revert last change
chezmoi apply       # re-apply
```

**Homebrew packages:**
```bash
brew pin <formula>          # lock to current version
brew uninstall <formula>    # remove entirely
```

**Full rollback doc:** `docs/rollback.md`

---

## Tool Coverage

### System (`01-system.sh`)
- Xcode Command Line Tools (`xcode-select --install`)
- Homebrew (installs if missing, `brew update` if present)
- macOS system preferences (key repeat rate, dock settings, Finder prefs)

### Shell (`02-shell.sh`)
- Zsh (default on macOS, ensure latest via Homebrew)
- Oh My Zsh
- iTerm2 (Homebrew Cask)
- tmux
- Neovim (with basic config in dotfiles)
- Starship prompt

### Languages (`03-languages.sh`)
- **Node.js** via nvm (installs nvm + LTS Node)
- **Python** via pyenv (installs pyenv + latest stable)
- **Java + Scala** via SDKMAN (installs SDKMAN + Java LTS + Scala)
- **Go** via Homebrew
- **Rust** via rustup

### Dev Tools (`04-dev-tools.sh`)
- Git (Homebrew for latest) + config via chezmoi template
- GitHub CLI (`gh`) + auth flow
- Docker Desktop (Homebrew Cask)
- VS Code (Homebrew Cask) + curated extension list

### AI Coding Tools (`05-ai-tools.sh`)
- **Claude Code** (`npm install -g @anthropic-ai/claude-code`)
- **OpenAI Codex CLI** (`npm install -g @openai/codex`)
- **Cursor** (Homebrew Cask)
- **GitHub Copilot** (VS Code extension + CLI)
- API keys prompted and written to `~/.zshrc.local`

### Dotfiles (`06-dotfiles.sh`)
- Install chezmoi via Homebrew
- `chezmoi init` pointing to this repo's `dotfiles/` directory
- `chezmoi apply` with diff preview before applying
- Templates used for machine-specific values (name, email, hostname)

### Remote Access (`07-remote-access.sh`)
- **SSH server** — enable via `systemsetup -setremotelogin on`; generate host keys if missing; prompt to add authorized public keys (Chromebook, iPad, friends)
- **Screen Sharing / VNC** — enable via `launchctl` + `defaults write`; works with Screens (iPad), Jump, TigerVNC (Chromebook)
- **Tailscale** — install via Homebrew Cask; `tailscale up` with auth key prompt; prints Tailscale hostname for use in SSH config
- **VS Code Remote SSH** — extension installed in step 4; SSH config written with Mac's Tailscale hostname

After running, generates `docs/remote-access.md` with device-specific connection instructions.

### Claude Ecosystem (`08-claude-ecosystem.sh`)

**MCP Servers** (installed via `claude mcp add`):

| Server | Purpose |
|---|---|
| `filesystem` | Local file read/write access |
| `github` | GitHub API — repos, PRs, issues |
| `web-search` | Web search (Brave/Tavily) |
| `postgres` | PostgreSQL database access |
| `sqlite` | SQLite database access |
| `duckdb` | Analytical SQL on CSV/Parquet files |
| `supabase` | Supabase project + database access |
| `playwright` | Browser automation |
| `puppeteer` | Headless browser control |
| `tree-sitter` | Code parsing / AST analysis |

**Claude Code Plugins** (pinned versions in `config/claude/plugins.json`):

| Plugin | Purpose |
|---|---|
| `superpowers` | Skill system, brainstorming, planning |
| `context7` | Library documentation lookup |
| `playwright` | Browser automation in Claude |
| `github` | GitHub integration |
| `skill-creator` | Create and manage skills |
| `ralph-loop` | Recursive improvement loop |
| `greptile` | Codebase search and understanding |

**Claude Skills** — curated `.md` files copied to `~/.claude/skills/`:
- Development: TDD, code review, systematic debugging, git workflows
- Machine setup: the skills defined in this repo's `skills/` directory

---

## Client Setup

### Chromebook (`clients/chromebook-setup.sh`)

Runs inside ChromeOS Linux (Crostini — Debian-based):

1. Install Tailscale for Linux
2. Generate SSH keypair (`~/.ssh/id_ed25519`); display public key for pasting into Mac's `authorized_keys`
3. Install TigerVNC viewer
4. Write `~/.ssh/config` with Mac's Tailscale hostname pre-filled
5. Optionally install Claude Code + OpenAI Codex CLI

### iPad (`clients/ipad-guide.md`)

Manual guide (no shell available):
- **Tailscale** app — connect to same network
- **Screens 5** or **Jump Desktop** — VNC/RDP client
- **Blink Shell** or **Termius** — SSH client
- SSH config settings to enter manually

### Generic Linux (`clients/generic-linux.sh`)

Debian/Ubuntu variant of the Chromebook script for friends or other machines.

---

## Claude Code Skills (this repo)

Skills wrap the setup scripts for use inside Claude Code sessions:

| Skill | Command | What it does |
|---|---|---|
| `mac-bootstrap` | `/mac-bootstrap` | Run full or partial Mac setup |
| `mac-remote` | `/mac-remote` | Configure or check remote access |
| `mac-languages` | `/mac-languages` | Install or update language runtimes |
| `client-setup` | `/client-setup` | Set up a client machine for remote access |

Each skill file lives in `skills/` and can be copied to `~/.claude/skills/` by `08-claude-ecosystem.sh`.

---

## Documentation

| File | Contents |
|---|---|
| `README.md` | Quick start, prerequisites, what this repo does |
| `docs/remote-access.md` | Generated after setup — per-device connection instructions |
| `docs/rollback.md` | Step-by-step rollback for every component |
| `docs/tools/` | One file per major tool: what it is, why it's included, config notes |
| `clients/ipad-guide.md` | Manual iPad setup guide |

---

## Non-Goals

- **Productivity apps** (Rectangle, Raycast, 1Password) — deferred, out of scope for v1
- **Nix/declarative config** — intentionally avoided for approachability
- **Windows/Linux host support** — Mac only; client scripts cover Linux clients
- **Automated secret rotation** — API keys are set once, rotation is manual
