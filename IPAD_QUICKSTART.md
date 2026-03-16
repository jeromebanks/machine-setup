# iPad Quickstart

Connect your iPad to the Mac Mini — SSH terminal, VNC screen sharing, and coding on the go.

> No scripts to run — iPad doesn't have a shell. This is a step-by-step manual guide.

---

## Apps to Install

Install all of these from the App Store before starting:

| App | Purpose | Cost |
|---|---|---|
| **Tailscale** | Secure VPN — connects iPad to Mac from anywhere | Free |
| **Blink Shell** | SSH + Mosh terminal, best-in-class | Paid (one-time) |
| **Termius** | SSH terminal, free tier available | Free / Pro |
| **Screens 5** | VNC screen sharing | Paid |
| **Jump Desktop** | VNC / RDP, good free tier | Free / Pro |

> **Recommended combo:** Tailscale + Blink Shell + Screens 5

---

## Step 1: Connect Tailscale

1. Open the **Tailscale** app
2. Sign in with the **same account** used on your Mac Mini
3. Tap **Connect**
4. Your Mac Mini will appear in the device list — note its hostname (e.g. `jeromes-mac-mini.tail12345.ts.net`)

Once connected, Tailscale runs in the background and your iPad can reach the Mac from anywhere — home WiFi or coffee shop.

---

## Step 2: Set Up SSH (Blink Shell)

### Generate a key and add it to the Mac

1. Open **Blink Shell**
2. Tap the screen, type `config` and press Enter
3. Go to **Keys** → tap **+** → **Create New**
   - Name: `ipad`
   - Type: `Ed25519`
   - Passphrase: optional (leave blank for convenience)
4. Tap the key you just created → **Copy Public Key**

Now add it to your Mac. **On your Mac Mini**, run:
```bash
cd ~/dev/machine-setup
./bootstrap.sh --only remote
```
Choose **"Add an authorized public key"**, label it `ipad`, paste the key.

### Configure the host in Blink

1. In Blink, go to **Hosts** → tap **+**
2. Fill in:
   - **Host:** `mac`
   - **Hostname:** your Mac's Tailscale hostname (e.g. `jeromes-mac-mini.tail12345.ts.net`)
   - **Port:** `22`
   - **User:** your Mac username (e.g. `jeromebanks`)
   - **Key:** `ipad` (the key you just created)
3. Save

### Connect

Tap the screen and type:
```
ssh mac
```

You're in. Full terminal on your Mac Mini from your iPad.

---

## Step 3: Set Up SSH (Termius — alternative)

If using Termius instead of Blink:

1. Open **Termius** → **Keychain** → **New Key** → **Generate**
   - Algorithm: Ed25519
   - Export the public key and copy it
2. Add the public key to your Mac (same as above — `./bootstrap.sh --only remote`)
3. Go to **Hosts** → **+** → **New Host**:
   - **Alias:** Mac Mini
   - **Hostname:** your Tailscale hostname
   - **Username:** your Mac username
   - **SSH Key:** the key you generated
4. Tap the host to connect

---

## Step 4: Screen Sharing (Screens 5)

1. Open **Screens 5** → tap **+** → **Add a Screen**
2. Choose **Manually**:
   - **Name:** Mac Mini
   - **Address:** your Mac's Tailscale hostname
   - **Port:** `5900`
   - **Username:** your Mac login username
   - **Password:** your Mac login password
3. Tap **Save** → tap to connect

> **Tip:** For home network use, try your Mac's local IP (`192.168.x.x`) — it's faster than going through Tailscale. Use the Tailscale hostname when away from home.

---

## Step 5: Screen Sharing (Jump Desktop — alternative)

1. Open **Jump Desktop** → tap **+** → **Manually Add Computer**
2. Choose **VNC**:
   - **Name:** Mac Mini
   - **Host:** your Tailscale hostname
   - **Username / Password:** your Mac login credentials
3. Save and connect

---

## Useful Blink Shell Tips

| Task | Command |
|---|---|
| Connect to Mac | `ssh mac` |
| Open a tmux session | `ssh mac` then `tmux new -s main` |
| Resume tmux after disconnect | `ssh mac` then `tmux attach` |
| Copy file from Mac | `scp mac:~/path/to/file .` |
| Port forward (e.g. local dev server) | `ssh -L 3000:localhost:3000 mac` |
| Mosh (better on spotty connections) | `mosh mac` |

---

## Coding Workflow on iPad

**Best setup for coding remotely:**

1. `ssh mac` in Blink Shell
2. On the Mac, open `tmux` so sessions survive disconnects
3. Use `nvim` for editing — it's already configured in your dotfiles
4. Run dev servers on the Mac, use SSH port forwarding to preview in Safari

**Alternative — VS Code in browser:**
- Install the `code-server` extension on VS Code on your Mac
- Forward port 8080: `ssh -L 8080:localhost:8080 mac`
- Open `http://localhost:8080` in Safari on your iPad

---

## Troubleshooting

**`ssh mac` — connection refused**
- Check SSH is enabled on Mac: `System Settings → General → Sharing → Remote Login: On`
- Or re-run on Mac: `cd ~/dev/machine-setup && ./bootstrap.sh --only remote`

**`Permission denied (publickey)`**
- Your iPad key wasn't added to the Mac — redo Step 2
- Verify: on Mac, run `cat ~/.ssh/authorized_keys`

**Tailscale not connecting**
- Both iPad and Mac must be signed into the **same Tailscale account**
- Try toggling Tailscale off and on in the iOS app

**VNC black screen or won't connect**
- Ensure Screen Sharing is on: Mac `System Settings → General → Sharing → Screen Sharing: On`
- Re-run on Mac: `./bootstrap.sh --only remote`
- Try port `5900` explicitly in the VNC client

**Screen sharing is laggy**
- On home WiFi, use the Mac's local IP instead of Tailscale hostname
- Lower the resolution/color depth in Screens 5 settings
- For coding, SSH + Neovim is far more responsive than VNC
