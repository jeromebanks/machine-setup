# Mac Setup Guide Skill

Context and commands for working with the machine-setup repo on this Mac Mini.

## What This Repo Does

`~/dev/machine-setup` is a semi-automated Mac setup repo. It installs and configures:
- Shell tools (Zsh, Oh My Zsh, Neovim, tmux, Starship)
- Language runtimes (Node via nvm, Python via pyenv, Java+Scala via SDKMAN, Go, Rust)
- Dev tools (Git, GitHub CLI, Docker, VS Code)
- AI coding tools (Claude Code, OpenAI Codex CLI, Cursor, Copilot)
- Remote access (SSH server, Screen Sharing, Tailscale)
- Claude ecosystem (10 MCP servers, 7 plugins, 4 skills)

## Running Setup Modules

```bash
cd ~/dev/machine-setup

./bootstrap.sh                    # run everything
./bootstrap.sh --only system      # Homebrew + macOS prefs
./bootstrap.sh --only shell       # Zsh, Neovim, tmux, Starship
./bootstrap.sh --only languages   # Node, Python, Java, Scala, Go, Rust
./bootstrap.sh --only dev         # Git, GitHub CLI, Docker, VS Code
./bootstrap.sh --only ai          # Claude Code, Codex, Cursor, Copilot
./bootstrap.sh --only dotfiles    # chezmoi dotfiles
./bootstrap.sh --only remote      # SSH, Screen Sharing, Tailscale
./bootstrap.sh --only claude      # MCP servers, plugins, skills
./bootstrap.sh --dry-run          # preview without making changes
```

## Remote Access

This Mac is set up to be accessed remotely:

- **From Chromebook (SSH):** `ssh mac`
- **From Chromebook (Claude Code):** `claude-mac` — SSHes in and launches Claude in a persistent tmux session
- **From iPad:** Blink Shell → `ssh mac` (see `IPAD_QUICKSTART.md`)
- **VNC screen sharing:** via Screens 5 / TigerVNC on Tailscale hostname

The `claude-mac` command (installed on the Chromebook) runs this exact Claude Code session on the Mac Mini. If you're currently in a session that was started via `claude-mac`, you're running remotely.

## Adding a New Device

To authorize a new SSH client (Chromebook, iPad, friend's machine):

```bash
cd ~/dev/machine-setup
./bootstrap.sh --only remote
# choose "Add an authorized public key"
# paste the device's public key when prompted
```

## Dotfiles

Dotfiles are managed by chezmoi, sourced from `~/dev/machine-setup/dotfiles/`:

```bash
chezmoi diff          # see pending changes
chezmoi apply         # apply dotfile changes
chezmoi edit ~/.zshrc # edit and auto-apply
chezmoi cd            # open chezmoi's git repo
```

## Claude Ecosystem

MCP servers, plugins, and skills are defined in `~/dev/machine-setup/config/claude/`.

To reinstall or update:
```bash
cd ~/dev/machine-setup
./bootstrap.sh --only claude
```

Secrets required in `~/.zshrc.local`:
- `ANTHROPIC_API_KEY` — Claude
- `OPENAI_API_KEY` — OpenAI Codex
- `BRAVE_API_KEY` — web-search MCP
- `GITHUB_TOKEN` — github MCP
- `SUPABASE_ACCESS_TOKEN` — supabase MCP

## Rollback

```bash
ls ~/dev/machine-setup/backups/          # list snapshots
cp backups/<timestamp>/.zshrc ~/.zshrc   # restore a file
```

Full rollback guide: `~/dev/machine-setup/docs/rollback.md`

## When to Use This Skill

Invoke when the user asks to:
- Set up or update tools on this Mac
- Check what's installed or configured
- Add a new device for remote access
- Update dotfiles, MCP servers, or plugins
- Troubleshoot remote connections from Chromebook or iPad
- Understand how the machine-setup repo works
