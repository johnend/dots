# Kanata vs KMonad Comparison

## Why Consider Kanata?

### Advantages Over KMonad
- ✅ **Bilateral/cross-hand homerow mods** - Native support (prevents same-hand misfires)
- ✅ **Better tap-hold options** - More configuration flexibility
- ✅ **Active development** - Regular updates, more features
- ✅ **Cross-platform** - Linux, macOS (Intel/ARM), Windows
- ✅ **Better documentation** - Comprehensive config guide
- ✅ **Similar syntax** - KMonad-inspired, easy to migrate

### What You'd Lose
- ❌ Need to learn slight syntax differences
- ❌ Smaller community than KMonad (but growing)
- ❌ Need to rebuild systemd service setup

## Multi-Keyboard Support

Both KMonad and Kanata handle multiple keyboards the **same way**:

### Current KMonad Setup
```
systemctl --user enable kmonad@hi86.service
systemctl --user enable kmonad@apple_integrated.service

~/.config/kmonad/
├── hi86.kbd                    # BY Tech Gaming Keyboard config
└── apple_integrated.kbd        # Apple Internal Keyboard config
```

### Kanata Would Be
```
systemctl --user enable kanata@hi86.service
systemctl --user enable kanata@apple_integrated.service

~/.config/kanata/
├── hi86.kbd                    # BY Tech Gaming Keyboard config
└── apple_integrated.kbd        # Apple Internal Keyboard config
```

**Same templated systemd service**, just different binary!

## Configuration Syntax Comparison

### KMonad Homerow Mods (Current)
```lisp
(defalias
  a_shft (tap-hold-next-release 200 a lsft)
  f_ctrl (tap-hold-next-release 200 f lctl))
```

### Kanata Homerow Mods (Basic)
```lisp
(defalias
  a_shft (tap-hold-release 200 200 a lsft)
  f_ctrl (tap-hold-release 200 200 f lctl))
```

### Kanata Bilateral Homerow Mods (Advanced)
```lisp
;; Only activates mods on opposite-hand key presses!
(defalias
  a_shft (tap-hold-release-keys 200 200 a lsft
    (j k l ; u i o p))  ;; Only activate when pressing these right-hand keys
  f_ctrl (tap-hold-release-keys 200 200 f lctl
    (j k l ; u i o p)))
```

## Installation on Arch Linux

```bash
# Download latest release
cd /tmp
wget https://github.com/jtroo/kanata/releases/download/v1.10.1/kanata-linux-binaries-v1.10.1-x64.zip
unzip kanata-linux-binaries-v1.10.1-x64.zip

# Extract and install (choose cmd_allowed variant for shell commands)
sudo install -Dm755 kanata_linux_x64_cmd_allowed /usr/local/bin/kanata

# Or install from AUR
yay -S kanata-bin
```

## Systemd Service Template

Create `~/.config/systemd/user/kanata@.service`:

```ini
[Unit]
Description=Kanata keyboard remapping (%i)
Documentation=https://github.com/jtroo/kanata
PartOf=graphical-session.target
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/local/bin/kanata --cfg %h/.config/kanata/%i.kbd
Restart=on-failure
RestartSec=1

[Install]
WantedBy=default.target
```

## Migration Steps (When Ready)

1. **Backup current KMonad configs**
   ```bash
   cp -r ~/.config/kmonad ~/.config/kmonad.backup
   ```

2. **Install Kanata**
   ```bash
   yay -S kanata-bin  # or manual install
   ```

3. **Create Kanata config directory**
   ```bash
   mkdir -p ~/.config/kanata
   ```

4. **Convert one config** (start with hi86.kbd)
   - Copy to `~/.config/kanata/hi86.kbd`
   - Update syntax (mainly `tap-hold-*` functions)
   - Add bilateral combinations if desired

5. **Test manually**
   ```bash
   sudo kanata --cfg ~/.config/kanata/hi86.kbd
   ```

6. **Create systemd service**
   ```bash
   # Copy service template
   cp ~/.config/systemd/user/kmonad@.service ~/.config/systemd/user/kanata@.service
   # Update ExecStart to use kanata binary
   systemctl --user daemon-reload
   ```

7. **Switch keyboards one at a time**
   ```bash
   # Disable KMonad for one keyboard
   systemctl --user stop kmonad@hi86.service
   systemctl --user disable kmonad@hi86.service
   
   # Enable Kanata for that keyboard
   systemctl --user enable --now kanata@hi86.service
   ```

8. **Repeat for other keyboards** once satisfied

## Resources

- **Official Docs**: https://github.com/jtroo/kanata/blob/main/docs/config.adoc
- **Example Configs**: https://github.com/jtroo/kanata/tree/main/cfg_samples
- **Bilateral Homerow Mods**: Search config.adoc for "opposite-hand"
- **Linux Setup Guide**: https://github.com/jtroo/kanata/wiki/Avoid-using-sudo-on-Linux

## Decision Points

### Stay with KMonad if:
- Current 200ms `tap-hold-next-release` is working well enough
- Don't want to invest time in migration
- Comfortable with current setup

### Switch to Kanata if:
- Still getting too many homerow mod misfires
- Want bilateral/cross-hand detection
- Want more advanced features (mouse keys, tap-dance, etc.)
- Appreciate active development and better docs

## Current Status

**Using**: KMonad v0.4.4 with `tap-hold-next-release` at 200ms  
**Working**: Layer notifications, homerow mods mostly working  
**Pain point**: Occasional homerow mod misfires  
**Next step**: Test current setup for a few days, then decide on Kanata
