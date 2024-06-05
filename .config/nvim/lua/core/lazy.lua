--[[
--
--  ██████╗ ██╗     ██╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
--  ██╔══██╗██║     ██║   ██║██╔════╝ ██║████╗  ██║██╔════╝
--  ██████╔╝██║     ██║   ██║██║  ███╗██║██╔██╗ ██║███████╗
--  ██╔═══╝ ██║     ██║   ██║██║   ██║██║██║╚██╗██║╚════██║
--  ██║     ███████╗╚██████╔╝╚██████╔╝██║██║ ╚████║███████║
--  ╚═╝     ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝
--

 This file should be used to add plugins you want Lazy to install.
 If you want to configure those plugins you can add a plugin specific file within lua/core/plugin_config and require it in the the init.lua in that folder.

--]]

local plugins = {
  -----------------------------------------------------------------------------
  -- Color scheme - others :are good too!
  -----------------------------------------------------------------------------
  {
    "catppuccin/nvim",
    lazy = false, -- load during startup
    priority = 1000, -- load before other plugins
    name = "catppuccin",
  },

  -----------------------------------------------------------------------------
  -- General utils
  -----------------------------------------------------------------------------
  "tpope/vim-sleuth", -- detect tab stops and shiftwidth automatically
  { "numToStr/Comment.nvim", lazy = false, event = "User FileOpened" }, -- faster commenting
  { "folke/which-key.nvim", event = "VimEnter", cmd = "WhichKey", }, -- dhows current keymaps
  { "folke/twilight.nvim", event = "VeryLazy" }, -- dims unfocused code
  { "tris203/precognition.nvim", event = "User FileOpened" }, -- hints at motion keymaps
  { "windwp/nvim-autopairs", config = true, },-- autopairs
  { "tpope/vim-surround", event = { "BufReadPre", "BufNewFile" }, }, -- vim surround - mappings for surrounding text with delimeters
  { "windwp/nvim-ts-autotag", ft = {"html", "jsx", "tsx" }, }, -- autotag, tag completion in html, js, jsx, etc...
  { "stevearc/conform.nvim", lazy = false, },
  { "aznhe21/actions-preview.nvim", event = "User FileOpened" }, -- preview code actions
  ----------------------------------------------------------------------------- 
  -- UI
  -----------------------------------------------------------------------------
  { "Bekaboo/deadcolumn.nvim", event = { "BufReadPre", "BufNewFile" }, },-- better color column support
  { "lewis6991/gitsigns.nvim", event = "User FileOpened", cmd = "GitSigns" }, -- show git status in the gutter
  { "lukas-reineke/indent-blankline.nvim" }, -- show indent guides
  { "nvim-lua/popup.nvim", lazy = true }, -- An implementation of the Popup API from vim in NeoVim
  { "NvChad/nvim-colorizer.lua", event = "User FileOpened" }, -- Colorizer - colors hex, rgb, hsl colors in code
  { "folke/todo-comments.nvim", event = "VeryLazy" }, -- highlights todos
  { "folke/trouble.nvim", event = "User FileOpened" }, -- shows diagnostics, symbols and other useful things in a window
  { "folke/noice.nvim", event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      { "rcarriga/nvim-notify", opts = { top_down = false, }, },
    },
  }, -- ui plugin for "noice" messages, cmdline, and popup menu
  { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    event = "User DirOpened",
    cmd = { "Neotree show", "Neotree close", "Neotree toggle", "Neotree focus" },
  }, -- filetree explorer and buffers as tabs
  { "kosayoda/nvim-lightbulb", event = "User FileOpened" }, -- shows a lightbulb as virtual text when code actions are available
  { "goolord/alpha-nvim", event = "VimEnter", }, -- customisable dashboard with two themes/layouts
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } }, -- customisable status linie
  { "utilyre/barbecue.nvim", name = "barbecue", version = "*", event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
  }, -- breadcrumbs for symbols like VSCode
  { "willothy/nvim-cokeline",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "stevearc/resession.nvim",
    },
    config = true,
  }, -- custom tab styling
  { "RRethy/vim-illuminate", event = "User FileOpened", }, -- highlight occurrences of word under cursor

  ---------------------------------------------------------------------------
  -- Completion
  ---------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp", -- completion engine
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp", },
      { "hrsh7th/cmp-emoji", },
      { "hrsh7th/cmp-buffer", },
      { "hrsh7th/cmp-path", },
      { "hrsh7th/cmp-cmdline", },
      { "saadparwaiz1/cmp_luasnip", },
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp",
        dependencies = {
          "rafamadriz/friendly-snippets",
        }, },
      { "hrsh7th/cmp-nvim-lua", event = "InsertEnter", },
    },
  },

  ---------------------------------------------------------------------------
  -- Telescope
  ---------------------------------------------------------------------------
  { "nvim-telescope/telescope.nvim", event = "VimEnter", branch = "0.1.x", lazy = true, cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end, },
      { "nvim-telescope/telescope-project.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
  },

  -------------------------------------------------------------------------
  -- LSP
  -------------------------------------------------------------------------
  { "neovim/nvim-lspconfig", event = { "BufReadPre", "BufNewFile" }, cmd = { "LspInfo", "LspInstall", "LspUninstall" }, lazy = true,
    dependencies = {
      { "williamboman/mason.nvim", config = true, lazy = true, cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" } },
      { "williamboman/mason-lspconfig.nvim", lazy = true, event = "User FileOpened" }, -- helps with the above
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "folke/neodev.nvim" },
      { "nvimtools/none-ls.nvim" },
    },
  },
  { "b0o/schemastore.nvim", lazy = true, },

  ---------------------------------------------------------------------------
  -- Treesitter
  ---------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = {
    "TSInstall",
    "TSUninstall",
    "TSUpdate",
    "TSUpdateSync",
    "TSInstallInfo",
    "TSInstallSync",
    "TSInstallFromGrammar",
    },
    event = "User FileOpened",
  },
  { "HiPhish/rainbow-delimiters.nvim" },
  
  ---------------------------------------------------------------------------
  -- Toggle term
  ---------------------------------------------------------------------------
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    cmd = {
      "ToggleTerm",
      "TermExec",
      "ToggleTermToggleAll",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
    },
  },
  -- #########################################################################
  --              NOTE: plugins for future consideration below
  -- ##########################################################################
  -- {"folke/edgy.nvim"}, -- create and manage predefined window layouts
  -- {"petertriho/nvim-scrollbar"}, -- extensible scrollbar (shows error lines and such)
  -- {"nvim-neotest/neotest"}, -- extensible embedded testing framework
  -- Lua/NeoVim specific
  -- {"Tastyep/structlog.nvim"}, - better logging for Lua
}

