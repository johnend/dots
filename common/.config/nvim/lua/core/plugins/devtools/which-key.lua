return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  cmd = "WhichKey",
  config = function()
    local status_ok, wk = pcall(require, "which-key")
    if not status_ok then
      return
    end
    wk.setup {
      ---@type false | "classic" | "modern" | "helix"
      preset = "classic",
      ---@type number | fun(ctx : {keys: string, mode: string, plugin?: string}):number
      delay = 300,
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
      win = {
        padding = { 1, 1 },
      },
      layout = {
        spacing = 2,
      },
      show_help = true,
      show_keys = true,
    }

    local keymaps = require "core.config.keymaps"
    local buffers = keymaps.buffers
    local telescope = keymaps.telescope
    local plugins = keymaps.plugins
    local lsp = keymaps.lsp
    -- local telescope = unpack(require "core.config.keymaps.buffers")

    -- Document existing
    wk.add {
      ---------------------------------
      buffers,
      ---------------------------------
      { "<leader>d", group = "Diagnostics" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Harpoon", icon = icons.misc.Hook },
      { "<leader>p", group = "Lazy", icon = icons.misc.Lazy },
      { "<leader>n", group = "NeoTree", icon = icons.ui.FileTree },
      ---------------------------------
      lsp,
      ---------------------------------
      plugins,
      ---------------------------------
      telescope,
      ---------------------------------
      { "<leader>t", group = "Toggle" },
      { "<leader>b", group = "Buffers" },
      { "<leader>x", group = "Split", icon = icons.misc.Split },
      {
        mode = { "n", "v" },
        { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
        { "<leader>w", "<cmd>w<cr>", desc = "Write", icon = icons.misc.Write },
        {
          "<leader>gg",
          "<cmd> lua require 'core.plugins.devtools.toggleterm'.lazygit_toggle()<cr>",
          desc = "LazyGit",
          icon = icons.git.Octoface,
        },
      },
    }
  end,
}
