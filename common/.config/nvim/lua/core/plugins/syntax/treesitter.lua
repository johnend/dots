return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  dependencies = {
    "OXY2DEV/markview.nvim",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "HiPhish/rainbow-delimiters.nvim",
  },
  config = function()
    local status_ok, ts = pcall(require, "nvim-treesitter.config")
    if not status_ok then
      return
    end

    local required_languages = {
      "bash",
      "css",
      "diff",
      "dockerfile",
      "git_config",
      "graphql",
      "html",
      "hyprlang",
      "java",
      "javascript",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "rasi",
      "regex",
      "scss",
      "rust",
      "ssh_config",
      "svelte",
      "terraform",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "yaml",
      "yuck",
      "query",
    }

    local install = require "nvim-treesitter.install"

    install.prefer_git = true
    install(required_languages)

    local opts = {
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = { enable = true, disable = {} },
      rainbow = {
        enable = true,
        query = "rainbow-delimiters",
        strategy = require("rainbow-delimiters").strategy.global,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["a,"] = "@parameter.outer",
            ["i,"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["],"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[,"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = { [">,"] = "@parameter.inner" },
          swap_previous = { ["<,"] = "@parameter.inner" },
        },
      },
    }
    ts.setup(opts)
  end,
}
