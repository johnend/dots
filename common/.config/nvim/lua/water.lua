local M = {}

---@class WaterOptions
---@field show_modified boolean
---@field show_readonly boolean
---@field show_diagnostics boolean
---@field highlight_cursorline boolean
---@field sort_buffers 'id' | 'alphabetical' | 'last_modified'
---@field use_nerd_icons boolean
---@field path_display 'full_path' | 'short_path' | 'file_name' | fun(path: string): string
---@field keymaps table<string, string>
---@field date_format 'dd/mm' | 'mm/dd'
---@field time_format '24h' | '12h'

M.sort_methods = {
  id = "id",
  alphabetical = "alphabetical",
  last_modified = "last_modified",
}

M.path_display_methods = {
  full_path = "full_path",
  short_path = "short_path",
  file_name = "file_name",
}

---@type WaterOptions
M.options = {
  show_modified = true,
  show_readonly = true,
  show_diagnostics = true,
  highlight_cursorline = true,
  sort_buffers = M.sort_methods.last_modified,
  use_nerd_icons = true,
  path_display = "full_path",
  date_format = "dd/mm",
  time_format = "24h",
  keymaps = {
    toggle = "_",
    open = "<CR>",
    delete = "d",
    split = "s",
    vsplit = "v",
    refresh = "r",
  },
}

local water_bufnr = nil
local last_buf = nil
local gitsigns_available, gitsigns = pcall(require, "gitsigns")

local function define_highlights()
  vim.api.nvim_set_hl(0, "WaterBufferID", { link = "@comment", default = true })
  vim.api.nvim_set_hl(0, "WaterBufferName", { link = "@text", default = true })
  vim.api.nvim_set_hl(0, "WaterDiagnosticError", { link = "DiagnosticError", default = true })
  vim.api.nvim_set_hl(0, "WaterDiagnosticWarn", { link = "DiagnosticWarn", default = true })
  vim.api.nvim_set_hl(0, "WaterTimestamp", { link = "@comment", default = true })
end

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options or {}, opts or {})
  define_highlights()

  vim.api.nvim_create_user_command("Water", function()
    require("water").toggle_water()
  end, { desc = "Toggle Water buffer manager" })

  if M.options.keymaps.toggle then
    vim.keymap.set(
      "n",
      M.options.keymaps.toggle,
      "<cmd>Water<CR>",
      { noremap = true, silent = true, desc = "Toggle Water buffer manager" }
    )
  end
end

local function format_path(path)
  if type(M.options.path_display) == "function" then
    return M.options.path_display(path)
  end
  if M.options.path_display == M.path_display_methods.full_path then
    return path
  elseif M.options.path_display == M.path_display_methods.short_path then
    local parent = vim.fn.fnamemodify(path, ":h:t")
    local filename = vim.fn.fnamemodify(path, ":t")
    return parent .. "/" .. filename
  elseif M.options.path_display == M.path_display_methods.file_name then
    return vim.fn.fnamemodify(path, ":t")
  else
    return path
  end
end

local function format_last_modified(timestamp)
  if timestamp == 0 then
    return ""
  end
  local now = os.time()
  local today = os.date("*t", now)
  local mod = os.date("*t", timestamp)

  if today.year == mod.year and today.yday == mod.yday then
    if M.options.time_format == "12h" then
      return os.date("%I:%M %p", timestamp)
    else
      return os.date("%H:%M", timestamp)
    end
  elseif today.year == mod.year and today.yday - mod.yday == 1 then
    if M.options.time_format == "12h" then
      return "Yesterday at " .. os.date("%I:%M %p", timestamp)
    else
      return "Yesterday at " .. os.date("%H:%M", timestamp)
    end
  else
    local date_str
    if M.options.date_format == "dd/mm" then
      date_str = os.date("%d/%m", timestamp)
    else
      date_str = os.date("%m/%d", timestamp)
    end
    if M.options.time_format == "12h" then
      return string.format("%s at %s", date_str, os.date("%I:%M %p", timestamp))
    else
      return string.format("%s at %s", date_str, os.date("%H:%M", timestamp))
    end
  end
end

