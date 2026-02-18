# Neovim Design System - TODO Checklist

## Phase 1: Centralize Existing Config (IN PROGRESS - 1/11)

### ✅ Completed

- [x] **Investigation & Documentation**
  - [x] Research Base46 approach
  - [x] Decide not to use Base46
  - [x] Create Obsidian vault documentation (6 files)
  - [x] Enhance `lua/config/ui.lua` with full structure
  - [x] Audit all plugin configs
  - [x] Create `AGENTS.md` and `TODO.md`

- [x] **Blink.cmp** (First plugin complete!)
  - [x] Line 160: `documentation.window.border` → `UI.borders.documentation`
  - [x] Line 166: `menu.border` → `UI.borders.completion`
  - [x] Line 252: `signature.window.border` → `UI.borders.signature`

### 🔨 In Progress (10 remaining)

#### High Priority (Most Visible)

- [ ] **Telescope** (`lua/plugins/navigation/telescope.lua`)
  - [ ] Centralize borders
  - [ ] Centralize layouts (dropdown, wide_preview, compact, project, todo)
  - [ ] Update prompt_prefix and selection_caret to use Icons
  - [ ] Remove hardcoded theme configurations
  - **Impact:** Biggest visual impact, used constantly

- [ ] **Trouble** (`lua/plugins/devtools/trouble.lua`)
  - [ ] Main window border → `UI.trouble.main_window.border` (currently "single")
  - [ ] Preview window border → `UI.trouble.preview_window.border` (currently "rounded")
  - **Impact:** High, frequently used for diagnostics

#### Medium Priority (Frequently Used)

- [ ] **Noice** (`lua/plugins/ui/noice.lua`)
  - [ ] Cmdline border → `UI.noice.cmdline.border`
  - [ ] Cmdline position → `UI.noice.cmdline.position`
  - [ ] Cmdline size → `UI.noice.cmdline.size`
  - [ ] Popupmenu border → `UI.noice.popupmenu.border`
  - [ ] Popupmenu position → `UI.noice.popupmenu.position`
  - [ ] Popupmenu size → `UI.noice.popupmenu.size`
  - [ ] Hover border → `UI.noice.hover.border`
  - [ ] Mini winblend → `UI.noice.mini.winblend`
  - **Impact:** Affects command-line and notifications

- [ ] **Which-key** (`lua/plugins/devtools/which-key.lua`)
  - [ ] Border → `UI.which_key.border`
  - [ ] Padding → `UI.which_key.padding`
  - [ ] Winblend → `UI.which_key.winblend`
  - **Impact:** Medium, shown when pausing during key sequences

- [ ] **LSP Init** (`lua/plugins/lsp/init.lua`)
  - [ ] Mason border → `UI.borders.mason`
  - [ ] Diagnostic float border → `UI.borders.diagnostic`
  - **Impact:** Medium, LSP configuration affects all coding

#### Lower Priority (Less Frequently Visible)

- [ ] **Toggleterm** (`lua/plugins/devtools/toggleterm.lua`)
  - [ ] Main terminal border → `UI.terminal.toggleterm.float_opts.border`
  - [ ] Lazygit terminal border → `UI.terminal.toggleterm.float_opts.border`
  - [ ] gh-dash terminal border → `UI.terminal.toggleterm.float_opts.border`
  - **Impact:** Only when using terminal

- [ ] **Neo-tree** (`lua/plugins/navigation/neo-tree.lua`)
  - [ ] Popup border style → `UI.tree.neo_tree.popup_border_style`
  - **Impact:** Low, only for neo-tree popups

- [ ] **Gitsigns** (`lua/plugins/git/gitsigns.lua`)
  - [ ] Preview border → `UI.gitsigns.preview.border`
  - [ ] Preview style → `UI.gitsigns.preview.style`
  - [ ] Preview position → `UI.gitsigns.preview.relative/row/col`
  - **Impact:** Low, only for git hunk previews

- [ ] **Actions Preview** (`lua/plugins/lsp/actions-preview.lua`)
  - [ ] Telescope layout → `UI.actions_preview.telescope`
  - **Impact:** Low, only for code actions

- [ ] **Lazy.nvim** (`init.lua`)
  - [ ] Line in init.lua: `lazy_opts.ui.border` → `UI.borders.lazy`
  - **Impact:** Very low, only when managing plugins

#### Already Working

- ✅ **Snacks** (`lua/plugins/utilities/snacks.lua`)
  - Already partially uses `UI.border` (good reference example)
  - May need more comprehensive updates later

---

## Phase 2: Color Extraction System (NOT STARTED)

### Planning

- [ ] **Design the extraction API**
  - [ ] Determine which highlight groups to extract from (Normal, Visual, etc.)
  - [ ] Design color manipulation utilities (lighten, darken, blend)
  - [ ] Define derived color palette structure

- [ ] **Implement color extraction**
  - [ ] Enhance `lua/config/colors.lua`
  - [ ] Add `get_active_palette()` function
  - [ ] Add `get_derived_palette()` function
  - [ ] Add color utilities (lighten, darken, blend, etc.)
  
