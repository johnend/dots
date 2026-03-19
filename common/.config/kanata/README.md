# Kanata Notes

## Current Status

- `apple_integrated.kbd` is the first Kanata migration target.
- The shared config lives in `common/.config/kanata` so it can be reused on Linux and macOS.
- Linux device selection is handled in a platform-specific `defcfg` block inside the shared config.

## Apple Integrated Layout

- `Tab`: tap for `Esc`, hold for Hyper
- `Caps Lock`: tap for `Tab`, hold for Meh
- `a s d f / j k l ;`: homerow mods on the `base` layer
- `fn`: toggles between `base` and `plain`
- `plain`: raw typing layer without homerow mods or navigation tap-holds

## Homerow Mods

- Uses `tap-hold-release-tap-keys-release` with `200ms` tap/hold timing.
- Same-hand alpha rolls are listed as tap keys so rolls like `as`, `df`, `jk`, `kl` resolve to letters instead of modifiers.
- Opposite-hand presses can still resolve to held modifiers for shortcuts.

## Notifications

- `notify-layer.sh` lives alongside the config in `~/.config/kanata`.
- Linux uses `notify-send`.
- macOS uses `osascript display notification`.

## macOS Follow-up

- Run `kanata --list` on macOS and add a `macos-dev-names-include` block once the Apple keyboard name is confirmed.
- The rest of the config logic should carry over unchanged.
