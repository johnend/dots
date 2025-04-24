return {
  "propet/colorscheme-persist.nvim",
  lazy = false, -- load immediately to set the colorscheme on startup
  dependencies = {
    "nvim-telescope/telescope.nvim",
    -- Add your colorscheme plugins here, e.g.:
    -- "Th3Whit3Wolf/space-nvim",
    -- "luisiacc/gruvbox-baby",
    -- "folke/tokyonight.nvim",
    -- "rebelot/kanagawa.nvim",
  },
  keys = {
    {
      "<leader>sc", -- Or your preferred keymap
      function()
        require("colorscheme-persist").picker()
      end,
      mode = "n",
      desc = "Choose colorscheme",
    },
  },
  opts = {
    -- Absolute path to file where colorscheme should be saved
    -- Default: file_path: vim.fn.stdpath("data") .. "/.nvim.colorscheme-persist.lua",
    -- file_path = vim.fn.stdpath("config") .. "/colorscheme.lua",

    -- In case there's no saved colorscheme yet
    -- Default: fallback: "blue",
    -- fallback = "quiet",

    -- List of ugly colorschemes to avoid in the selection window
    -- Default:
    disable = {
      "blue",
      "catppuccin-frappe",
      "catppuccin-mocha",
      "catppuccin-latte",
      "catppuccin-macchiato",
      "darkblue",
      "delek",
      "desert",
      "elflord",
      "evening",
      "habamax",
      "industry",
      "koehler",
      "morning",
      "murphy",
      "pablo",
      "peachpuff",
      "quiet",
      "ron",
      "rose-pine-dawn",
      "rose-pine-moon",
      "rose-pine-main",
      "shine",
      "slate",
      "torte",
      "vim",
      "wildcharm",
      "zellner",
    },
    -- disable = { "darkblue" },

    -- Options for the telescope picker
    -- Default: picker_opts = require("telescope.themes").get_dropdown()
    -- picker_opts = require("telescope.themes").get_ivy(),
  },
}
