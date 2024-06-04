---@diagnostic disable: lowercase-global
-- Use global variable objects for colors and icons
colors = require "core.ui.colors"
icons = require "core.ui.icons"

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
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

require "core.keymaps"
require "core.vim.commands"
require "core.vim.options"
require "core.vim.filetypes"
require "core.lazy"
require "core.plugin_config"
require "core.lsp"
