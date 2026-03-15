# Client Setup Skill

Set up a client machine to remotely access this Mac.

## Usage

Invoke when the user wants to connect a Chromebook, Linux machine, or iPad to their Mac.

## Actions by Device

### Chromebook (ChromeOS Linux / Crostini)

```bash
# In ChromeOS Linux terminal:
curl -fsSL https://raw.githubusercontent.com/jeromebanks/machine-setup/main/clients/chromebook-setup.sh | bash
```

Or if repo is cloned locally:
```bash
bash clients/chromebook-setup.sh
```

### Other Linux / Friend's Machine

```bash
bash clients/generic-linux.sh
```

### iPad

Point the user to `clients/ipad-guide.md` — step-by-step manual setup with app recommendations.

## What the Client Scripts Do

1. Install Tailscale and connect to the network
2. Generate an SSH keypair
3. Display the public key to add to the Mac's `authorized_keys`
4. Write `~/.ssh/config` with the Mac's Tailscale hostname
5. Install a VNC viewer
6. Optionally install Claude Code + OpenAI Codex CLI
