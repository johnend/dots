-- lua/water/ui/water.lua
---@class water.ui.water

local M = {}
local state = require "water.state"
local buffers = require "water.buffers"
local config = require "water.config"
local preview = require "water.ui.preview"

---@type boolean Rendering in progress flag to debounce refreshes
local is_rendering = false

---Utility to calculate the gutter width (numbers, signs, folds).
---@return number
local function get_gutter_width()
  local w = 0
  if vim.wo.number then
    w = w + vim.wo.numberwidth
  end
  if vim.wo.signcolumn and vim.wo.signcolumn ~= "no" then
    w = w + 2
  end
  if tonumber(vim.wo.foldcolumn) then
    w = w + tonumber(vim.wo.foldcolumn)
  elseif vim.wo.foldcolumn ~= "0" then
    w = w + 1
  end
  return w
end

---Render the custom "water" buffer with header and buffer list.
---@param bufnr number The buffer number to render into.
---@param opts table|nil Optional rendering options (overrides state.options).
---@return table|nil bufnr_map Mapping of rendered line indices to buffer numbers, or nil if render aborted.
function M.render(bufnr, opts)
  -- Validate buffer and state
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "nofile" or not state.options then
    return
  end

  -- Ensure the Water buffer is visible
  local visible = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      visible = true
      break
    end
  end
  if not visible then
    return
  end

  -- Determine options and buffers
  local settings = state.options or config.merge()
  local buffer_list = buffers.get_buffers(settings)
  local lines = {}
  local bufnr_map = {}

  -- Find window width for this buffer
  local win_width
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      win_width = vim.api.nvim_win_get_width(win)
      break
    end
  end
  if not win_width then
    return
  end

  local gutter = get_gutter_width()
  local available_width = win_width - gutter

  -- Build header
  local header_lines, HEADER_SIZE = buffers.build_header(available_width)
  vim.list_extend(lines, header_lines)

  -- Build buffer lines
  for i, bufinfo in ipairs(buffer_list) do
    local left = string.format("%-4s%s", tostring(bufinfo.bufnr) .. ":", bufinfo.name)
    local diag_text = buffers.format_diagnostic_text(bufinfo, settings)
    if diag_text ~= "" then
      left = left .. " " .. diag_text
    end
    local right = buffers.format_buffer_status(bufinfo, settings)
    local ts = tostring(buffers.format_last_modified(bufinfo.last_used, settings))
    right = right .. " " .. ts

    local lw = vim.fn.strdisplaywidth(left)
    local rw = vim.fn.strdisplaywidth(right)
    local pad = math.max(1, available_width - lw - rw)
    local line = left .. string.rep(" ", pad) .. right

    lines[#lines + 1] = line
    bufnr_map[#lines] = bufinfo.bufnr
  end

  -- Write lines
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.b.water_map = bufnr_map

  -- Highlighting and extmarks
  local ns = vim.api.nvim_create_namespace "water"
  -- Header highlight
  for i, text in ipairs(header_lines) do
    local wlen = vim.fn.strdisplaywidth(text)
    vim.highlight.range(bufnr, ns, "Title", { i - 1, 0 }, { i - 1, wlen }, {})
  end

  -- Extmarks for each line
  for idx, bufinfo in ipairs(buffer_list) do
    local row = (idx - 1) + HEADER_SIZE
    local text = lines[row + 1] or ""

    -- Buffer ID
    local id_txt = string.format("%d:", bufinfo.bufnr)
    pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, row, 0, {
      end_col = vim.str_utfindex(id_txt, "utf-8"),
      hl_group = "WaterBufferID",
    })

    -- Buffer Name
    local name_start = vim.str_utfindex(id_txt .. " ", "utf-8")
    local name_end = name_start + vim.str_utfindex(bufinfo.name, "utf-8")
    pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, row, name_start, {
      end_col = name_end,
      hl_group = "WaterBufferName",
    })

    -- Diagnostics
    if settings.show_diagnostics and bufinfo.diagnostics then
      for pat, hl in pairs(buffers.diagnostic_patterns(settings)) do
        for match in text:gmatch(pat) do
          local s = text:find(match, 1, true)
          local before = text:sub(1, s - 1)
          local sc = vim.str_utfindex(before, "utf-8")
          local ec = sc + vim.str_utfindex(match, "utf-8")
          pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, row, sc, {
            end_col = ec,
            hl_group = hl,
          })
        end
      end
    end

    -- Git Status
    if bufinfo.git_status then
      for pat, hl in pairs(buffers.git_patterns(settings)) do
        for match in text:gmatch(pat) do
          local s = text:find(match, 1, true)
          local before = text:sub(1, s - 1)
          local sc = vim.str_utfindex(before, "utf-8")
          local ec = sc + vim.str_utfindex(match, "utf-8")
          pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, row, sc, {
            end_col = ec,
            hl_group = hl,
          })
        end
      end
    end

    -- Timestamp
    do
      local ts_txt = tostring(buffers.format_last_modified(bufinfo.last_used, settings))
      local ts_pos = text:find(ts_txt, 1, true)
      if ts_pos then
        local before = text:sub(1, ts_pos - 1)
        local sc = vim.str_utfindex(before, "utf-8")
        local ec = sc + vim.str_utfindex(ts_txt, "utf-8")
        pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, row, sc, {
          end_col = ec,
          hl_group = "WaterTimestamp",
        })
      end
    end
  end

  return bufnr_map
end

---Open a floating "water" buffer and set up keymaps.
---@param opts table Rendering options to apply.
function M.open(opts)
  state.last_buf = vim.api.nvim_get_current_buf()
  local bufnr = vim.api.nvim_create_buf(false, true)
  local winid = vim.api.nvim_get_current_win()
  state.water_winid = winid

  vim.api.nvim_set_option_value("buftype", "nofile", { scope = "local", buf = bufnr })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { scope = "local", buf = bufnr })
  vim.api.nvim_set_option_value("swapfile", false, { scope = "local", buf = bufnr })
  vim.api.nvim_set_option_value("filetype", "water", { scope = "local", buf = bufnr })
  vim.api.nvim_set_option_value("wrap", false, { scope = "local", win = winid })
  vim.api.nvim_buf_set_name(bufnr, "water://")

  vim.api.nvim_set_current_buf(bufnr)
  state.water_bufnr = bufnr
  state.options = opts

  local bufnr_map = M.render(bufnr, opts)
  require("water.keymaps").apply(bufnr, bufnr_map or {}, opts, function()
    vim.cmd "WaterRefresh"
  end)
end

---Refresh the water buffer if visible, debounced.
function M.refresh()
  if is_rendering then
    return
  end
  is_rendering = true

  vim.defer_fn(function()
    local bufnr, opts = state.water_bufnr, state.options
    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) or not opts then
      is_rendering = false
      return
    end
    local vis = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == bufnr then
        vis = true
        break
      end
    end
    if not vis then
      is_rendering = false
      return
    end

    M.render(bufnr, opts)
    is_rendering = false
  end, 50)
end

---Close the water buffer and return to previous buffer.
function M.close()
  if preview and preview.close then
    preview.close()
  end

  if state.last_buf and vim.api.nvim_buf_is_valid(state.last_buf) then
    vim.api.nvim_set_current_buf(state.last_buf)
  end
end

---Toggle the water buffer open/closed.
---@param opts table Rendering options to apply when opening.
function M.toggle(opts)
  local current = vim.api.nvim_get_current_buf()
  if state.water_bufnr and vim.api.nvim_buf_is_valid(state.water_bufnr) and current == state.water_bufnr then
    M.close()
  else
    M.open(opts)
  end
end

return M
