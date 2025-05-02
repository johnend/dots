local state = require "water.state"
local buffers = require "water.buffers"
local config = require "water.config"

local M = {}

local function get_gutter_width()
  local width = 0

  if vim.wo.number then
    width = width + vim.wo.numberwidth
  end

  if vim.wo.signcolumn and vim.wo.signcolumn ~= "no" then
    width = width + 2
  end

  if tonumber(vim.wo.foldcolumn) then
    width = width + tonumber(vim.wo.foldcolumn)
  elseif vim.wo.foldcolumn ~= "0" then
    width = width + 1
  end

  return width
end

function M.render(bufnr, opts)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "nofile" or not state.options then
    return
  end

  -- ensure the buffer is visible
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

  local opts = state.options or config.merge()
  local buffer_list = buffers.get_buffers(opts)
  local lines = {}
  local bufnr_map = {}

  -- find the window width and gutter
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

  -- HEADER SECTION
  local header_lines, HEADER_SIZE = buffers.build_header(available_width)
  vim.list_extend(lines, header_lines)

  -- build lines for each buffer
  for i, b in ipairs(buffer_list) do
    local left = string.format("%d: %s", b.bufnr, b.name)

    if opts.show_diagnostics and b.diagnostics then
      local err = b.diagnostics[vim.diagnostic.severity.ERROR] or 0
      local warn = b.diagnostics[vim.diagnostic.severity.WARN] or 0
      if err > 0 then
        left = left .. string.format("  %d", err)
      elseif warn > 0 then
        left = left .. string.format("  %d", warn)
      end
    end

    local right = b.git_status or ""
    if opts.use_nerd_icons then
      if b.modified then
        right = right .. " "
      end
      if b.readonly then
        right = right .. " "
      end
    else
      if opts.show_modified and b.modified then
        right = right .. " [+]"
      end
      if opts.show_readonly and b.readonly then
        right = right .. " [RO]"
      end
    end

    local timestamp = tostring(buffers.format_last_modified(b.last_used, opts))
    right = right .. " " .. timestamp

    local left_width = vim.fn.strdisplaywidth(left)
    local right_width = vim.fn.strdisplaywidth(right)
    local padding = math.max(1, available_width - left_width - right_width)

    local line = left .. string.rep(" ", padding) .. right
    table.insert(lines, line)
    bufnr_map[#lines] = b.bufnr
  end

  -- set buffer contents
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.b.water_map = bufnr_map

  local ns = vim.api.nvim_create_namespace "water"

  -- highlight the header row using vim.highlight.range()
  for i, hl in ipairs(header_lines) do
    local width = vim.fn.strdisplaywidth(hl)
    vim.highlight.range(bufnr, ns, "Title", { i - 1, 0 }, { i - 1, width }, {})
  end

  -- set extmarks for each buffer line
  for i, buf in ipairs(buffer_list) do
    local line_idx = (i - 1) + HEADER_SIZE
    local line = lines[i + HEADER_SIZE] or ""

    -- Buffer ID extmark
    local id_text = string.format("%d:", buf.bufnr)
    pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line_idx, 0, {
      end_col = vim.str_utfindex(id_text, "utf-8"),
      hl_group = "WaterBufferID",
    })

    -- Buffer name extmark
    local name_text = buf.name
    local name_start = vim.str_utfindex(id_text .. " ", "utf-8")
    local name_end = name_start + vim.str_utfindex(name_text, "utf-8")
    pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line_idx, name_start, {
      end_col = name_end,
      hl_group = "WaterBufferName",
    })

    -- Diagnostics extmarks
    if opts.show_diagnostics and buf.diagnostics then
      for pattern, hl in pairs(buffers.diagnostic_patterns(opts)) do
        for match in line:gmatch(pattern) do
          local s = line:find(match, 1, true)
          local before = line:sub(1, s - 1)
          local start_col = vim.str_utfindex(before, "utf-8")
          local end_col = start_col + vim.str_utfindex(match, "utf-8")
          pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line_idx, start_col, {
            end_col = end_col,
            hl_group = hl,
          })
        end
      end
    end

    -- Git status extmarks
    if buf.git_status then
      for pattern, hl in pairs(buffers.git_patterns(opts)) do
        for match in string.gmatch(line, pattern) do
          local s = string.find(line, match, 1, true)
          local before = line:sub(1, s - 1)
          local start_col = vim.str_utfindex(before, "utf-8")
          local end_col = start_col + vim.str_utfindex(match, "utf-8")
          pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line_idx, start_col, {
            end_col = end_col,
            hl_group = hl,
          })
        end
      end
    end

    -- Timestamp extmark
    do
      local timestamp = tostring(buffers.format_last_modified(buf.last_used, opts))
      local ts_start = string.find(line, timestamp, 1, true)
      if ts_start and ts_start > 0 then
        local before = line:sub(1, ts_start - 1)
        local start_col = vim.str_utfindex(before, "utf-8")
        local end_col = start_col + vim.str_utfindex(timestamp, "utf-8")
        pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line_idx, start_col, {
          end_col = end_col,
          hl_group = "WaterTimestamp",
        })
      end
    end
  end

  return bufnr_map
end

function M.open(opts)
  state.last_buf = vim.api.nvim_get_current_buf()
  local bufnr = vim.api.nvim_create_buf(false, true)
  local winid = vim.api.nvim_get_current_win()
  state.water_winid = winid

  -- buffer metadata & window options
  vim.api.nvim_set_option_value("buftype", "nofile", { scope = "local", buf = bufnr })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { scope = "local", buf = bufnr })
  vim.api.nvim_set_option_value("swapfile", false, { scope = "local", buf = bufnr })
  vim.api.nvim_set_option_value("filetype", "water", { scope = "local", buf = bufnr })
  vim.api.nvim_set_option_value("wrap", false, { scope = "local", win = winid })
  vim.api.nvim_buf_set_name(bufnr, "water://")

  -- switch to our water buffer
  vim.api.nvim_set_current_buf(bufnr)
  state.water_bufnr = bufnr
  state.options = opts

  local bufnr_map = M.render(bufnr, opts)

  local keymaps = require "water.keymaps"
  keymaps.apply(bufnr, bufnr_map or {}, opts, function()
    vim.cmd "WaterRefresh"
  end)
end

local is_rendering = false

function M.refresh()
  if is_rendering then
    return
  end
  is_rendering = true

  vim.defer_fn(function()
    local bufnr = state.water_bufnr
    local opts = state.options
    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) or not opts then
      is_rendering = false
      return
    end

    local visible = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == bufnr then
        visible = true
        break
      end
    end
    if not visible then
      is_rendering = false
      return
    end

    M.render(bufnr, opts)
    is_rendering = false
  end, 50)
end

function M.close()
  if state.last_buf and vim.api.nvim_buf_is_valid(state.last_buf) then
    vim.api.nvim_set_current_buf(state.last_buf)
  end
end

function M.toggle(opts)
  local current = vim.api.nvim_get_current_buf()
  if state.water_bufnr and vim.api.nvim_buf_is_valid(state.water_bufnr) and current == state.water_bufnr then
    M.close()
  else
    M.open(opts)
  end
end

return M
