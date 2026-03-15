# Mac Remote Access Skill

Configure or check the remote access setup on this Mac (SSH, VNC, Tailscale).

## Usage

Invoke when the user wants to:
- Enable or check SSH / Screen Sharing
- Connect Tailscale
- Add an authorized SSH key for a device or friend
- Get their remote connection details

## Actions

1. Run `./bootstrap.sh --only remote` to (re)configure remote access
2. Show current status:
   - `tailscale status` — Tailscale connection and hostname
   - `systemsetup -getremotelogin` — SSH server status
   - `cat ~/.ssh/authorized_keys` — authorized devices
3. For adding a new key: prompt for device name and public key, append to `~/.ssh/authorized_keys`
4. Print `docs/remote-access.md` for connection instructions
