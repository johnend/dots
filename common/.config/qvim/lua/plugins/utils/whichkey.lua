return {
  "folke/which-key.nvim",
  event = "VimEnter",
  cmd = "WhichKey",
  config = function()
    local status_ok, wk = pcall(require, "which-key")
    if not status_ok then
      return
    end
    wk.setup {
      ---@type false | "classic" | "modern" | "helix"
      preset = "helix",
      ---@type number | fun(ctx : {keys: string, mode: string, plugin?: string}):number
      delay = 300,
      plugins = {
        marks = true,
        registers = true,

        spelling = {
          enabled = true,
          suggestions = 20,
        }, -- TODO: determine if this is actually valuable?
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
        breadcrumb = Icons.ui.DoubleChevronRight,
        separator = Icons.ui.BoldArrowRight,
        group = Icons.ui.Plus,
      },
      win = {
        border = UI.border,
        padding = { 1, 1 },
        wo = { winblend = 0 },
        title = false,
      },
      layout = {
        spacing = 2,
      },
      show_help = true,
      show_keys = true,
    }

    local keymaps = require "config.keymaps"
    local buffers = keymaps.buffers
    local general = keymaps.general
    local plugins = keymaps.plugins
    local splits = keymaps.splits
    local picker = keymaps.picker
    local explorer = keymaps.explorer
    local toggle = keymaps.toggle

    -- TODO: update/include these when ready
    -- local ai = keymaps.ai
    -- local git = keymaps.git
    -- local grug = keymaps.grug
    -- local grapple = keymaps.grapple
    -- local lsp = keymaps.lsp
    -- local neotest = keymaps.neotest

    -- Document existing
    wk.add {
      ---------------------------------
      buffers,
      ---------------------------------
      -- ai,
      ---------------------------------
      -- neotest,
      ---------------------------------
      explorer,
      ---------------------------------
      general,
      ---------------------------------
      -- git,
      ---------------------------------
      -- grapple,
      ---------------------------------
      -- grug,
      ---------------------------------
      -- lsp,
      ---------------------------------
      plugins,
      ---------------------------------
      splits,
      ---------------------------------
      picker,
      ---------------------------------
      toggle,
      ---------------------------------
      {
        mode = { "n", "v" },
        { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
        { "<leader>w", "<cmd>w<cr>", desc = "Write", icon = Icons.misc.Write },
      },
    }
  end,
}
