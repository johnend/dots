---@diagnostic disable: lowercase-global
-- Use global variable objects for colors and icons
colors = require "core.config.colors"
icons = require "core.config.icons"

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
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
    { import = "core.plugins.lsp" },
    { import = "core.plugins.ui" },
    { import = "core.plugins.ui.colorschemes" },
    { import = "core.plugins.helpers" },
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

--[[ Lazy Keymaps ]]
vim.keymap.set("n", "<leader>lo", ":Lazy<CR>", { desc = "Open" })
vim.keymap.set("n", "<leader>ll", ":Lazy log<CR>", { desc = "Log" })
vim.keymap.set("n", "<leader>lp", ":Lazy profile<CR>", { desc = "Profile" })
vim.keymap.set("n", "<leader>ld", ":Lazy debug<CR>", { desc = "Debug" })
vim.keymap.set("n", "<leader>lh", ":Lazy health<CR>", { desc = "Health" })
vim.keymap.set("n", "<leader>l?", ":Lazy help<CR>", { desc = "Help" })
vim.keymap.set("n", "<leader>ls", ":Lazy sync<CR>", { desc = "Sync" })
vim.keymap.set("n", "<leader>lu", ":Lazy update<CR>", { desc = "Update" })

require "core.keymaps"
require "core.commands"
require "core.options"
require "core.filetypes"
