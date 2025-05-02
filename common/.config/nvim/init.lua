---@diagnostic disable: lowercase-global
-- Use global variable objects for colors and icons
colors = require "core.config.colors"
icons = require "core.config.icons"

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

local lazy_opts = {
  -- Lazy options
  spec = {
    { import = "core.plugins" },
    { import = "core.plugins._testing_ground" },
    { import = "core.plugins.utilities" },
    { import = "core.plugins.git" },
    { import = "core.plugins.editing" },
    { import = "core.plugins.navigation" },
    { import = "core.plugins.devtools" },
    { import = "core.plugins.syntax" },
    { import = "core.plugins.ui" },
    { import = "core.plugins.ui.colorschemes" },
    { import = "core.plugins.lsp" },
  },
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

require("lazy").setup(lazy_opts)
require "core.keymaps"
require "core.commands"
require "core.options"
require "core.filetypes"
require "water"
