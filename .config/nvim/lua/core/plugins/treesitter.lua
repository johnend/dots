require("nvim-treesitter.install").prefer_git = true

local treesitter = require "nvim-treesitter.configs"

local required_languages = {
  "bash",
  "css",
  "diff",
  "dockerfile",
  "git_config",
  "graphql",
  "html",
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
}

treesitter.setup(opts)