- [ ] **Test with multiple colorschemes**
  - [ ] Test with Tokyonight
  - [ ] Test with Catppuccin
  - [ ] Test with Kanagawa
  - [ ] Test with Rose Pine
  - [ ] Test with Gruvbox
  - [ ] Verify colors extracted correctly from each

- [ ] **Create color refresh mechanism**
  - [ ] Hook into ColorScheme autocmd
  - [ ] Auto-reload colors on colorscheme change
  - [ ] Ensure derived palette updates

### Files to Create/Modify

- [ ] `lua/config/colors.lua` - Major enhancement
  - Add extraction functions
  - Add color manipulation utilities
  - Add derived palette generation

---

## Phase 3: Highlight Override System (NOT STARTED)

### Directory Structure

- [ ] **Create highlights directory**
  ```
  lua/config/highlights/
  ├── init.lua           # Master setup + auto-reload
  ├── telescope.lua      # Telescope highlights
  ├── blink.lua          # Blink.cmp highlights
  ├── trouble.lua        # Trouble highlights
  ├── lsp.lua            # LSP highlights
  ├── mason.lua          # Mason highlights (optional)
  ├── which-key.lua      # Which-key highlights (optional)
  └── neo-tree.lua       # Neo-tree highlights (optional)
  ```

### Implementation Tasks

- [ ] **Create master highlights system**
  - [ ] `lua/config/highlights/init.lua`
  - [ ] Auto-reload on colorscheme change
  - [ ] Apply all plugin highlights
  - [ ] Handle errors gracefully

- [ ] **Create per-plugin highlight files**
  - [ ] `telescope.lua` - Selection, prompt, results, borders
  - [ ] `blink.lua` - Completion menu, documentation, signature
  - [ ] `trouble.lua` - List items, preview, severity levels
  - [ ] `lsp.lua` - Hover, diagnostic floats, references
  - [ ] `mason.lua` - Optional polish
  - [ ] `which-key.lua` - Optional polish
  - [ ] `neo-tree.lua` - Optional polish

- [ ] **Integration**
  - [ ] Load highlights system in `init.lua`
  - [ ] Test auto-reload functionality
  - [ ] Verify highlights work with multiple colorschemes

---

## Phase 4: Polish & Iterate (NOT STARTED)

- [ ] Daily usage testing
- [ ] Refinements based on real usage
- [ ] Edge case handling
- [ ] Performance optimization
- [ ] Documentation updates

---

## Making It Shareable (FUTURE)

### Documentation Options

- [ ] **Option A: Blog Post / Guide**
  - [ ] Write comprehensive guide
  - [ ] Include before/after comparisons
  - [ ] Share implementation patterns

- [ ] **Option B: Neovim Plugin**
  - [ ] Extract design system into standalone plugin
  - [ ] Make it work with any Neovim config
  - [ ] Publish to GitHub

- [ ] **Option C: Dotfiles Showcase**
  - [ ] Polish existing dotfiles
  - [ ] Add comprehensive README
  - [ ] Share on r/neovim

---

## Testing Checklist (After Each Refactoring)

When you refactor a plugin, follow these steps:

1. [ ] Launch Neovim
2. [ ] Test affected plugin functionality
3. [ ] Verify borders/layouts look correct
4. [ ] Change `UI.borders.default` to test token system works
5. [ ] Revert change and test again
6. [ ] Check for any Lua errors (`:messages`)
7. [ ] Commit if working

---

## Useful Commands

```bash
# View design tokens
nvim ~/.config/nvim/lua/config/ui.lua

# View a plugin to refactor
nvim ~/.config/nvim/lua/plugins/navigation/telescope.lua

# Test changes
nvim

# Check for errors after changes
# In Neovim: :messages

# Git workflow (if creating branch)
git checkout -b feat/design-system
git add lua/plugins/lsp/blink.lua
git commit -m "feat: refactor blink.cmp to use UI design tokens"
```

---

## Notes

### Key Files

- **Design Tokens:** `lua/config/ui.lua` - THE source of truth
- **Icons:** `lua/config/icons.lua` - Already centralized (working!)
- **Colors:** `lua/config/colors.lua` - Needs Phase 2 enhancement
- **Highlights:** `lua/config/highlights/` - Needs Phase 3 creation

### Pattern to Follow

**❌ Before (hardcoded):**
```lua
completion = {
  menu = {
    border = "rounded"  -- Hardcoded
  }
}
```

**✅ After (design tokens):**
```lua
completion = {
  menu = {
    border = UI.borders.completion  -- Token reference
  }
}
```

### Current Progress

- **Phase 1:** 1/11 plugins complete (9%)
- **Phase 2:** Not started (0%)
- **Phase 3:** Not started (0%)

### Estimated Time

- **Phase 1:** ~2-3 hours (30 min per plugin × 10 remaining)
- **Phase 2:** ~2-3 hours (design + implementation + testing)
- **Phase 3:** ~4-6 hours (setup + 7 plugin highlights)

**Total:** ~8-12 hours of focused work

---

**Last Updated:** Feb 11, 2026  
**Current Status:** Phase 1 - 1/11 plugins refactored  
**Next Task:** Refactor Telescope (highest impact)