local lazy_opts = {
  -- Lazy options
  ui = {
    border = "rounded",
  },
  icons = vim.g.have_nerd_font and {} or {
    cmd = "⌘",
    config = "🛠",
    event = "📅",
    ft = "📂",
    init = "⚙",
    keys = "🗝",
    plugin = "🔌",
    runtime = "💻",
    require = "🌙",
    source = "📄",
    start = "🚀",
    task = "📌",
    lazy = "💤 ",
  },
}

--[[ Keymaps ]]
vim.keymap.set("n", "<leader>lo", ":Lazy<CR>", { desc = "Open" })
vim.keymap.set("n", "<leader>ll", ":Lazy log<CR>", { desc = "Log" })
vim.keymap.set("n", "<leader>lp", ":Lazy profile<CR>", { desc = "Profile" })
vim.keymap.set("n", "<leader>ld", ":Lazy debug<CR>", { desc = "Debug" })
vim.keymap.set("n", "<leader>lh", ":Lazy health<CR>", { desc = "Health" })
vim.keymap.set("n", "<leader>l?", ":Lazy help<CR>", { desc = "Help" })
vim.keymap.set("n", "<leader>ls", ":Lazy sync<CR>", { desc = "Sync" })
vim.keymap.set("n", "<leader>lu", ":Lazy update<CR>", { desc = "Update" })

require("lazy").setup(plugins, lazy_opts)
