# Neovim Design System Project

## Overview

This Neovim configuration is in the process of implementing a **React-style design system** for UI consistency. The goal is to achieve a single source of truth for UI properties (borders, layouts, colors, etc.) that can be changed in one place and automatically update across all plugins.

## The Concept

### Think: React Design Tokens

In React, you might have:

```tsx
// tokens.ts - Single source of truth
const tokens = {
  border: { radius: "8px", style: "solid" }
}

// Button.tsx - Consumes tokens
<Button style={{ borderRadius: tokens.border.radius }} />

// Modal.tsx - Consumes tokens  
<Modal style={{ borderRadius: tokens.border.radius }} />

// Change tokens → both components update automatically!
```

In Neovim, we're building the same pattern:

```lua
-- lua/config/ui.lua - Single source of truth (DESIGN TOKENS)
UI = {
  borders = {
    default = "rounded",
    completion = "rounded",
    documentation = "rounded",
  }
}

-- lua/plugins/lsp/blink.lua - Consumes tokens
completion = {
  menu = { border = UI.borders.completion },  -- ✅ Token reference
  documentation = { border = UI.borders.documentation },
}

-- Change UI.borders.completion = "single" → all plugins update!
```

## Why Are We Doing This?

### Problems with Current Approach
- **Hardcoded values everywhere**: `border = "rounded"` repeated in 11+ plugin configs
- **Inconsistent UI**: Easy for plugins to drift and look different
- **Hard to customize**: Want to change all borders? Edit 20+ lines across 11 files
- **No centralized control**: No way to enforce design consistency

### What We're Building
- **Design tokens**: `lua/config/ui.lua` as single source of truth
- **Token consumption**: All plugins reference `UI.*` instead of hardcoding
- **One-line changes**: Change `UI.borders.default` → all plugins update
- **Color extraction**: Dynamically pull colors from active colorscheme (Phase 2)
- **Custom highlights**: Per-plugin theming that adapts to any colorscheme (Phase 3)

## Goals

