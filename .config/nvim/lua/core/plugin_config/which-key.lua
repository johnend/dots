local which_key = require "which-key"

local mappings = {
  q = { "<cmd>confirm q<CR>", "Quit" },
  g = {
    name = "LazyGit",
    g = { "<cmd>lua require 'core.plugin_config.toggleterm'.lazygit_toggle()<cr>", "Lazygit" },
  },
}
local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local vopts = {
  mode = "v",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

which_key.setup {
  plugins = {
    marks = true,
    registers = true,

    spelling = {
      enabled = true,
      suggestions = 20,
    }, -- TODO determine if this is actually valuable?
    presets = {
      operators = true, -- adds help for operators like d, y...
      motions = true, -- adds help for motions
      text_objects = false, -- help for text objects triggered after entering an operator
      windows = false, -- default bindings on <C-w> (which have been remapped)
      nav = false, -- misc bindings to work with windows
      z = true, -- bindings for folds
      g = true, -- bindings prefixed with g
    },
  },
  icons = {
    breadcrumb = icons.ui.DoubleChevronRight,
    separator = icons.ui.BoldArrowRight,
    group = icons.ui.Plus,
  },
  popup_mappings = {
    scroll_down = "<c-d>",
    scroll_up = "<c-u>",
  },
  window = {
    border = "rounded",
    position = "bottom",
    padding = { 2, 2, 2, 2 },
    margin = { 1, 0, 1, 0 },
    winblend = 0,
  },
  ignore_missing = false,
  show_help = true,
  show_keys = true,
}

which_key.register(mappings, opts)
which_key.register(mappings, vopts)

-- Document existing
which_key.register {
  ["<leader>c"] = { name = "Code (LSP)", _ = "which_key_ignore" },
  ["<leader>d"] = { name = "Diagnostics", _ = "which_key_ignore" },
  ["<leader>l"] = { name = "Lazy", _ = "which_key_ignore" },
  ["<leader>r"] = { name = "Rename", _ = "which_key_ignore" },
  ["<leader>s"] = { name = "Search", _ = "which_key_ignore" },
  ["<leader>t"] = { name = "Toggle", _ = "which_key_ignore" },
  ["<leader>b"] = { name = "Buffers", _ = "which_key_ignore" },
  -- ['<leader>h'] = { name = 'Git Hunk', _ = 'which_key_ignore' },
}
