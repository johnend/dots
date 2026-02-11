# Tabline Setup Guide

## What We Implemented

NvChad-style tabline with **per-tab buffer scoping** using lualine + scope.nvim.

### Visual Layout

```
 📄 init.lua  🔵 config.lua  helpers.ts     Tab 1 | Tab 2
 └─────────── Buffers (left) ─────────┘     └ Tabs (right) ┘
```

## How It Works

### Components

1. **Lualine Tabline** - Renders the top bar
   - Left side: Buffer tabs
   - Right side: Vim tabs (only shows when >1 tab exists)

2. **Scope.nvim** - Makes buffers tab-scoped
   - Each tab tracks its own buffer list
   - Buffers opened in Tab 1 only show in Tab 1
   - Buffers opened in Tab 2 only show in Tab 2

### The "Hack" Explained

**Traditional Vim:**
- Tabline shows Vim tabs (workspaces)
- Buffers are hidden (managed via `:ls`, `:bnext`)

**Modern Neovim (What We Built):**
- Tabline shows buffers (styled as tabs)
- Vim tabs still exist (shown on right)
- Best of both worlds!

## Usage

### Working with Buffers

**Open files (creates buffers):**
```vim
:e file.txt           " Open file.txt
:split other.txt      " Open other.txt in split
Telescope find_files  " Fuzzy find and open
```

**Navigate buffers:**
```vim
:bnext  or :bn        " Next buffer
:bprev  or :bp        " Previous buffer
:buffer 3  or :b 3    " Go to buffer 3
:bdelete  or :bd      " Close current buffer
```

**Click buffers:**
- Click on buffer tab to switch (mouse support)
- Modified buffers show `~` indicator

### Working with Tabs

**Create new tabs:**
```vim
:tabnew               " New empty tab
:tabnew file.txt      " Open file.txt in new tab
:tabedit file.txt     " Same as tabnew
:tabe file.txt        " Short version
```

**Navigate tabs:**
```vim
:tabnext  or :tabn    " Next tab
:tabprev  or :tabp    " Previous tab
gt                    " Normal mode: next tab
gT                    " Normal mode: previous tab
3gt                   " Normal mode: go to tab 3
```

**Manage tabs:**
```vim
:tabclose  or :tabc   " Close current tab
:tabonly   or :tabo   " Close all other tabs
:tabs                 " List all tabs
```

### Per-Tab Buffer Scoping

**Example workflow:**

```vim
" Start in Tab 1
:e api.ts             " Opens in Tab 1
:e types.ts           " Opens in Tab 1
" Tabline shows: api.ts | types.ts

" Create Tab 2
:tabnew
:e test.ts            " Opens in Tab 2
:e utils.ts           " Opens in Tab 2
" Tabline shows: test.ts | utils.ts

" Switch back to Tab 1
:tabprev
" Tabline shows: api.ts | types.ts (Tab 2's buffers NOT shown!)
```

**Key Insight:** Each tab has its own buffer list!

## Configuration Files

### Main Config
- `lua/plugins/ui/lualine.lua` - Lualine + scope.nvim setup

### Tabline Components
- `lua/config/lualine/tabline.lua` - Buffer and tab component definitions

### Statusline Components  
- `lua/config/lualine/components.lua` - Existing statusline components

## Customization

### Buffer Display Mode

Edit `lua/config/lualine/tabline.lua`:

```lua
M.buffers = {
  "buffers",
  mode = 2, -- Change this!
  -- 0: buffer name only
  -- 1: buffer index only
  -- 2: buffer name + index (current)
  -- 3: buffer number only
  -- 4: buffer name + number
}
```

### Tab Display Mode

```lua
M.tabs = {
  "tabs",
  mode = 1, -- Change this!
  -- 0: tab number
  -- 1: tab name (current)
  -- 2: tab number + name
}
```

### Buffer Width

Control how much space buffers take:

```lua
max_length = function()
  return vim.o.columns * 2 / 3 -- Use 2/3 of screen
end
```

### Hide Tabs Component

If you never use Vim tabs, remove the tabs component:

```lua
-- In lua/plugins/ui/lualine.lua
tabline = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = { tabline_components.buffers },
  lualine_x = {},
  lualine_y = {},
  lualine_z = {}, -- Remove: tabline_components.tabs
}
```

### Scope.nvim Options

Edit `lua/plugins/ui/lualine.lua`:

```lua
dependencies = {
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    opts = {
      hooks = {
        pre_tab_enter = function()
          -- Custom logic before entering tab
        end,
      },
    },
  },
}
```

## Tips & Tricks

### Workflow Suggestions

**Tab per project:**
```vim
" Tab 1: Frontend
:e src/App.tsx
:e src/components/Button.tsx

" Tab 2: Backend  
:tabnew
:e server/api.ts
:e server/db.ts

" Tab 3: Tests
:tabnew
:e tests/integration.test.ts
```

**Tab per feature:**
```vim
" Tab 1: Auth feature
:e auth/login.ts
:e auth/middleware.ts

" Tab 2: Payment feature
:tabnew
:e payment/checkout.ts
:e payment/stripe.ts
```

### Commands to Know

```vim
:ScopeMoveBuf 2       " Move current buffer to tab 2
:Telescope buffers    " Fuzzy find ALL buffers (across tabs)
:Telescope scope      " Fuzzy find buffers in CURRENT tab
```

### Keybinding Ideas

Consider adding to `lua/config/keymaps/`:

```lua
-- Tab management
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { desc = "Close other tabs" })

-- Quick tab switching
vim.keymap.set("n", "<A-1>", "1gt", { desc = "Go to tab 1" })
vim.keymap.set("n", "<A-2>", "2gt", { desc = "Go to tab 2" })
vim.keymap.set("n", "<A-3>", "3gt", { desc = "Go to tab 3" })

-- Buffer navigation (tab-scoped!)
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { desc = "Previous buffer" })
```

## Troubleshooting

### Buffers showing in wrong tab

**Problem:** Opening a file shows it in multiple tabs

**Solution:** This is expected if you `:buffer <name>` to an existing buffer. To truly scope buffers, open them fresh in each tab with `:e` or `:tabedit`.

### Tabs component not showing

**Reason:** The tabs component only shows when you have 2+ tabs.

**Test:**
```vim
:tabnew
" Now tabs component should appear on the right
```

### Want global buffer list instead?

**Disable scope.nvim:**
```lua
-- In lua/plugins/ui/lualine.lua
dependencies = {
  -- Comment out or remove scope.nvim
  -- {
  --   "tiagovla/scope.nvim",
  --   event = "VeryLazy",
  --   opts = {},
  -- },
}
```

## Resources

- [Scope.nvim GitHub](https://github.com/tiagovla/scope.nvim)
- [Lualine Documentation](https://github.com/nvim-lualine/lualine.nvim)
- [Vim Tabs vs Buffers](https://stackoverflow.com/questions/26708822/why-do-vim-experts-prefer-buffers-over-tabs)
- [NvChad Tabufline](https://github.com/NvChad/ui/tree/v2.5/lua/nvchad/tabufline)

## What's Next?

Now that the structure is in place, you can customize:

1. **Colors** - Adjust `buffers_color` and `tabs_color` in `tabline.lua`
2. **Icons** - Customize symbols (modified, alternate, directory)
3. **Keybindings** - Add convenient tab/buffer navigation
4. **Hooks** - Use scope.nvim hooks for custom behavior
5. **Telescope** - Load scope extension for tab-scoped fuzzy finding

Enjoy your NvChad-style tabline! 🚀
