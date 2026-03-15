# iPad Client Setup Guide

Connect your iPad to your Mac for SSH terminal access and screen sharing.

## Required Apps

| App | Purpose | Store Link |
|---|---|---|
| **Tailscale** | Secure network tunnel | App Store: "Tailscale" |
| **Blink Shell** or **Termius** | SSH terminal | App Store |
| **Screens 5** or **Jump Desktop** | VNC / Screen sharing | App Store |

## Step 1: Connect Tailscale

1. Install the Tailscale app
2. Sign in with the same account used on your Mac
3. Your Mac will appear as a device in the Tailscale network

## Step 2: SSH Terminal (Blink Shell)

1. Open Blink Shell → tap the `+` tab → type `config`
2. Under **Hosts**, tap `+`:
   - **Host:** `mac`
   - **Hostname:** your Mac's Tailscale hostname (e.g. `mac-mini.tail12345.ts.net`)
   - **Port:** `22`
   - **User:** your Mac username
3. Under **Keys**, tap `+` → create a new Ed25519 key
4. Copy the public key → paste it into your Mac's `~/.ssh/authorized_keys`
   - On your Mac: `./bootstrap.sh --only remote` → "Add authorized key"
5. Back in Blink: `ssh mac`

## Step 3: Screen Sharing (Screens 5)

1. Open Screens 5 → tap `+`
2. **Connection type:** VNC
3. **Address:** your Mac's Tailscale hostname
4. **Port:** 5900
5. **Username/Password:** your Mac login credentials
6. Connect

## Tips

- **Same network:** Use your Mac's local IP (`192.168.x.x`) for lower latency
- **Away from home:** Tailscale hostname works anywhere automatically
- **For coding:** SSH + Neovim or VS Code Remote SSH (via Blink + VS Code iOS) recommended over VNC
