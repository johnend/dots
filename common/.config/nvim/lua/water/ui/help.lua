-- lua/water/ui/help.lua
---@class water.ui.help

local M = {}
local state = require "water.state"

---Internal options for the help UI.
---@type table<string, any>
local options = {}

---Setup the help module with user-provided options.
---@param opts table Configuration table, expects a `keymaps` field mapping actions to keys.
function M.setup(opts)
  options = opts or {}
end

---Toggle the help window display.
function M.toggle()
  M.open_help_window()
end

---Open a floating help window listing key mappings and instructions.
function M.open_help_window()
  local keymaps = options.keymaps or {}

  -- Instructions for top of help window
  local instruction = "Press the corresponding key to execute the command"
  local close_instruction = "Press <Esc>, or q, to close the help window"
  ---@type {key: string, action: string}[]
  local keymap_rows = {}

  for action, key in pairs(keymaps) do
    table.insert(keymap_rows, { key = key, action = action })
  end
  table.sort(keymap_rows, function(a, b)
    return a.key < b.key
  end)

  -- Columns and sizing
  local header = { "KEY", "COMMAND" }
  local key_col_width, cmd_col_width = 10, 30
  local width = key_col_width + cmd_col_width + 12
  local height = #keymap_rows + 5

  -- Determine parent window (Water UI)
  local parent_win = state.water_winid or 0
  local win_width = vim.api.nvim_win_get_width(parent_win)
  local win_height = vim.api.nvim_win_get_height(parent_win)

  -- Center within parent window
  local col = math.floor((win_width - width) / 2)
  local row = math.floor((win_height - height) / 2)

  -- Buffer and content lines
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = {}

  ---Center text within given width
  ---@param text string
  ---@return string centered
  ---@return number pad
  ---@return number txt_width
  local function center_line(text)
    local txt_width = vim.fn.strdisplaywidth(text)
    local pad = math.max(math.floor((width - txt_width) / 2), 0)
    return string.rep(" ", pad) .. text, pad, txt_width
  end

  local inst_line, inst_pad, inst_w = center_line(instruction)
  local close_line, close_pad, close_w = center_line(close_instruction)
  lines[#lines + 1] = inst_line
  lines[#lines + 1] = close_line
  lines[#lines + 1] = ""

  -- Header row
  local header_fmt = string.format("%%%ds   %%-%ds", key_col_width, cmd_col_width)
  lines[#lines + 1] = header_fmt:format(header[1], header[2])

  -- Keymap rows
  for _, row_data in ipairs(keymap_rows) do
    local fmt = string.format("%%%ds -> %%-%ds", key_col_width, cmd_col_width)
    lines[#lines + 1] = fmt:format(row_data.key, row_data.action)
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Floating window relative to Water UI buffer window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "win",
    win = parent_win,
    width = width,
    height = height,
    col = col,
    row = row,
    border = "rounded",
    title = " Water Help ",
    title_pos = "center",
    style = "minimal",
  })

  local ns = vim.api.nvim_create_namespace "water_help"
  -- Highlight instruction lines
  vim.api.nvim_buf_set_extmark(buf, ns, 0, inst_pad, { end_col = inst_pad + inst_w, hl_group = "Comment" })
  vim.api.nvim_buf_set_extmark(buf, ns, 1, close_pad, { end_col = close_pad + close_w, hl_group = "Comment" })
  -- Highlight header
  local hdr_line = lines[4] or ""
  vim.api.nvim_buf_set_extmark(buf, ns, 4, 0, { end_col = vim.str_utfindex(hdr_line, "utf-8"), hl_group = "Title" })
  -- Highlight key/action pairs
  for idx in ipairs(keymap_rows) do
    local li = idx + 4
    local line = vim.api.nvim_buf_get_lines(buf, li, li + 1, false)[1] or ""
    local sep = string.find(line, "->", 1, true)
    if sep then
      vim.api.nvim_buf_set_extmark(buf, ns, li, 0, { end_col = sep - 1, hl_group = "Title" })
      local act_start = sep + 3
      local total = vim.str_utfindex(line, "utf-8")
      if act_start < total then
        vim.api.nvim_buf_set_extmark(buf, ns, li, act_start, { end_col = total, hl_group = "@text" })
      end
    end
  end

  -- Close mappings
  for _, key in ipairs { "q", "<Esc>" } do
    vim.keymap.set("n", key, "<cmd>close<CR>", { buffer = buf, nowait = true, noremap = true, silent = true })
  end

  -- Auto-close on leave
  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    buffer = buf,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })

  -- Buffer settings
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "help"
  vim.bo[buf].modifiable = false
end

return M
