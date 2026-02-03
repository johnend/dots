# Water.nvim Project Context

**Type:** Personal Project (Neovim Plugin)  
**Status:** Extracted from dotfiles, functional, ready for use  
**Location:** `~/Developer/personal/water.nvim`  
**Created:** 2026-02-03  
**Language:** Lua  
**Lines of Code:** ~1,200

## Overview

Water.nvim is a fast, feature-rich buffer management plugin for Neovim. It provides a visual buffer list with git integration, diagnostics, smart timestamps, and preview functionality.

## Project Purpose

- **Primary Goal:** Provide a clean, informative buffer overview with metadata
- **Key Differentiator:** Combines git status, diagnostics, and relative timestamps in one view
- **Use Case:** Quick buffer navigation and management without leaving the keyboard

## Tech Stack

- **Language:** Lua 5.1 (Neovim runtime)
- **Dependencies:**
  - Neovim >= 0.9.0 (required)
  - gitsigns.nvim (optional, for git status)
  - Nerd Font (optional, for icons)
- **Plugin Manager:** Lazy.nvim (via local `dir` spec)

## Architecture

### Module Structure

```
lua/water/
├── init.lua          # Main entry point, setup function, commands
├── config.lua        # Configuration defaults and merging
├── state.lua         # Global state (bufnr, winid, options)
├── buffers.lua       # Buffer collection, sorting, metadata formatting
├── keymaps.lua       # Keymap application within Water buffer
├── autocmds.lua      # Auto-refresh on buffer changes
├── highlights.lua    # Highlight group definitions
└── ui/
    ├── water.lua     # Core UI rendering and window management
    ├── preview.lua   # Preview window (shows buffer content on cursor)
    └── help.lua      # Floating help window with keybindings
```

### Key Design Patterns

1. **Modular separation:** Each concern (config, state, UI, keymaps) is isolated
2. **State management:** Single source of truth in `state.lua`
3. **Debounced rendering:** 50ms debounce to prevent excessive redraws
4. **Highlight via extmarks:** Uses `nvim_buf_set_extmark` for precise highlighting
5. **Lazy loading:** Only renders when visible, auto-refreshes on buffer events

## Core Features

### 1. Buffer List Display
- Shows all loaded, listed buffers
- Columns: Buffer ID, Name, Diagnostics, Git Status, Last Modified
- Customizable sorting: `id`, `alphabetical`, `last_modified` (default)

### 2. Git Integration
- Shows added/changed/removed line counts via gitsigns.nvim
- Color-coded git status icons
- Updates automatically when buffer changes

### 3. Diagnostics
- Displays error/warning counts from LSP
- Uses Neovim's built-in `vim.diagnostic` API
- Customizable icons and colors

### 4. Smart Timestamps
- **Today:** Shows time only (e.g., "14:30")
- **Yesterday:** Shows "Yesterday at 14:30"
- **Older:** Shows date + time (e.g., "01/02 at 14:30")
- Supports 12h/24h time format and dd/mm or mm/dd date format

### 5. Preview Mode
- Press `p` to toggle preview window
- Shows first 50 lines of buffer under cursor
- Auto-updates as cursor moves
- Positioned bottom-right (40% × 50% of editor)

### 6. Help System
- Press `?` to show floating help window
- Lists all keybindings
- Auto-generated from config

## Configuration

### Default Options

```lua
{
  show_modified = true,
  show_readonly = true,
  show_diagnostics = true,
  highlight_cursorline = true,
  sort_buffers = "last_modified",
  use_nerd_icons = true,
  path_display = "short_path",  -- or "full_path", "file_name", function
  date_format = "dd/mm",
  time_format = "24h",
  delete_last_buf_fallback = "q",  -- or "enew", function
  icons = { git = {...}, diagnostics = {...} },
  keymaps = { toggle = "_", open_buffer = "<cr>", ... }
}
```

### Extensibility Points

- **Custom path display:** Provide function to format buffer paths
- **Custom delete fallback:** Control what happens when deleting last buffer
- **Icon customization:** Change git/diagnostic icons
- **Keymap overrides:** Remap all actions

## Commands & Keymaps

### Commands
- `:Water` - Toggle Water UI
- `:WaterRefresh` - Manually refresh buffer list

