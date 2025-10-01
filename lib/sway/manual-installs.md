# Manual Installation Required

These components need to be manually installed as they're not available in official repositories or AUR:

## Icon & Cursor Themes

### BreezeX-RosePine Cursor Theme

- **Source:** https://www.gnome-look.org/p/1810549
- **Description:** Rose Pine variant of BreezeX cursor theme
- **Installation:** Download and extract to `~/.local/share/icons/` or `/usr/share/icons/`
- **Used in:** GTK settings (`gtk-cursor-theme-name=BreezeX-RosePine-Linux`)

### oomox-Rose-Pine-Main Icon Theme

- **Source:** Generated using themix/oomox tool
- **Description:** Rose Pine colored icon theme
- **Installation:**
  1. Install `themix-full-git` from AUR
  2. Generate theme using themix GUI with Rose Pine colors
  3. Or manually install pre-generated theme if available
- **Used in:** GTK settings (`gtk-icon-theme-name=Rose-Pine`)

- Can also check: https://www.gnome-look.org/p/1810549

## Additional Notes

- Base icon themes (`adwaita-icon-theme`, `hicolor-icon-theme`) are included in the package list to provide fallbacks
- `rose-pine-cursor` is available via AUR and included in package list as alternative
- These manual themes enhance the Rose Pine aesthetic but aren't required for basic functionality

