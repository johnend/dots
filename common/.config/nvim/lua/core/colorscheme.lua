-- core/colorscheme.lua
-- Colorscheme persistence and loading

local M = {}

local default_colorscheme = "default"
local theme_file = vim.fn.stdpath "config" .. "/theme.json"

function M.load()
  local ok, json = pcall(vim.fn.readfile, theme_file)
  if ok and json and #json > 0 then
    local decoded = vim.fn.json_decode(table.concat(json, "\n"))
    if decoded and decoded.colorscheme then
      return decoded.colorscheme
    end
  end
  return default_colorscheme
end

function M.apply()
  vim.defer_fn(function()
    local cs = M.load()
    local ok = pcall(vim.cmd.colorscheme, cs)
    if not ok then
      vim.notify("Colorscheme " .. cs .. " not found! Using fallback.", vim.log.levels.WARN)
      pcall(vim.cmd.colorscheme, default_colorscheme)
    end
  end, 10)
end

return M
