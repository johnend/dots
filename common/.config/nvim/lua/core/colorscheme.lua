-- core/colorscheme.lua
-- Colorscheme and transparency persistence and loading

local M = {}

local default_colorscheme = "default"
local theme_file = vim.fn.stdpath "config" .. "/theme.json"

---@return { colorscheme: string, transparent: boolean }
function M.load()
  local state = { colorscheme = default_colorscheme, transparent = false }
  local ok, json = pcall(vim.fn.readfile, theme_file)
  if ok and json and #json > 0 then
    local decoded = vim.fn.json_decode(table.concat(json, "\n"))
    if decoded then
      if decoded.colorscheme then
        state.colorscheme = decoded.colorscheme
      end
      if decoded.transparent == true then
        state.transparent = true
      end
    end
  end
  return state
end

---Write theme state to disk (colorscheme and/or transparent).
---@param updates { colorscheme?: string, transparent?: boolean }
function M.save_state(updates)
  local state = M.load()
  if updates then
    for k, v in pairs(updates) do
      state[k] = v
    end
  end
  local json = vim.fn.json_encode(state)
  pcall(vim.fn.writefile, { json }, theme_file)
end

local function apply_transparency_highlights()
  require("config.ui.transparency").apply_transparency_highlights()
  require("config.ui.highlights-overrides").fix_whichkey_icon_highlights(true)
end

function M.apply()
  local state = M.load()
  local ok = pcall(vim.cmd.colorscheme, state.colorscheme)
  if not ok then
    vim.notify("Colorscheme " .. state.colorscheme .. " not found! Using fallback.", vim.log.levels.WARN)
    pcall(vim.cmd.colorscheme, default_colorscheme)
  end

  if state.transparent then
    apply_transparency_highlights()
  else
    local ok_bufferline = pcall(require, "bufferline")
    if ok_bufferline then
      vim.api.nvim_set_hl(0, "BufferLineFill", { bg = vim.fn.synIDattr(vim.fn.hlID "Normal", "bg") })
    end
  end
end

---Re-apply transparent highlights if transparency is enabled in saved state.
---Call this after any colorscheme change so transparency is preserved without a flash.
function M.reapply_transparency_if_enabled()
  if M.load().transparent then
    apply_transparency_highlights()
  end
end

function M.toggle_transparency()
  local current_bg = vim.fn.synIDattr(vim.fn.hlID "Normal", "bg")
  local currently_transparent = current_bg == "" or current_bg == "NONE" or current_bg == "-1"

  if currently_transparent then
    M.save_state { transparent = false }
    M.apply()
    vim.notify("Background: Colorscheme", vim.log.levels.INFO)
  else
    apply_transparency_highlights()
    M.save_state { transparent = true }
    vim.notify("Background: Transparent (persisted)", vim.log.levels.INFO)
  end
end

return M
