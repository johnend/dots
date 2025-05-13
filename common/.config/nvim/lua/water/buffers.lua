-- lua/water/buffers.lua
---@class water.buffers

local M = {}
local gitsigns_available, _gitsigns = pcall(require, "gitsigns")
local state = require "water.state"
local config = require "water.config"

---------------------------------------
--- Header section
---------------------------------------

---Builds the header lines for the buffer list view.
---@param available_width number The width available for rendering header content.
---@return string[] header_lines - Two-line header: labels and underline.
---@return number header_size - Number of lines in the header (always 2).
function M.build_header(available_width)
  -- local left = "ID: Name"
  -- local right = "Git Status  Last Used"
  -- -- Calculate padding between left and right segments
  -- local pad = math.max(1, available_width - vim.fn.strdisplaywidth(left) - vim.fn.strdisplaywidth(right))
  -- -- Return header content and its height
  -- return { left .. string.rep(" ", pad) .. right, "" }, 2

  -- define columns
  local id_col = string.format("%-4s", "ID:")
  local name_col = string.format("%-30s", "Name")
  local git_col = string.format("%-14s", "Git Status")
  local last_col = string.format("%-9s", "Last Used")

  -- build left/right halves
  local left = id_col .. name_col
  local right = git_col .. last_col

  -- pad so right half is right aligned
  local pad = math.max(1, available_width - vim.fn.strdisplaywidth(left) - vim.fn.strdisplaywidth(right))

  local header = left .. string.rep(" ", pad) .. right
  return { header, "" }, 2
end

---------------------------------------
--- Left sections (path & diagnostics)
---------------------------------------

---Formats a file path according to the display method.
---@param path string The original buffer file path.
---@param method string|fun(string):string Display method key or custom function.
---@return string formatted - The formatted path.
function M.format_path(path, method)
  if type(method) == "function" then
    return method(path)
  end
  if method == "full_path" then
    return path
  end
  if method == "short_path" then
    -- Show only parent folder name and file name
    local parent = vim.fn.fnamemodify(path, ":h:t")
    local filename = vim.fn.fnamemodify(path, ":t")
    return parent .. "/" .. filename
  elseif method == "file_name" then
    -- Show only the file name
    return vim.fn.fnamemodify(path, ":t")
  end
  -- Fallback to original path
  return path
end

---Returns diagnostic icon patterns for highlighting.
---@param opts table Rendering options, including icons.diagnostics.
---@return table<string, string> pattern_map - Keys are Lua patterns, values are highlight groups.
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

---Formats diagnostic summary text (error/warning counts).
---@param buf table Buffer info with diagnostics counts.
---@param opts table Rendering options, including icons and show_diagnostics flag.
---@return string text - Icon plus count, or empty string if none.
function M.format_diagnostic_text(buf, opts)
  if not opts.show_diagnostics or not buf.diagnostics then
    return ""
  end

  local icons = opts.icons.diagnostics
  local err = buf.diagnostics[vim.diagnostic.severity.ERROR] or 0
  local warn = buf.diagnostics[vim.diagnostic.severity.WARN] or 0

  if err > 0 then
    return string.format("%s %d", icons.err, err)
  elseif warn > 0 then
    return string.format("%s %d", icons.warn, warn)
  end

  return ""
end

---------------------------------------
--- Right sections (git status & timestamps)
---------------------------------------

---Retrieves git status counts for a buffer via gitsigns.
---@param bufnr number Buffer number to query.
---@return string|nil status_text - Formatted git icons and counts, or nil if none.
local function get_git_status(bufnr)
  if not gitsigns_available then
    return nil
  end
  local status = vim.b[bufnr] and vim.b[bufnr].gitsigns_status_dict
  if not status then
    return nil
  end

  local opts = state.options or config.merge()
  local icons = opts.icons.git
  local parts = {}
  if status.added and status.added > 0 then
    table.insert(parts, string.format("%s %d", icons.added, status.added))
  end
  if status.changed and status.changed > 0 then
    table.insert(parts, string.format("%s %d", icons.changed, status.changed))
  end
  if status.removed and status.removed > 0 then
    table.insert(parts, string.format("%s %d", icons.removed, status.removed))
  end
  return #parts > 0 and table.concat(parts, " ") .. string.rep(" ", 7) or nil
end

---Returns git icon patterns for highlighting.
---@param opts table Rendering options, including icons.git.
---@return table<string, string> pattern_map - Lua patterns to highlight groups.
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

---Formats the last modified timestamp for display.
---@param timestamp number Unix epoch of last use (seconds).
---@param opts table Rendering options with date_format and time_format.
---@return string|osdate formatted - Relative or absolute time string.
function M.format_last_modified(timestamp, opts)
  if timestamp == 0 then
    return ""
  end
  local now = os.time()
  local today = os.date("*t", now)
  local mod = os.date("*t", timestamp)

  -- Same day: show time only
  if today.year == mod.year and today.yday == mod.yday then
    return opts.time_format == "12h" and os.date("%I:%M %p", timestamp) or os.date("%H:%M", timestamp)
  -- Yesterday: include "Yesterday at"
  elseif today.year == mod.year and today.yday - mod.yday == 1 then
    local prefix = "Yesterday at "
    return prefix .. (opts.time_format == "12h" and os.date("%I:%M %p", timestamp) or os.date("%H:%M", timestamp))
  else
    -- Older: date and time
    local date_str = opts.date_format == "dd/mm" and os.date("%d/%m", timestamp) or os.date("%m/%d", timestamp)
    local time_str = opts.time_format == "12h" and os.date("%I:%M %p", timestamp) or os.date("%H:%M", timestamp)
    return string.format("%s at %s", date_str, time_str)
  end
end

---------------------------------------
--- Helpers: collect and sort buffers
---------------------------------------

---Gathers loaded, listed buffers and their metadata.
---@param opts table Rendering options, including path_display and sorting.
---@return table[] buffer_list - Array of buffer info tables:
---  bufnr (number), name (string), modified (boolean), readonly (boolean),
---  diagnostics (table), last_used (number), git_status (string|nil).
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

  -- Sort according to user preference
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

---Formats buffer status flags (git, modified, readonly) into icons or text.
---@param buf table Buffer metadata with git_status, modified, readonly.
---@param opts table Rendering options: use_nerd_icons, show_modified, show_readonly.
---@return string status_text - Concatenated status icons or labels.
function M.format_buffer_status(buf, opts)
  local status = buf.git_status or ""

  if opts.use_nerd_icons then
    if buf.modified then
      status = status .. " "
    end
    if buf.readonly then
      status = status .. " "
    end
  else
    if opts.show_modified and buf.modified then
      status = status .. " [+]"
    end
    if opts.show_readonly and buf.readonly then
      status = status .. " [RO]"
    end
  end
  return status
end

return M