local function get_git_status(bufnr)
  if not gitsigns_available then
    return nil
  end
  local status = vim.b[bufnr] and vim.b[bufnr].gitsigns_status_dict
  if not status then
    return nil
  end

  local parts = {}
  if status.added and status.added > 0 then
    table.insert(parts, string.format(" %d", status.added))
  end
  if status.changed and status.changed > 0 then
    table.insert(parts, string.format(" %d", status.changed))
  end
  if status.removed and status.removed > 0 then
    table.insert(parts, string.format(" %d", status.removed))
  end

  return #parts > 0 and table.concat(parts, " ") or nil
end

local function get_buffer_list()
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local name = vim.api.nvim_buf_get_name(buf)
      if name == "" then
        name = "[No Name]"
      end
      local formatted_name = format_path(name)
      local modified = vim.bo[buf].modified
      local readonly = vim.bo[buf].readonly
      local diagnostics = vim.diagnostic.count(buf)
      local last_used = vim.fn.getbufinfo(buf)[1].lastused or 0
      local git_status = get_git_status(buf)

      table.insert(buffers, {
        bufnr = buf,
        name = formatted_name,
        modified = modified,
        readonly = readonly,
        diagnostics = diagnostics,
        last_used = last_used,
        git_status = git_status,
      })
    end
  end

  if M.options.sort_buffers == M.sort_methods.alphabetical then
    table.sort(buffers, function(a, b)
      return a.name:lower() < b.name:lower()
    end)
  elseif M.options.sort_buffers == M.sort_methods.last_modified then
    table.sort(buffers, function(a, b)
      return a.last_used > b.last_used
    end)
  elseif M.options.sort_buffers == M.sort_methods.id then
    table.sort(buffers, function(a, b)
      return a.bufnr < b.bufnr
    end)
  end

  return buffers
end

local function format_buffer_entry(buf)
  local left = string.format("%d: %s", buf.bufnr, buf.name)

  if M.options.show_diagnostics and buf.diagnostics then
    local error_count = buf.diagnostics[vim.diagnostic.severity.ERROR] or 0
    local warn_count = buf.diagnostics[vim.diagnostic.severity.WARN] or 0
    if error_count > 0 then
      left = left .. (error_count > 1 and string.format("  %d", error_count) or " ")
    elseif warn_count > 0 then
      left = left .. (warn_count > 1 and string.format("  %d", warn_count) or " ")
    end
  end

  local right = ""
  if buf.git_status then
    right = buf.git_status
  else
    if M.options.use_nerd_icons then
      if buf.modified then
        right = right .. " "
      end
      if buf.readonly then
        right = right .. " "
      end
    else
      if M.options.show_modified and buf.modified then
        right = right .. " [+]"
      end
      if M.options.show_readonly and buf.readonly then
        right = right .. " [RO]"
      end
    end
  end

  if right ~= "" then
    right = " " .. right
  end

  right = right .. " " .. format_last_modified(buf.last_used)

  local width = vim.api.nvim_win_get_width(0)
  local safe_margin = 6
  local effective_width = width - safe_margin
  local padding = effective_width - vim.fn.strdisplaywidth(left) - vim.fn.strdisplaywidth(right)
  padding = padding > 2 and padding or 2

  return left .. string.rep(" ", padding) .. right
end

