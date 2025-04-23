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
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["nf"] = "@function.outer",
            ["nc"] = "@class.outer",
          },
          goto_previous_start = {
            ["pf"] = "@function.outer",
            ["pc"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>rf"] = "@function.outer",
            ["<leader>rm"] = "@method.outer",
            ["<leader>rp"] = "@parameter.inner",
            ["<leader>rb"] = "@block.outer",
            ["<leader>rs"] = "@statement.outer",
            ["<leader>ro"] = "@property.outer", -- object field
          },
          swap_previous = {
            ["<leader>rF"] = "@function.outer",
            ["<leader>rM"] = "@method.outer",
            ["<leader>rP"] = "@parameter.inner",
            ["<leader>rB"] = "@block.outer",
            ["<leader>rS"] = "@statement.outer",
            ["<leader>rO"] = "@property.outer",
          },
        },
      },
    }

    ts.setup(opts)
  end,
}
