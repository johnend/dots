-- Safeguard: Catch any critical errors during startup and continue loading
local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    -- Show full error in messages, not just notification
    local err_msg = string.format("Failed to load %s:\n%s", module, result)
    vim.schedule(function()
      vim.notify(err_msg, vim.log.levels.ERROR, { title = "Config Error" })
    end)
    return nil
  end
  return result
end

Colors = safe_require "config.colors" or {}
Icons = safe_require "config.icons" or {}
UI = safe_require "config.ui" or { border = "rounded" }

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

safe_require "core.options"
safe_require "core.autocmds"
safe_require "core.keymaps"

safe_require "config.lazy"

-- Lazy required before filetypes as it needs a dependency
safe_require "core.filetypes"
