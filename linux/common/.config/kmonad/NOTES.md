# KMonad Configuration Notes

## Current Setup

### Homerow Mods
- **Type**: `tap-hold-next-release` with 200ms timeout
- **Left hand**: a=Shift, s=Gui, d=Alt, f=Ctrl
- **Right hand**: j=Ctrl, k=Alt, l=Gui, ;=Shift
- **Status**: Working reasonably well, slight improvement over initial 175ms `tap-hold-next`

### Layer Notifications
- **Working**: ✅ Notifications now display on layer switch
- **Fix required**: Added `--allow-cmd` flag to systemd service
- **Script**: `~/.config/kmonad/notify-layer.sh` handles D-Bus environment for notifications

## Future Ideas to Try

### Bilateral Homerow Mods
**Concept**: Only allow cross-hand modifier activation (left-hand mod + right-hand key, or vice versa)

**Benefits**:
- Prevents same-hand combinations like "as", "df", "jk", "kl" from accidentally triggering modifiers
- Significantly reduces misfires during fast typing
- Still allows all modifier combinations when used intentionally

**KMonad Support**: ❌ **Not natively supported**
- KMonad's `tap-hold-next-release` doesn't distinguish between same-hand vs opposite-hand keys
- Would require complex layer-based workarounds that are impractical

**Alternatives**:
- **Kanata**: KMonad alternative with better homerow mod support including bilateral combinations
- **QMK Firmware**: If keyboard supports it, has native `BILATERAL_COMBINATIONS` feature
- **Increase timing**: Simpler solution - use 225-250ms timeout in current setup
- **Remove modifiers**: Keep only Ctrl+Shift, remove Gui/Alt to reduce misfire points

**When to try**: If current setup still has too many accidental modifier activations, consider switching to Kanata or simplifying the mod setup

### Other Timing Adjustments
- Could increase timeout to 225-250ms if still getting occasional misfires
- Could use different timings per finger (longer for index fingers, shorter for pinkies)

### Simplified Homerow Mods
- Option to remove less-used modifiers (Gui/Alt) and keep only Ctrl + Shift
- Reduces potential misfire points while keeping most useful shortcuts

## Troubleshooting

### Notifications Not Working
- Ensure `--allow-cmd` flag is in systemd service: `/usr/bin/kmonad --allow-cmd ...`
- Check D-Bus environment in notification script
- Verify script has execute permissions

### Homerow Mod Misfires
1. Increase timing (200ms → 225ms or 250ms)
2. Try bilateral mods (prevent same-hand activation)
3. Remove less-used modifiers
4. Use `tap-hold-next-release` instead of `tap-hold-next`
