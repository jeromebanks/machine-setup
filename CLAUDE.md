# machine-setup — Claude Code Context

This repo sets up a Mac Mini for development with AI coding tools, languages, remote access, and the Claude ecosystem. Scripts are idempotent (safe to re-run) and support `--dry-run`.

## Running Setup

```bash
./bootstrap.sh                    # run everything
./bootstrap.sh --only <module>    # run one module
./bootstrap.sh --skip <module>    # run all except one
./bootstrap.sh --dry-run          # preview without changes
```

**Modules and what they do:**

| Module name | Script | What it installs |
|---|---|---|
| `system` | `scripts/01-system.sh` | Xcode CLI, Homebrew, brew bundle, macOS prefs |
| `shell` | `scripts/02-shell.sh` | Zsh, Oh My Zsh, iTerm2, tmux, Neovim, Starship |
| `languages` | `scripts/03-languages.sh` | Node (nvm), Python (pyenv), Java+Scala (SDKMAN), Go, Rust |
| `dev` | `scripts/04-dev-tools.sh` | Git config, GitHub CLI, Docker, VS Code + extensions |
| `ai` | `scripts/05-ai-tools.sh` | Claude Code, OpenAI Codex CLI, Cursor, Copilot CLI |
| `dotfiles` | `scripts/06-dotfiles.sh` | chezmoi dotfiles (zshrc, gitconfig, nvim, tmux) |
| `remote` | `scripts/07-remote-access.sh` | SSH server, Screen Sharing, Tailscale, ssh config |
| `claude` | `scripts/08-claude-ecosystem.sh` | MCP servers, Claude Code plugins, skills |

## Shared Libraries

All scripts source these from `scripts/lib/`:

- `log.sh` — colored output: `log_info`, `log_success`, `log_warn`, `log_error`, `log_step`, `log_section`
- `check.sh` — `command_exists`, `brew_installed`, `is_macos`, `is_arm`, `require_macos`
- `backup.sh` — `backup_file <path>` snapshots to `backups/YYYY-MM-DD-HH-MM/` before changes
- `prompt.sh` — `prompt_yn`, `prompt_text`, `prompt_secret` for interactive input

## Key Files

| File | Purpose |
|---|---|
| `Brewfile` | All Homebrew package installs |
| `dotfiles/dot_zshrc` | Shell config (chezmoi managed) |
| `dotfiles/dot_gitconfig.tmpl` | Git config template with name/email prompts |
| `dotfiles/dot_config/nvim/init.lua` | Neovim config |
| `dotfiles/dot_config/tmux/tmux.conf` | tmux config (prefix: Ctrl+a) |
| `config/claude/plugins.json` | Pinned Claude Code plugin list |
| `config/claude/mcp-servers.json` | MCP server definitions (10 servers) |
| `clients/chromebook-setup.sh` | Chromebook client setup script |
| `clients/claude-remote.sh` | `claude-mac` command — runs Claude on this Mac via SSH |
| `docs/rollback.md` | How to undo any change |
| `docs/remote-access.md` | Generated — per-device connection instructions |

## Secrets

Never stored in the repo. All secrets go in `~/.zshrc.local`:

```bash
export ANTHROPIC_API_KEY="..."
export OPENAI_API_KEY="..."
export BRAVE_API_KEY="..."          # web-search MCP
export GITHUB_TOKEN="..."           # github MCP
export SUPABASE_ACCESS_TOKEN="..."  # supabase MCP
```

## Rollback

```bash
# Restore a backed-up file
cp backups/<timestamp>/.zshrc ~/.zshrc

# Undo dotfile changes via chezmoi
chezmoi cd && git revert HEAD && chezmoi apply

# Rollback a Homebrew package
brew uninstall <formula>
```

Full guide: `docs/rollback.md`

## Remote Access

This Mac is accessible from:
- **Chromebook / Linux**: `ssh mac` or `claude-mac` (Claude via SSH+tmux)
- **iPad**: Blink Shell + Tailscale + Screens 5 (see `IPAD_QUICKSTART.md`)
- **Anywhere**: Tailscale handles NAT traversal automatically

Connection details (after running `07-remote-access.sh`): `docs/remote-access.md`

## Testing

```bash
bats scripts/tests/         # run all tests
bats scripts/tests/test_log.bats   # run specific test file
```

Tests cover all shared library functions. 23 tests, 0 failures expected.

## Common Tasks

**Add a new authorized SSH key (new device or friend):**
```bash
./bootstrap.sh --only remote
# choose "Add an authorized public key"
```

**Install/update Claude plugins and MCP servers:**
```bash
./bootstrap.sh --only claude
```

**Update dotfiles after editing them in this repo:**
```bash
chezmoi apply
# or: chezmoi diff   (preview first)
```

**Check what Homebrew packages need updating:**
```bash
brew bundle check --file=Brewfile
```
