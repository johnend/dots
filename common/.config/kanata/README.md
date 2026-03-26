# Kanata Notes

## Current Status

- `apple_integrated.kbd` is the first Kanata migration target.
- `hi86.kbd` mirrors the Apple Kanata behavior on the BY Tech Hi86 layout.
- The shared config lives in `common/.config/kanata` so it can be reused on Linux and macOS.
- Linux device selection is handled in a platform-specific `defcfg` block inside the shared config.

## Apple Integrated Layout

- `Tab`: tap for `Esc`, hold for Hyper
- `Caps Lock`: tap for `Tab`, hold for Meh
- the `base` layer is mostly plain letters, with `;` restored as a `Ctrl` homerow mod
- `fn`: double tap from `base` to enter `plain`, single tap in `plain` to return to `base`
- `plain`: raw typing layer without homerow mods or navigation tap-holds

## Hi86 Layout

- Uses the Hi86 physical matrix from the KMonad config, including navigation cluster and full bottom row.
- Matches the Apple Kanata behavior: `Tab` tap/hold for `Esc`/Hyper, `Caps Lock` tap/hold for `Tab`/Meh, and only `;` active as a homerow `Ctrl` on `base`.
- `pause`: double tap from `base` to enter `plain`, single tap in `plain` to return to `base`
- `plain`: raw typing layer without homerow mods or navigation tap-holds

## Homerow Mods

- Homerow mod aliases are still defined for later experiments, but only `;` is active on the `base` layer right now as `Ctrl`.
- `base` currently favors raw typing, with `plain` available as a more deliberate fallback layer.

## Notifications

- `notify-layer.sh` lives alongside the config in `~/.config/kanata`.
- Linux uses `notify-send`.
- macOS uses `osascript display notification`.

## macOS Follow-up

- Run `kanata --list` on macOS and add a `macos-dev-names-include` block once the Apple keyboard name is confirmed.
- The rest of the config logic should carry over unchanged.
