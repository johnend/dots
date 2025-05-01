-- lua/water/ui/water.lua
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
    width = width + 2 -- conservative default
  end

  if tonumber(vim.wo.foldcolumn) then
    width = width + tonumber(vim.wo.foldcolumn)
  elseif vim.wo.foldcolumn ~= "0" then
    width = width + 1
  end

  return width
end

function M.open(opts)
  state.last_buf = vim.api.nvim_get_current_buf()
  local bufnr = vim.api.nvim_create_buf(false, true)

  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].swapfile = false

  state.water_bufnr = bufnr
  state.options = opts
  M.render(bufnr, opts)
end

function M.render(bufnr, opts)
  local buffer_list = buffers.get_buffers(opts)
  local lines = {}
  local bufnr_map = {}

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

    local timestamp = buffers.format_last_modified(b.last_used, opts)
    right = right .. " " .. timestamp

    local win_width = vim.api.nvim_win_get_width(0)
    local gutter = get_gutter_width()
    local effective_width = win_width - gutter
    local padding = math.max(2, effective_width - vim.fn.strdisplaywidth(left) - vim.fn.strdisplaywidth(right))

    local line = left .. string.rep(" ", padding) .. right
    table.insert(lines, line)
    bufnr_map[i] = b.bufnr
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_set_current_buf(bufnr)
  state.water_bufnr = bufnr
  vim.b.water_map = bufnr_map

  local ns = vim.api.nvim_create_namespace "water"

  for i, buf in ipairs(buffer_list) do
    local line_idx = i - 1
    local line = lines[i] or ""

    local id_text = string.format("%d:", buf.bufnr)
    local _ = pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line_idx, 0, {
      end_col = vim.str_utfindex(id_text, "utf-8"),
      hl_group = "WaterBufferID",
    })

    local name_text = buf.name
    local name_start = vim.str_utfindex(id_text .. " ", "utf-8")
    local name_end = name_start + vim.str_utfindex(name_text, "utf-8")
    local _ = pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line_idx, name_start, {
      end_col = name_end,
      hl_group = "WaterBufferName",
    })

    if opts.show_diagnostics and buf.diagnostics then
      local diag_group = nil
      local error_count = buf.diagnostics[vim.diagnostic.severity.ERROR] or 0
      local warn_count = buf.diagnostics[vim.diagnostic.severity.WARN] or 0

      if error_count > 0 then
        diag_group = "WaterDiagnosticError"
      elseif warn_count > 0 then
        diag_group = "WaterDiagnosticWarn"
      end

      if diag_group then
        local diag_text = line:match " %d+" or line:match " %d+" or line:match "" or line:match ""
        if diag_text then
          local s = string.find(line, diag_text, 1, true)
          if s and s > 0 and s <= #line then
            local before = line:sub(1, s - 1)
            local start_col = vim.str_utfindex(before, "utf-8")
            local end_col = start_col + vim.str_utfindex(diag_text, "utf-8")
            if end_col > start_col then
              pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line_idx, start_col, {
                end_col = end_col,
                hl_group = diag_group,
              })
            end
          end
        end
      end
    end

    if buf.git_status then
      for pattern, hl in pairs {
        [" %d+"] = "GitSignsAdd",
        [" %d+"] = "GitSignsChange",
        [" %d+"] = "GitSignsDelete",
      } do
        for match in string.gmatch(line, pattern) do
          local s = string.find(line, match, 1, true)
          if s and s > 0 and s <= #line then
            local before = line:sub(1, s - 1)
            local start_col = vim.str_utfindex(before, "utf-8")
            local end_col = start_col + vim.str_utfindex(match, "utf-8")
            if end_col > start_col then
              pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line_idx, start_col, {
                end_col = end_col,
                hl_group = hl,
              })
            end
          end
        end
      end
    end

    local timestamp = buffers.format_last_modified(buf.last_used, opts)
    local ts_start = string.find(line, timestamp, 1, true)
    if ts_start and ts_start > 0 then
      local before = line:sub(1, ts_start - 1)
      local start_col = vim.str_utfindex(before, "utf-8")
      local end_col = start_col + vim.str_utfindex(timestamp, "utf-8")
      if end_col > start_col then
        pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line_idx, start_col, {
          end_col = end_col,
          hl_group = "WaterTimestamp",
        })
      end
    end
  end

  local keymaps = require "water.keymaps"
  keymaps.apply(bufnr, bufnr_map, opts, function()
    M.open(opts)
  end)
end

function M.refresh()
  local bufnr = state.water_bufnr
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    M.render(bufnr, state.options)
  end
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