local function open_water()
  last_buf = vim.api.nvim_get_current_buf()

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false

  vim.api.nvim_set_current_buf(buf)

  if M.options.highlight_cursorline then
    vim.wo.cursorline = true
  end

  local buffers = get_buffer_list()
  local lines = {}
  for _, b in ipairs(buffers) do
    table.insert(lines, format_buffer_entry(b))
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local bufnr_map = {}
  for i, b in ipairs(buffers) do
    bufnr_map[i] = b.bufnr
  end
  vim.b.water_map = bufnr_map

  local ns = vim.api.nvim_create_namespace "water"

  for i, b in ipairs(buffers) do
    local line_idx = i - 1
    local line = lines[i]

    local id_text = string.format("%d:", b.bufnr)
    vim.api.nvim_buf_set_extmark(buf, ns, line_idx, 0, {
      end_col = #id_text,
      hl_group = "WaterBufferID",
    })

    local name_start = #id_text + 2
    local name_end = name_start + #b.name
    vim.api.nvim_buf_set_extmark(buf, ns, line_idx, name_start, {
      end_col = name_end,
      hl_group = "WaterBufferName",
    })

    if M.options.show_diagnostics and b.diagnostics then
      local diag_start = name_end
      local diag_group = nil
      local error_count = b.diagnostics[vim.diagnostic.severity.ERROR] or 0
      local warn_count = b.diagnostics[vim.diagnostic.severity.WARN] or 0

      if error_count > 0 then
        diag_group = "WaterDiagnosticError"
      elseif warn_count > 0 then
        diag_group = "WaterDiagnosticWarn"
      end

      if diag_group then
        local diag_text = line:sub(diag_start + 1)
        vim.api.nvim_buf_set_extmark(buf, ns, line_idx, diag_start, {
          end_col = diag_start + vim.fn.strdisplaywidth(diag_text),
          hl_group = diag_group,
        })
      end
    end

    local right = tostring(format_last_modified(b.last_used))
    local right_start = string.find(line, right, 1, true)
    if right_start then
      vim.api.nvim_buf_set_extmark(buf, ns, line_idx, right_start - 1, {
        end_col = right_start - 1 + #right,
        hl_group = "WaterTimestamp",
      })
    end

    if b.git_status or b.modified or b.readonly then
      local git_text = b.git_status or (b.modified and "" or "") .. (b.readonly and " " or "")
      if b.git_status then
        for pattern, hl in pairs {
          [" %d+"] = "GitSignsAdd",
          [" %d+"] = "GitSignsChange",
          [" %d+"] = "GitSignsDelete",
        } do
          for match in string.gmatch(git_text, pattern) do
            local s = string.find(line, match, 1, true)
            if s then
              vim.api.nvim_buf_set_extmark(buf, ns, line_idx, s - 1, {
                end_col = s - 1 + #match,
                hl_group = hl,
              })
            end
          end
        end
      else
        local git_start = string.find(line, git_text, 1, true)
        if git_start then
          vim.api.nvim_buf_set_extmark(buf, ns, line_idx, git_start - 1, {
            end_col = git_start - 1 + #git_text,
            hl_group = "WaterGitStatus",
          })
        end
      end
    end
  end
  water_bufnr = buf

  local maps = M.options.keymaps
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    maps.open,
    [[:lua require('water').open_selected_buffer()<CR>]],
    { nowait = true, noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    maps.delete,
    [[:lua require('water').delete_selected_buffer()<CR>]],
    { nowait = true, noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    maps.split,
    [[:lua require('water').open_selected_buffer_split()<CR>]],
    { nowait = true, noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    maps.vsplit,
    [[:lua require('water').open_selected_buffer_vsplit()<CR>]],
    { nowait = true, noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    maps.refresh,
    [[:lua require('water').refresh_water()<CR>]],
    { nowait = true, noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(buf, "n", maps.toggle, "<cmd>Water<CR>", { nowait = true, noremap = true, silent = true })
end

function M.open_selected_buffer()
  local line = vim.fn.line "."
  local bufnr = vim.b.water_map[line]
  if bufnr then
    vim.api.nvim_set_current_buf(bufnr)
  end
end

function M.open_selected_buffer_split()
  local line = vim.fn.line "."
  local bufnr = vim.b.water_map[line]
  if bufnr then
    vim.cmd "split"
    vim.api.nvim_set_current_buf(bufnr)
  end
end

function M.open_selected_buffer_vsplit()
  local line = vim.fn.line "."
  local bufnr = vim.b.water_map[line]
  if bufnr then
    vim.cmd "vsplit"
    vim.api.nvim_set_current_buf(bufnr)
  end
end

function M.delete_selected_buffer()
  local line = vim.fn.line "."
  local bufnr = vim.b.water_map[line]
  if bufnr then
    vim.api.nvim_buf_delete(bufnr, { force = true })
    M.refresh_water()
  end
end

function M.refresh_water()
  M.open_water()
end

function M.close_water()
  if last_buf and vim.api.nvim_buf_is_valid(last_buf) then
    vim.api.nvim_set_current_buf(last_buf)
  end
end

function M.toggle_water()
  local current = vim.api.nvim_get_current_buf()
  if water_bufnr and vim.api.nvim_buf_is_valid(water_bufnr) and current == water_bufnr then
    M.close_water()
  else
    M.open_water()
  end
end

function M.open_water()
  open_water()
end

M.setup()

return M
