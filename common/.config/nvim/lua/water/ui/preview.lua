-- lua/water/ui/preview.luapreview
local api = vim.api
local M = {}

-- internal state
local preview_win -- window ID of the preview
local preview_map -- bufnr_map passed in on toggle
local preview_autocmd -- autocmd ID for CursorMoved
local leave_autocmd -- autocmd ID for BufLeave

--- Opens or closes the preview.  When opened, also sets up an autocmd
--- so that moving the cursor in the Water buffer updates the preview.
---@param bufnr_map table Mapping of Water-buffer lines → real bufnr
function M.toggle(bufnr_map)
  -- If already open, clear autocmd + close
  if preview_win and api.nvim_win_is_valid(preview_win) then
    if preview_autocmd then
      api.nvim_del_autocmd(preview_autocmd)
      preview_autocmd = nil
    end

    if leave_autocmd then
      api.nvim_del_autocmd(leave_autocmd)
      leave_autocmd = nil
    end

    api.nvim_win_close(preview_win, true)
    preview_win = nil
    preview_map = nil
    return
  end

  -- Otherwise, store the map and open initially
  preview_map = bufnr_map

  -- get which real bufnr is under the current cursor
  local row = api.nvim_win_get_cursor(0)[1]
  local target = preview_map[row]
  if not target then
    return
  end

  -- fetch up to 50 lines from target
  local line_count = api.nvim_buf_line_count(target)
  local lines = api.nvim_buf_get_lines(target, 0, math.min(50, line_count), false)

  -- create scratch buffer
  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  api.nvim_set_option_value("filetype", vim.bo[target].filetype, { buf = buf })

  -- size & position: bottom-right, 40%×50%
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.5)
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = vim.o.lines - height - 2,
    col = vim.o.columns - width - 2,
    style = "minimal",
    border = "rounded",
    title = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(target), ":t"),
    title_pos = "center",
  }

  preview_win = api.nvim_open_win(buf, false, opts)

  -- register autocmd so moving cursor refreshes preview
  local water_buf = api.nvim_get_current_buf()

  preview_autocmd = api.nvim_create_autocmd("CursorMoved", {
    buffer = water_buf,
    callback = function()
      M.update()
    end,
  })

  leave_autocmd = api.nvim_create_autocmd("BufLeave", {
    buffer = water_buf,
    callback = M.close,
  })
end

---Refresh the existing preview window to show the buffer under cursor.
function M.update()
  if not (preview_win and api.nvim_win_is_valid(preview_win)) then
    return
  end
  if not preview_map then
    return
  end

  -- find new target under cursor
  local row = api.nvim_win_get_cursor(0)[1]
  local target = preview_map[row]
  if not target then
    return
  end

  -- grab up to 50 lines
  local total = api.nvim_buf_line_count(target)
  local lines = api.nvim_buf_get_lines(target, 0, math.min(50, total), false)

  -- get the scratch buf and overwrite its lines
  local buf = api.nvim_win_get_buf(preview_win)
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(target), ":t")
  api.nvim_win_set_config(preview_win, { title = fname })

  -- ensure correct filetype for syntax highlight
  api.nvim_set_option_value("filetype", vim.bo[target].filetype, { buf = buf })
end

function M.close()
  if preview_autocmd then
    vim.api.nvim_del_autocmd(preview_autocmd)
    preview_autocmd = nil
  end

  if leave_autocmd then
    api.nvim_del_autocmd(leave_autocmd)
    leave_autocmd = nil
  end

  if preview_win and vim.api.nvim_win_is_valid(preview_win) then
    vim.api.nvim_win_close(preview_win, true)
    preview_win = nil
  end

  preview_map = nil
end

return M
