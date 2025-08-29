return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = "BufEnter",
  cmd = {
    "TSInstallFromGrammar",
    "TSInstall",
    "TSUninstall",
    "TSUpdate",
    "TSUpdateSync",
    "TSInstallInfo",
    "TSInstallSync",
  },
  dependencies = {
    "HiPhish/rainbow-delimiters.nvim",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    local status_ok, ts = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
      return
    end

    require("nvim-treesitter.install").prefer_git = true

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
    }

    ts.setup {
      ensure_installed = required_languages,
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = { enable = true, disable = {} },
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

    vim.g.rainbow_delimeters = {
      enable = true,
      strategy = {
        [""] = require("rainbow-delimiters").strategy.global,
      },
      query = { [""] = "rainbow-delimiters" },
    }
  end,
}
