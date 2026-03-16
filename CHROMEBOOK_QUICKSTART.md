# Chromebook Quickstart

Connect your Chromebook to the Mac Mini — SSH terminal, VNC screen sharing, and optional AI coding tools.

---

## Prerequisites

You need **Linux (Crostini)** enabled on your Chromebook.

1. Open **Settings** → search "Linux" → **Turn on**
2. Follow the setup wizard (takes a few minutes)
3. A terminal window will open when done — that's your Linux environment

---

## Step 1: Run the Setup Script

In the Linux terminal, run:

```bash
curl -fsSL https://raw.githubusercontent.com/jeromebanks/machine-setup/main/clients/chromebook-setup.sh | bash
```

This script will:
- Install **Tailscale** (secure VPN to reach the Mac from anywhere)
- Generate an **SSH keypair** for you
- Display your public key to add to the Mac
- Write your `~/.ssh/config` so you can type `ssh mac` to connect
- Install **TigerVNC** for screen sharing
- Optionally install **Claude Code** and **OpenAI Codex CLI**

> **Estimated time:** 5–10 minutes depending on your connection.

---

## Step 2: Add Your Key to the Mac

When the script displays your public key (looks like `ssh-ed25519 AAAA...`), copy it.

**On the Mac Mini**, run:
```bash
cd ~/dev/machine-setup
./bootstrap.sh --only remote
```

Choose **"Add an authorized public key"**, label it `chromebook`, and paste your key.

Then press Enter back in the Chromebook terminal to continue setup.

---

## Step 3: Connect Tailscale

The script will prompt you to authenticate Tailscale:

1. A URL will appear in the terminal — open it in your Chromebook browser
2. Sign in with your Tailscale account (same one used on the Mac)
3. Authorize the device

Once connected, your Mac Mini will be reachable by its Tailscale hostname (e.g. `jeromes-mac-mini.tail12345.ts.net`) from **anywhere** — home network or coffee shop.

---

## Connecting After Setup

### SSH (Terminal)

```bash
ssh mac
```

That's it. The `~/.ssh/config` entry `Host mac` was written by the setup script pointing to your Mac's Tailscale hostname.

To run a specific command:
```bash
ssh mac 'ls ~/dev'
```

### VNC (Screen Sharing)

```bash
vncviewer <your-mac-tailscale-hostname>:5900
```

Replace `<your-mac-tailscale-hostname>` with the hostname shown at the end of the setup script (e.g. `jeromes-mac-mini.tail12345.ts.net`).

> **Tip:** On your home network, you can also use the Mac's local IP (`192.168.x.x`) for lower latency.

### VS Code Remote SSH

If you install VS Code on your Chromebook (via Linux):

```bash
# Install VS Code
sudo apt-get install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt-get update && sudo apt-get install -y code
```

Then open VS Code → install the **Remote - SSH** extension → connect to `mac` (it's already in your `~/.ssh/config`).

---

## Useful Commands

| Task | Command |
|---|---|
| SSH into Mac | `ssh mac` |
| Check Tailscale status | `tailscale status` |
| See your Mac's Tailscale hostname | `tailscale status \| grep mac` |
| VNC screen share | `vncviewer <hostname>:5900` |
| Copy a file from Mac | `scp mac:~/path/to/file .` |
| Copy a file to Mac | `scp ./file mac:~/path/to/dest` |
| Run Claude Code on Mac | `ssh mac 'claude'` |

---

## Troubleshooting

**`ssh mac` times out**
- Check Tailscale is running on both devices: `tailscale status`
- If you're on the same WiFi, try: `ssh <local-ip>` (find it with `tailscale status`)

**`Permission denied (publickey)`**
- Your key wasn't added to the Mac yet — go back to Step 2
- Or verify it's there: `ssh mac 'cat ~/.ssh/authorized_keys'`

**VNC shows a black screen**
- Make sure Screen Sharing is enabled on the Mac: `System Settings → Sharing → Screen Sharing: On`
- Or re-run: `cd ~/dev/machine-setup && ./bootstrap.sh --only remote`

**Tailscale won't connect**
- Re-authenticate: `sudo tailscale up` (follow the URL)
- Both devices must be in the same Tailscale account

**Setup script failed partway through**
- The script is safe to re-run: `curl -fsSL ... | bash` again
- Or clone the repo and run directly: `bash clients/chromebook-setup.sh`
