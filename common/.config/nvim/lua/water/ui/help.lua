local M = {}

local options = {}

function M.setup(opts)
  options = opts or {}
end

function M.toggle()
  M.open_help_window()
end

function M.open_help_window()
  local keymaps = options.keymaps or {}

  local instruction = "Press the corresponding key to execute the command"
  local close_instruction = "Press <Esc>, or q, to close the help window"
  local keymap_rows = {}

  for action, key in pairs(keymaps) do
    table.insert(keymap_rows, { key = key, action = action })
  end

  table.sort(keymap_rows, function(a, b)
    return a.key < b.key
  end)

  local header = { "KEY", "COMMAND" }
  local key_col_width = 10
  local cmd_col_width = 30

  local width = key_col_width + cmd_col_width + 12
  local height = #keymap_rows + 5

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  local lines = {}

  local function center_line(text)
    local display_width = vim.fn.strdisplaywidth(text)
    local padding = math.max(math.floor((width - display_width) / 2), 0)
    return string.rep(" ", padding) .. text, padding, display_width
  end

  -- Centered instruction lines
  local centered_instruction, instruction_padding, instruction_width = center_line(instruction)
  local centered_close, close_padding, close_width = center_line(close_instruction)
  table.insert(lines, centered_instruction)
  table.insert(lines, centered_close)
  table.insert(lines, "")

  -- Header row
  local header_line = string.format("%" .. key_col_width .. "s   %-s", header[1], header[2])
  table.insert(lines, header_line)

  -- Keymap rows
  for _, keymap_row in ipairs(keymap_rows) do
    local line = string.format("%" .. key_col_width .. "s -> %-s", keymap_row.key, keymap_row.action)
    table.insert(lines, line)
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
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

  -- Highlight centered instruction
  vim.api.nvim_buf_set_extmark(buf, ns, 0, instruction_padding, {
    end_col = instruction_padding + instruction_width,
    hl_group = "Comment",
  })

  -- Highlight centered close instruction
  vim.api.nvim_buf_set_extmark(buf, ns, 1, close_padding, {
    end_col = close_padding + close_width,
    hl_group = "Comment",
  })

  -- Highlight header row
  vim.api.nvim_buf_set_extmark(buf, ns, 3, 0, {
    end_col = vim.str_utfindex(header_line, "utf-8"),
    hl_group = "Title",
  })

  -- Highlight each keymap line
  for i, _ in ipairs(keymap_rows) do
    local line_index = i + 4
    local line = vim.api.nvim_buf_get_lines(buf, line_index, line_index + 1, false)[1]
    if type(line) == "string" then
      local sep_pos = string.find(line, "->", 1, true)
      if sep_pos then
        local key_end = sep_pos - 2
        vim.api.nvim_buf_set_extmark(buf, ns, line_index, 0, {
          end_col = key_end + 1,
          hl_group = "Title",
        })

        local action_start = sep_pos + 3
        local line_utf_len = vim.str_utfindex(line, "utf-8")
        if action_start < line_utf_len then
          vim.api.nvim_buf_set_extmark(buf, ns, line_index, action_start, {
            end_col = line_utf_len,
            hl_group = "@text",
          })
        end
      end
    end
  end

  for _, key in ipairs { "q", "<Esc>" } do
    vim.keymap.set("n", key, "<cmd>close<CR>", { buffer = buf, nowait = true, silent = true, noremap = true })
  end

  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    buffer = buf,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "help"
  vim.bo[buf].modifiable = false
end

return M
