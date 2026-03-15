# Tailscale

Zero-config VPN that connects your devices securely.

**Install:** `brew install --cask tailscale` (Mac), or `curl -fsSL https://tailscale.com/install.sh | sh` (Linux)
**Connect:** `tailscale up`
**Status:** `tailscale status`
**Your hostname:** shown in `tailscale status` under "Self"

Use your Tailscale hostname (e.g. `mac-mini.tail12345.ts.net`) in SSH config and VNC clients to connect from anywhere.

**Key commands:**
- `tailscale up` — connect / reconnect
- `tailscale down` — disconnect
- `tailscale status` — show connected devices and your hostname
- `tailscale ping <device>` — test connectivity to a device