### Keymaps (in Water buffer)
- `_` - Toggle Water UI (global)
- `<CR>` - Open buffer under cursor
- `dd` - Delete buffer under cursor
- `s` - Open in horizontal split
- `v` - Open in vertical split
- `r` - Refresh buffer list
- `p` - Toggle preview mode
- `?` - Show help
- `q` / `<Esc>` - Close Water UI

## Development Workflow

### File Organization
- Core logic in `lua/water/` (8 files, ~900 LOC)
- UI components in `lua/water/ui/` (3 files, ~280 LOC)
- Plugin loader in `plugin/water.lua` (prevents double-loading)

### Testing Approach
- Manual testing via `nvim` (no automated tests yet)
- Test in local dotfiles before publishing

### Code Style
- LuaLS type annotations (`---@class`, `---@param`, `---@return`)
- 2-space indentation
- Descriptive function/variable names
- Comments explain WHY, not WHAT

## Integration with Dotfiles

### Current Setup
Water.nvim is loaded via Lazy.nvim in your dotfiles:

```lua
-- lua/core/plugins/utilities/water.lua
return {
  dir = vim.fn.expand("~/Developer/personal/water.nvim"),
  name = "water.nvim",
  dependencies = { "lewis6991/gitsigns.nvim" },
  config = function()
    require("water").setup({ ... })
  end,
}
```

### Migration Path
1. **Current:** Local `dir` pointing to water.nvim
2. **Future:** Publish to GitHub, use `"yourusername/water.nvim"`
3. **Optional:** Add to awesome-neovim list

## Known Limitations

1. **No automated tests** - Testing is manual
2. **Preview limited to 50 lines** - Performance trade-off
3. **Requires gitsigns** - Git status won't show without it
4. **No vim help docs** - Only has `?` help window (no `:help water`)

## Future Possibilities

### Potential Features
- [ ] Multiple view modes (compact, detailed, tree)
- [ ] Session management (save/restore buffer sets)
- [ ] Buffer grouping by project/directory
- [ ] Search/filter buffers by name
- [ ] Recently closed buffers list
- [ ] Integration with telescope.nvim

### Potential Improvements
- [ ] Add automated tests (plenary.nvim)
- [ ] Generate vim help docs from README
- [ ] Performance optimization for 100+ buffers
- [ ] Configurable column visibility
- [ ] Tmux/terminal buffer detection

## Publishing Considerations

### If you decide to publish:
1. **GitHub repo:** Create public repo, push code
2. **README polish:** Already comprehensive
3. **Screenshots:** Add GIF/PNG showing features
4. **Version tag:** Start with `v1.0.0`
5. **License:** MIT (already added)
6. **Changelog:** Document versions going forward

### If you keep it private:
- Still valuable as personal tool
- Can iterate freely without versioning concerns
- Easy to customize without breaking others

## Notes for AI Agents

### When working on water.nvim:
1. **Type safety:** Maintain LuaLS annotations
2. **State management:** Always update via `state.lua`, never direct globals
3. **Performance:** Keep rendering fast, use debouncing for frequent updates
4. **Compatibility:** Target Neovim 0.9+ (avoid 0.10-specific APIs unless necessary)
5. **Documentation:** Update README when adding features

### Code patterns to follow:
- Use `pcall` for API calls that might fail (extmarks, etc.)
- Use `vim.schedule` for deferred operations
- Use namespaces for highlight groups/extmarks
- Check buffer/window validity before operations

### Testing checklist:
- [ ] Toggle water with `_`
- [ ] Navigate buffers with `<CR>`
- [ ] Delete buffer with `dd`
- [ ] Preview with `p`
- [ ] Help with `?`
- [ ] Refresh with `r`
- [ ] Git status shows (if gitsigns active)
- [ ] Diagnostics show (if LSP active)
- [ ] Timestamps format correctly

## Related Projects

Similar buffer management plugins (for reference):
- bufferline.nvim - Tabline-style buffer list
- barbar.nvim - Tabline with animations
- telescope-buffers - Fuzzy find buffers
- harpoon - Mark specific buffers

Water.nvim differentiates by:
- Dedicated full-window view (not tabline)
- Emphasis on metadata (git, diagnostics, timestamps)
- Preview mode without switching buffers

---

**Last Updated:** 2026-02-03  
**Source:** Extracted from personal dotfiles  
**Status:** Functional, ready for use/publication