1. **Flexibility**: Keep ability to use ANY colorscheme (not locked to base46's 94 themes)
2. **Consistency**: All plugins use same borders, layouts, colors
3. **Maintainability**: Change UI properties in one place
4. **Polish**: Achieve NvChad-level visual consistency without NvChad's architecture

## Current Architecture

### Design Token Files
```
lua/config/
├── ui.lua           ✅ Design tokens (borders, layouts, sizes)
├── colors.lua       🔜 Color extraction (Phase 2)
├── icons.lua        ✅ Icon definitions (already working)
└── highlights/      🔜 Custom highlights (Phase 3)
    ├── init.lua
    ├── telescope.lua
    ├── blink.lua
    └── ...
```

### Plugin Files (Consumers)
```
lua/plugins/
├── lsp/
│   ├── blink.lua          ✅ REFACTORED (uses UI.borders.*)
│   ├── init.lua           ⬜ TODO
│   └── actions-preview.lua ⬜ TODO
├── navigation/
│   ├── telescope.lua      ⬜ TODO (borders + layouts)
│   └── neo-tree.lua       ⬜ TODO
├── devtools/
│   ├── trouble.lua        ⬜ TODO
│   ├── which-key.lua      ⬜ TODO
│   └── toggleterm.lua     ⬜ TODO
├── ui/
│   └── noice.lua          ⬜ TODO
├── utilities/
│   └── snacks.lua         ⚠️  PARTIAL (already uses UI.border)
└── git/
    └── gitsigns.lua       ⬜ TODO
```

## Implementation Phases

### ✅ Phase 0: Investigation & Documentation (COMPLETE)
- Researched NvChad's Base46 approach
- Decided NOT to use Base46 (incompatible with colorscheme flexibility)
- Created comprehensive documentation in Obsidian vault
- Enhanced `lua/config/ui.lua` with full design token structure
- Audited all 11 plugin configs

### 🔨 Phase 1: Centralize Existing Config (IN PROGRESS - 1/11 done)
**Goal:** Make all plugins reference `UI` config instead of hardcoding

**Progress:**
- ✅ **Blink.cmp** - Refactored to use `UI.borders.{completion,documentation,signature}`
- ⬜ **Telescope** - Needs borders + layouts centralized
- ⬜ **Trouble** - Needs main + preview borders
- ⬜ **Neo-tree** - Needs popup borders
- ⬜ **LSP (init.lua)** - Needs mason + diagnostic float borders
- ⬜ **Which-key** - Needs borders + padding + winblend
- ⬜ **Noice** - Multiple borders and layouts
- ⬜ **Toggleterm** - Borders in 3 places (main, lazygit, gh-dash)
- ⬜ **Gitsigns** - Preview border
- ⬜ **Actions-preview** - Telescope layout
- ⬜ **Lazy.nvim (init.lua)** - UI border

**Impact:** Single source of truth for structural UI decisions (borders, layouts, sizes)

### 🔜 Phase 2: Color Extraction System (NOT STARTED)
**Goal:** Dynamically extract colors from active colorscheme

**What we'll build:**
- Enhance `lua/config/colors.lua` with extraction functions
- Implement color manipulation utilities (lighten/darken)
- Create derived color palette (darker_bg, lighter_bg, selection_bg, etc.)
- Test with 5+ different colorschemes

**Example:**
```lua
-- lua/config/colors.lua
Colors = {
  bg = "#1e1e2e",           -- Extracted from Normal
  fg = "#cdd6f4",           -- Extracted from Normal
  darker_bg = "#181825",    -- Derived (6% darker)
  selection_bg = "#313244", -- Derived
  -- ... etc
}
```

### 🔜 Phase 3: Highlight Override System (NOT STARTED)
**Goal:** Apply custom highlights to key plugins

**What we'll build:**
- Create `lua/config/highlights/` directory
- Master setup with auto-reload on colorscheme change
- Per-plugin highlight files:
  - `telescope.lua` - Selection, prompt, results theming
  - `blink.lua` - Completion menu theming
  - `trouble.lua` - List and preview theming
  - `lsp.lua` - Hover, diagnostic theming
  - Others as needed

**Example:**
```lua
-- lua/config/highlights/telescope.lua
return {
  TelescopeSelection = { bg = Colors.selection_bg, fg = Colors.fg },
  TelescopePromptBorder = { fg = Colors.blue },
  TelescopeResultsBorder = { fg = Colors.darker_bg },
}
```

### 🔜 Phase 4: Polish & Iterate (NOT STARTED)
**Goal:** Refine based on daily usage

## What We Just Did (Feb 11, 2026)

### Blink.cmp Refactoring (First Plugin Complete!)

**Changed 3 hardcoded borders to design tokens:**

```diff
# lua/plugins/lsp/blink.lua

- documentation = { window = { border = "rounded" } }
+ documentation = { window = { border = UI.borders.documentation } }

- menu = { border = "rounded" }
+ menu = { border = UI.borders.completion }

- signature = { window = { border = "rounded" } }
+ signature = { window = { border = UI.borders.signature }
```

**Now you can change borders in one place:**
```lua
-- lua/config/ui.lua
UI.borders.completion = "single"  -- Changes ALL completion borders!
```

## Next Steps

### Immediate (Next Session)
1. **Refactor Telescope** - Biggest impact (most visible plugin)
   - Centralize borders
   - Centralize layouts (dropdown, wide_preview, compact)
   - Remove hardcoded theme configurations
   
2. **Refactor Trouble** - Second highest impact
   - Main window border
   - Preview window border
   
3. **Continue down the list** - Keep momentum going

### Future Work
- Phase 2: Color extraction (pull colors from colorscheme)
- Phase 3: Custom highlights (per-plugin theming)
- Phase 4: Documentation for others to use

## Key Design Decisions

### Why Not Use Base46?
- **Would require removing all 15+ colorschemes** (locked to base46's 94 themes)
- **Architecture incompatible** (needs nvconfig, chadrc.lua, complete refactor)
- **Would replace lualine, alpha-dashboard**
- **Fundamentally conflicts with colorscheme flexibility goal**

**Decision:** Learn from Base46's patterns, but don't adopt it.

### Why This Approach?
- **Minimal refactoring**: Change config values, not architecture
- **Incremental adoption**: One plugin at a time
- **Keeps flexibility**: Works with ANY colorscheme
- **Maintainable**: Clear separation of tokens vs. consumption
- **Future-proof**: Can add Phase 2 & 3 without breaking Phase 1

## Related Documentation

### Obsidian Vault (Comprehensive Docs)
Location: `~/Developer/personal/Obsidian/Personal/Knowledge/Tools/NeoVim/Design-System/`

Files:
- `README.md` - Directory overview
- `Neovim-Design-System-Project-Index.md` - Master document with full roadmap
- `Neovim-Design-System-Base46-Inspiration.md` - Base46 analysis
- `Neovim-Highlight-Overrides-Implementation.md` - Phase 3 implementation guide
- `Neovim-Config-UI-Audit.md` - Current state analysis
- `Making-It-Shareable.md` - Strategies for sharing

### Local Files
- `TODO.md` - Detailed checklist (this directory)
- `AGENTS.md` - This file (high-level overview)
- `lua/config/ui.lua` - Design tokens (THE source of truth)

## Testing Strategy

After each plugin refactoring:
1. Launch Neovim
2. Test affected plugin functionality
3. Verify borders/layouts still look correct
4. Try changing `UI.borders.default` to confirm it works
5. Commit if working

## Commands for Future Reference

```bash
# View current UI tokens
nvim ~/.config/nvim/lua/config/ui.lua

# View refactoring checklist
nvim ~/.config/nvim/TODO.md

# Test a plugin config
nvim ~/.config/nvim/lua/plugins/lsp/blink.lua

# Launch Neovim to test changes
nvim
```

## Success Criteria

**Phase 1 Success:**
- All 11 plugins reference `UI.*` instead of hardcoding
- Can change `UI.borders.default` and see all plugins update
- No visual regressions
- Single source of truth for UI properties

**Phase 2 Success:**
- Colors dynamically extracted from any colorscheme
- Derived palette (darker_bg, lighter_bg, etc.) working
- Tested with 5+ colorschemes
- Smooth colorscheme switching

**Phase 3 Success:**
- Custom highlights applied to key plugins
- Highlights adapt to active colorscheme colors
- Auto-reload on colorscheme change
- Polished, consistent look across all plugins

**Overall Success:**
- NvChad-level polish without NvChad's architecture
- Works with ANY colorscheme
- Single-line UI changes propagate everywhere
- Shareable pattern others can adopt

---

**Status:** Phase 1 in progress (1/11 plugins complete)  
**Last Updated:** Feb 11, 2026  
**Next Session:** Continue Phase 1 refactoring (Telescope or Trouble)
