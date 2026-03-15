# Rollback Guide

How to undo changes made by any setup script.

## Before You Rollback

All config files are backed up before modification to `backups/YYYY-MM-DD-HH-MM/`.

List your backups:
```bash
ls backups/
```

Restore a single file:
```bash
cp backups/2026-03-15-14-30/.zshrc ~/.zshrc
```

---

## Dotfiles (chezmoi)

```bash
chezmoi cd            # Open chezmoi's git repo
git log               # See all changes
git diff HEAD~1       # See what last apply changed
git revert HEAD       # Create a revert commit
chezmoi apply         # Re-apply reverted state
```

Or restore from backup:
```bash
cp backups/<timestamp>/.zshrc ~/.zshrc
```

---

## Homebrew Packages

Uninstall a formula:
```bash
brew uninstall <formula>
```

Pin to current version (prevent upgrades):
```bash
brew pin <formula>
brew unpin <formula>   # to release
```

Downgrade a formula:
```bash
brew install <formula>@<version>   # if versioned formula exists
```

Remove all Brewfile installs (nuclear):
```bash
brew bundle cleanup --force --file=Brewfile
```

---

## Oh My Zsh

Uninstall:
```bash
uninstall_oh_my_zsh
```

---

## nvm (Node)

Remove a Node version:
```bash
nvm uninstall <version>
```

Uninstall nvm:
```bash
rm -rf "$HOME/.nvm"
# Remove nvm lines from ~/.zshrc
```

---

## pyenv (Python)

Remove a Python version:
```bash
pyenv uninstall <version>
```

---

## SDKMAN (Java/Scala)

Remove a version:
```bash
sdk uninstall java <version>
```

Uninstall SDKMAN:
```bash
tar -czvf ~/sdkman-backup.tar.gz ~/.sdkman
rm -rf ~/.sdkman
# Remove SDKMAN lines from ~/.zshrc
```

---

## Rust (rustup)

Uninstall Rust:
```bash
rustup self uninstall
```

---

## AI Tools

Uninstall Claude Code:
```bash
npm uninstall -g @anthropic-ai/claude-code
```

Uninstall OpenAI Codex CLI:
```bash
npm uninstall -g @openai/codex
```

Uninstall Cursor:
```bash
brew uninstall --cask cursor
```

Uninstall GitHub Copilot CLI extension:
```bash
gh extension remove github/gh-copilot
```

Remove API keys from `~/.zshrc.local` — edit the file and delete the relevant `export` lines:
```bash
$EDITOR ~/.zshrc.local
```

---

## VS Code & Docker

Uninstall VS Code:
```bash
brew uninstall --cask visual-studio-code
```

Uninstall a VS Code extension:
```bash
code --uninstall-extension <extension-id>
```

Uninstall Docker Desktop:
```bash
brew uninstall --cask docker
```

---

## Remote Access

Disable SSH server:
```bash
sudo systemsetup -setremotelogin off
```

Disable Screen Sharing:
```bash
sudo launchctl unload /System/Library/LaunchDaemons/com.apple.screensharing.plist
```

Disconnect Tailscale:
```bash
tailscale down
```

Remove Tailscale:
```bash
brew uninstall --cask tailscale
```

---

## macOS System Preferences

Reset to defaults:
```bash
# Key repeat
defaults delete NSGlobalDomain KeyRepeat
defaults delete NSGlobalDomain InitialKeyRepeat

# Finder
defaults delete com.apple.finder ShowPathbar
defaults delete com.apple.finder ShowStatusBar
defaults delete com.apple.finder AppleShowAllFiles

# Dock
defaults delete com.apple.dock autohide
defaults delete com.apple.dock minimize-to-application

killall Finder
killall Dock
```
