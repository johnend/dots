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
  -- Color scheme - others :are good too!
  {
    "catppuccin/nvim",
    lazy = false, -- load during startup
    priority = 1000, -- load before other plugins
    name = "catppuccin",
  },

  -- [[ General utils ]]
  -- detect tab stops and shiftwidth automatically
  "tpope/vim-sleuth",

  -- gc to comment visual regions/lines
  { "numToStr/Comment.nvim", lazy = false, event = "User FileOpened" },

  -- git related signs in the gutter
  { "lewis6991/gitsigns.nvim", event = "User FileOpened", cmd = "GitSigns" },

  -- Which key - for showing keybindings
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    cmd = "WhichKey",
  },

  -- autopairs
  {
    "windwp/nvim-autopairs",
    config = true,
  },

  -- vim surround - mappings for surrounding text with delimeters
  { "tpope/vim-surround" },

  -- autotag, tag completion in html, js, jsx, etc...
  { "windwp/nvim-ts-autotag" },

  -- [[ UI ]]

  -- An implementation of the Popup API from vim in NeoVim
  { "nvim-lua/popup.nvim" },

  -- Colorizer - colors hex, rgb, hsl colors in code
  { "NvChad/nvim-colorizer.lua", event = "User FileOpened" },

  -- Todo Comments - highlights todos (duh)
  { "folke/todo-comments.nvim" },

  -- Neo-tree - a better sidebar experience, also with tabs for buffers
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- optional, adds image support for preview mode
    },
    event = "User DirOpened",
    cmd = { "Neotree show", "Neotree close", "Neotree toggle", "Neotree focus" },
  },

  -- [[ Completion plugins ]]
  {
    "hrsh7th/nvim-cmp", -- The completion plugin
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- completions
      {
        "hrsh7th/cmp-nvim-lsp",
        event = "InsertEnter",
      },
      {
        "hrsh7th/cmp-emoji",
        event = "InsertEnter",
      },
      { -- buffer completions
        "hrsh7th/cmp-buffer",
        event = "InsertEnter",
      },
      { -- path completions
        "hrsh7th/cmp-path",
        event = "InsertEnter",
      },
      { -- cmdline completions
        "hrsh7th/cmp-cmdline",
        event = "InsertEnter",
      },
      { -- snippet completions
        "saadparwaiz1/cmp_luasnip",
        event = "InsertEnter",
      },

      { -- snippets engine
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        build = "make install_jsregexp",
        dependencies = {
          "rafamadriz/friendly-snippets",
          event = "InsertEnter",
        }, -- snippets for a bunch of languages
      },
      {
        "hrsh7th/cmp-nvim-lua",
        event = "InsertEnter",
      },
    },
  },

  -- [[ Telescope ]]
  { -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    lazy = true,
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        "nvim-telescope/telescope-fzf-native.nvim",

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "make",

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
      { "nvim-telescope/telescope-project.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
  },

  -- [[ LSP ]]
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    lazy = true,
    dependencies = {
      { "williamboman/mason.nvim", config = true, lazy = true, cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" } },
      { "williamboman/mason-lspconfig.nvim", lazy = true, event = "User FileOpened" }, -- helps with the above
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "j-hui/fidget.nvim",
      { "folke/neodev.nvim" },
      { "nvimtools/none-ls.nvim" }, -- LSP diagnostics and code actions
    },
  },
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- [[ Autoformat ]]
  {
    "stevearc/conform.nvim",
    lazy = false,
  },

  -- [[ Treesitter ]]
  { -- Highlight, edit, and navigate code
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
  { "HiPhish/nvim-ts-rainbow2" },

  -- [[ Toggle term ]]
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
  --
  -----------------------------------------------------------------------------
  -- NOTE: to investigate
  -----------------------------------------------------------------------------
  -- UI
  -- {"folke/edgy.nvim"}, -- create and manage predefined window layouts
  -- {"petertriho/nvim-scrollbar"}, -- extensible scrollbar (shows error lines and such)
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
  }, -- customisable dashboard with two themes/layouts
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "RRethy/vim-illuminate",
    event = "User FileOpened",
  },
  -- {"folke/twilight.nvim"}, -- dims code blocks that aren't focused
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
  }, -- file breadcrumbs like VSCode
  --
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  --  Testing
  -- {"nvim-neotest/neotest"}, -- extensible embedded testing framework
  --
  -- Util
  -- {"2KAbhishek/nerdy.nvim"}, -- nerd font icon picker
  --
  -- LSP
  -- {"nvimtools/none-ls.nvim"}, - NOTE: diagnostics, code actions, and more, might not be needed with current setup
  --
  -- Lua/NeoVim specific
  -- {"Tastyep/structlog.nvim"}, - better logging for Lua
  --
  -- Snippets
  --
  -----------------------------------------------------------------------------
  -- NOTE: to be considered once less experimental
  --
  -- {"folke/noice"}, -- ui plugin for "noice" messages, cmdline, and popup menu
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

require("lazy").setup(plugins, lazy_opts)
