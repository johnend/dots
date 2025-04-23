return {
  "nvim-treesitter/nvim-treesitter",
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

    local opts = {
      ensure_installed = required_languages,
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
