# Neovim Scripts

## resign-libs.sh

Re-signs all Neovim plugin native libraries (.so and .dylib files) for macOS 15+ compatibility.

### Problem

macOS 15.7.1+ introduced stricter code signing requirements that reject adhoc-signed native libraries built by plugin managers. This causes Neovim to crash with "Code Signature Invalid" (SIGKILL) when loading:

- TreeSitter parsers (`.so` files)
- Plugin native dependencies (`.dylib` files) 
- Compiled extensions (blink.cmp, LuaSnip, telescope-fzf-native, etc.)

### Solution

This script automatically finds and re-signs all native libraries with valid adhoc signatures that macOS 15 accepts.

### Usage

```bash
# Run from anywhere
~/.config/nvim/scripts/resign-libs.sh

# Or make it executable and run directly
chmod +x ~/.config/nvim/scripts/resign-libs.sh
./resign-libs.sh
```

### When to Run

Run this script after:

- `:TSUpdate` or `:TSInstall` - Updates/installs TreeSitter parsers
- Plugin updates that compile native code
- Installing new plugins with native dependencies
- Upgrading to macOS 15 from earlier versions

### Features

- ✅ Scans all libraries in `~/.local/share/nvim`
- ✅ Skips libraries that already have valid signatures (fast re-runs)
- ✅ Colorized output for easy reading
- ✅ Detailed logging to `~/.local/share/nvim/resign-libs.log`
- ✅ Summary report with counts
- ✅ Error handling and verification

### Output Example

```
[INFO] Starting library re-signing for macOS 15+ compatibility...
[INFO] Found 376 native libraries

[SUCCESS] [1/376] Already valid: mason/packages/codelldb/...
[1/376] Re-signing: site/parser/json.so ... Done
...

======================================
Re-signing Summary
======================================
Total libraries found:  376
Successfully re-signed: 375
Already valid (skipped): 1
Failed:                 0
======================================

[SUCCESS] All libraries have been re-signed successfully!
```

### Troubleshooting

If you see failures:
1. Check the log file: `~/.local/share/nvim/resign-libs.log`
2. Ensure you're running on macOS (script only runs on macOS)
3. Verify you have the `codesign` tool available (comes with Xcode Command Line Tools)

### Notes

- This issue only affects macOS 15+
- The script is idempotent - safe to run multiple times
- Test parsers in plugins may fail to re-sign but don't affect normal operation
- macOS 14 and earlier don't need this script
