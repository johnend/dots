Colors = require "config.colors"
Icons = require "config.icons"
UI = require "config.ui"

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

local theme_file = vim.fn.stdpath "config" .. "/theme.json"
local colorscheme = "default"

local function load_colorscheme()
  local ok, json = pcall(vim.fn.readfile, theme_file)
  if ok and json and #json > 0 then
    local decoded = vim.fn.json_decode(table.concat(json, "\n"))
    if decoded and decoded.colorscheme then
      return decoded.colorscheme
    end
  end
  return colorscheme
end

vim.defer_fn(function()
  local cs = load_colorscheme()
  local ok = pcall(vim.cmd.colorscheme, cs)
  if not ok then
    vim.notify("Colorscheme " .. cs .. " not found! Using fallback.", vim.log.levels.WARN)
    pcall(vim.cmd.colorscheme, colorscheme)
  end
end, 10)

require "core.options"
require "core.autocmds"
require "core.keymaps"

require "config.lazy"

-- Lazy required before filetypes as it needs a dependency
require "core.filetypes"
