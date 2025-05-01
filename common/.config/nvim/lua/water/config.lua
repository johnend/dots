---@alias WaterBufferSort "id" | "alphabetical" | "last_modified"
---@alias WaterDateFormat "dd/mm" | "mm/dd"
---@alias WaterTimeFormat "24h" | "12h"
---@alias WaterPathDisplay "full_path" | "short_path" | "file_name" | fun(path: string): string
---@alias WaterDeleteFallback "q" | "enew" | fun()

---@class WaterOptions
---Show if the buffer has been modified
---@field show_modified boolean
---Show if a buffer is readonly
---@field show_readonly boolean
---Show buffer diagnostic in Water (defaults to true)
---@field show_diagnostics boolean
---@field highlight_cursorline boolean
---Determine how to sort buffers in Water
---@field sort_buffers WaterBufferSort
---@field use_nerd_icons boolean
---@field path_display WaterPathDisplay "How much of the buffer path do you want to see?"
---Format the date, default is dd/mm
---If you prefer you can set it to mm/dd
---@field date_format WaterDateFormat
---@field time_format WaterTimeFormat
---Determine what happens when the last buffer is deleted.
---Defaults to quitting NeoVim
---@field delete_last_buf_fallback WaterDeleteFallback
---@field keymaps table<string, string>

local M = {}

---@type WaterOptions
M.defaults = {
  show_modified = true,
  show_readonly = true,
  show_diagnostics = true,
  highlight_cursorline = true,
  sort_buffers = "last_modified",
  use_nerd_icons = true,
  path_display = "short_path",
  date_format = "dd/mm",
  time_format = "24h",
  delete_last_buf_fallback = "q",
  keymaps = {
    toggle = "_",
    open_buffer = "<cr>",
    delete = "dd",
    split = "s",
    vsplit = "v",
    refresh = "r",
    help = "?",
  },
}

function M.merge(user_opts)
  return vim.tbl_deep_extend("force", M.defaults, user_opts or {})
end

return M
