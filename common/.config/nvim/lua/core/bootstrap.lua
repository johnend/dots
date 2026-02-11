-- core/bootstrap.lua
-- Bootstrap lazy.nvim and essential providers

local M = {}

function M.setup()
  -- Disable unused providers
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- Set leaders before lazy loads
  vim.keymap.set("", "<Space>", "<Nop>", { noremap = true, silent = true })
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

  -- Ensure Mason's installers are on PATH
  local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
  if not string.find(vim.env.PATH, mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
  end
end

function M.install_lazy()
  local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
  ---@diagnostic disable-next-line: undefined-field
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)
end

return M
