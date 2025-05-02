-- lua/water/buffers.lua
local M = {}
local gitsigns_available, _gitsigns = pcall(require, "gitsigns")
local state = require "water.state"
local config = require "water.config"

---------------------------------------
--- Header section
---------------------------------------
function M.build_header(available_width)
  local left = "ID: Name"
  local right = "Git Status  Last Used"
  local pad = math.max(1, available_width - vim.fn.strdisplaywidth(left) - vim.fn.strdisplaywidth(right))
  return { left .. string.rep(" ", pad) .. right, "" }, 2
end

---------------------------------------
--- Left sections
---------------------------------------
function M.format_path(path, method)
  if type(method) == "function" then
    return method(path)
  end
  if method == "full_path" then
    return path
  end
  if method == "short_path" then
    local parent = vim.fn.fnamemodify(path, ":h:t")
    local filename = vim.fn.fnamemodify(path, ":t")
    return parent .. "/" .. filename
  elseif method == "file_name" then
    return vim.fn.fnamemodify(path, ":t")
  end
  return path
end

function M.diagnostic_patterns(opts)
  local icons = opts.icons.diagnostics
  local patmap = {}
  if icons.err then
    patmap[icons.err .. " %d+"] = "WaterDiagnosticError"
    patmap[icons.err] = "WaterDiagnosticError"
  end
  if icons.warn then
    patmap[icons.warn .. " %d+"] = "WaterDiagnosticWarn"
    patmap[icons.warn] = "WaterDiagnosticWarn"
  end
  return patmap
end

---------------------------------------
--- Right sections
---------------------------------------
local function get_git_status(bufnr)
  if not gitsigns_available then
    return nil
  end
  local status = vim.b[bufnr] and vim.b[bufnr].gitsigns_status_dict
  if not status then
    return nil
  end

  local opts = state.options or config.merge()
  local icons = opts.icons
  local parts = {}
  if status.added and status.added > 0 then
    table.insert(parts, string.format("%s %d", icons.git.added, status.added))
  end
  if status.changed and status.changed > 0 then
    table.insert(parts, string.format("%s %d", icons.git.changed, status.changed))
  end
  if status.removed and status.removed > 0 then
    table.insert(parts, string.format("%s %d", icons.git.removed, status.removed))
  end
  return #parts > 0 and table.concat(parts, " ") or nil
end

function M.git_patterns(opts)
  local icons = opts.icons.git
  local patmap = {
    [icons.added .. " %d+"] = "GitSignsAdd",
    [icons.changed .. " %d+"] = "GitSignsChange",
    [icons.removed .. " %d+"] = "GitSignsDelete",
  }
  if icons.untracked then
    patmap[icons.untracked .. " %d+"] = "GitSignsUntracked"
  end
  return patmap
end

function M.format_last_modified(timestamp, opts)
  if timestamp == 0 then
    return ""
  end
  local now = os.time()
  local today = os.date("*t", now)
  local mod = os.date("*t", timestamp)

  if today.year == mod.year and today.yday == mod.yday then
    return opts.time_format == "12h" and os.date("%I:%M %p", timestamp) or os.date("%H:%M", timestamp)
  elseif today.year == mod.year and today.yday - mod.yday == 1 then
    return (opts.time_format == "12h" and "Yesterday at " .. os.date("%I:%M %p", timestamp))
      or ("Yesterday at " .. os.date("%H:%M", timestamp))
  else
    local date_str = opts.date_format == "dd/mm" and os.date("%d/%m", timestamp) or os.date("%m/%d", timestamp)
    local time_str = opts.time_format == "12h" and os.date("%I:%M %p", timestamp) or os.date("%H:%M", timestamp)
    return string.format("%s at %s", date_str, time_str)
  end
end

---------------------------------------
--- Helpers
---------------------------------------
function M.get_buffers(opts)
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local name = vim.api.nvim_buf_get_name(buf)
      if name == "" then
        name = "[No Name]"
      end
      local formatted_name = M.format_path(name, opts.path_display)
      local diagnostics = vim.diagnostic.count(buf)
      local info = vim.fn.getbufinfo(buf)[1]

      table.insert(buffers, {
        bufnr = buf,
        name = formatted_name,
        modified = vim.bo[buf].modified,
        readonly = vim.bo[buf].readonly,
        diagnostics = diagnostics,
        last_used = info.lastused or 0,
        git_status = get_git_status(buf),
      })
    end
  end

  if opts.sort_buffers == "alphabetical" then
    table.sort(buffers, function(a, b)
      return a.name:lower() < b.name:lower()
    end)
  elseif opts.sort_buffers == "last_modified" then
    table.sort(buffers, function(a, b)
      return a.last_used > b.last_used
    end)
  elseif opts.sort_buffers == "id" then
    table.sort(buffers, function(a, b)
      return a.bufnr < b.bufnr
    end)
  end

  return buffers
end

return M
