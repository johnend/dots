---@alias WaterBufferSort "id" | "alphabetical" | "last_modified"
---@alias WaterDateFormat "dd/mm" | "mm/dd"
---@alias WaterTimeFormat "24h" | "12h"
---@alias WaterPathDisplay "full_path" | "short_path" | "file_name" | fun(path: string): string
---@alias WaterDeleteFallback "q" | "enew" | fun():any
---@alias WaterGitIcons { added: string, changed: string, removed: string, untracked: string }
---@alias WaterDiagnosticIcons { err: string, warn: string }
---@alias WaterIcons { git: WaterGitIcons, diagnostics: WaterDiagnosticIcons }
---@alias WaterKeymaps { toggle: string, open_buffer: string, delete: string, split: string, vsplit: string, refresh: string, help: string }

---@class WaterOptions
---@field show_modified boolean       Show if the buffer has been modified
---@field show_readonly boolean       Show if a buffer is readonly
---@field show_diagnostics boolean    Show buffer diagnostics in Water (defaults to true)
---@field highlight_cursorline boolean Highlight the current line
---@field sort_buffers WaterBufferSort Determine how to sort buffers in Water
---@field use_nerd_icons boolean      Use Nerd Font icons for Git and diagnostics
---@field path_display WaterPathDisplay How much of the buffer path to display
---@field date_format WaterDateFormat Date display format
---@field time_format WaterTimeFormat Time display format
---@field delete_last_buf_fallback WaterDeleteFallback Fallback action when deleting the last buffer
---@field icons WaterIcons           Customize the symbols shown in the Git and Diagnostics columns
---@field keymaps WaterKeymaps       Custom key mappings for Water actions

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
  icons = {
    git = { added = "", changed = "", removed = "", untracked = "" },
    diagnostics = { err = "", warn = "" },
  },
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
