---@diagnostic disable: lowercase-global
-- Use global variable objects for colors and icons
colors = require "core.config.colors"
icons = require "core.config.icons"

-- ensure Mason’s installers are on PATH so conform/other health-checks can see them
local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
if not string.find(vim.env.PATH, mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

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

-- Helper to check if a plugin folder is non-empty
local function plugin_folder_has_files(folder)
  local path = vim.fn.stdpath "config" .. "/lua/core/plugins/" .. folder
  ---@diagnostic disable-next-line: undefined-field
  local handle = vim.uv.fs_scandir(path)
  if not handle then
    return false
  end
  for _ in
    function()
      ---@diagnostic disable-next-line: undefined-field
      return vim.uv.fs_scandir_next(handle)
    end
  do
    return true -- found at least one file
  end
  return false
end

-- Base plugin specs
local plugin_specs = {
  { import = "core.plugins" },
  { import = "core.plugins.utilities" },
  { import = "core.plugins.git" },
  { import = "core.plugins.editing" },
  { import = "core.plugins.navigation" },
  { import = "core.plugins.devtools" },
  { import = "core.plugins.syntax" },
  { import = "core.plugins.ui" },
  { import = "core.plugins.ui.colorschemes" },
  { import = "core.plugins.lsp" },
}

-- Conditionally import _testing_ground if it has files
if plugin_folder_has_files "_testing_ground" then
  table.insert(plugin_specs, 2, { import = "core.plugins._testing_ground" }) -- insert after core.plugins
end

local lazy_opts = {
  spec = plugin_specs,
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
require "core.overrides"
require "water"

if vim.g.neovide then
  require "core.neovide"
end
