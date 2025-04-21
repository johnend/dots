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

    -- Document existing
    wk.add {
      ---------------------------------
      -- Buffers
      ---------------------------------
      { "<leader>b", group = "Buffer" },
      { "<leader>bn", ":bnext<cr>", desc = "Next" },
      { "<leader>bb", ":bprevious<cr>", desc = "Previous" },
      { "<leader>bd", ":bd<cr>", desc = "Delete" },
      { "<leader>bx", ":%bd|e#|bd#<cr>", desc = "Delete all except current" },
      ---------------------------------
      { "<leader>c", group = "Code (LSP)" },
      { "<leader>d", group = "Diagnostics" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Harpoon", icon = icons.misc.Hook },
      { "<leader>l", group = "Lazy", icon = icons.misc.Lazy },
      { "<leader>n", group = "NeoTree", icon = icons.ui.FileTree },
      ---------------------------------
      -- Telescope
      ---------------------------------
      { "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "Open files" },
      { "<leader>s", group = "Search" },
      { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Colorschemes" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Files" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      {
        "<leader>sn",
        ":lua require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }<cr>",
        desc = "Neovim config files",
      },
      {
        "<leader>sp",
        "<cmd>Telescope project project theme=dropdown layout_config={width=0.5, height=0.4}<cr>",
        desc = "Diagnostics",
      },
      { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume project" },
      { "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "Builtin pickers" },
      {
        "<leader>st",
        "<cmd>TodoTelescope theme=dropdown previewer=false layout_config={width=0.5,height=0.3}<cr>",
        desc = "TODOs",
      },
      { "<leader>sv", "<cmd>Telescope git_files<cr>", desc = "Git files" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Current word" },
      { "<leader>sx", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>s.", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
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
