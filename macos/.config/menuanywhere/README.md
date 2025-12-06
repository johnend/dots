# Start `menuanywhere` at login (macOS)

## 1. Verify that `menuanywhere` works

```bash
menuanywhere &
```

If it works, find the full path to the binary:

```bash
which menuanywhere
```

Note this path (e.g. `/opt/homebrew/bin/menuanywhere` or `/usr/local/bin/menuanywhere`).

---

## 2. Create a LaunchAgent

Create the LaunchAgents directory if it doesn’t exist:

```bash
mkdir -p ~/Library/LaunchAgents
```

Create a plist file:

```bash
nano ~/Library/LaunchAgents/com.john.menuanywhere.plist
```

Paste this content, replacing the path with the result of `which menuanywhere`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.john.menuanywhere</string>

    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/menuanywhere</string>
    </array>

    <!-- Start when you log in -->
    <key>RunAtLoad</key>
    <true/>

    <!-- Restart it if it crashes -->
    <key>KeepAlive</key>
    <true/>

    <!-- Optional: log output somewhere -->
    <key>StandardOutPath</key>
    <string>/tmp/menuanywhere.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/menuanywhere.err</string>
</dict>
</plist>
```

Save and close.

---

## 3. Load the LaunchAgent

On newer macOS versions:

```bash
launchctl bootstrap gui/$UID ~/Library/LaunchAgents/com.john.menuanywhere.plist
```

On older macOS versions:

```bash
launchctl load ~/Library/LaunchAgents/com.john.menuanywhere.plist
```

Check that it’s running:

```bash
launchctl print gui/$UID/com.john.menuanywhere
# or
ps aux | grep menuanywhere
```

Now `menuanywhere` will start automatically at login.

---

## 4. Stop or disable later (optional)

```bash
launchctl bootout gui/$UID ~/Library/LaunchAgents/com.john.menuanywhere.plist
# or (older macOS)
launchctl unload ~/Library/LaunchAgents/com.john.menuanywhere.plist
```

---

## 5. Accessibility permissions

Because `menuanywhere` uses accessibility APIs, macOS may require permissions:

1. Open **System Settings → Privacy & Security → Accessibility**.
2. Ensure `menuanywhere` (or the terminal app you’re using) is allowed.

Once this is set, your hotkey should work after login with no extra steps.
