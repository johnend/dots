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
  path_display = "short_path",
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

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options or {}, opts or {})

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
      table.insert(buffers, {
        bufnr = buf,
        name = formatted_name,
        modified = modified,
        readonly = readonly,
        diagnostics = diagnostics,
        last_used = last_used,
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
  local mods = ""
  if M.options.use_nerd_icons then
    if buf.modified then
      mods = mods .. " "
    end
    if buf.readonly then
      mods = mods .. " "
    end
  else
    if M.options.show_modified and buf.modified then
      mods = mods .. " [+]"
    end
    if M.options.show_readonly and buf.readonly then
      mods = mods .. " [RO]"
    end
  end
  if M.options.show_diagnostics and buf.diagnostics then
    local error_count = buf.diagnostics[vim.diagnostic.severity.ERROR] or 0
    local warn_count = buf.diagnostics[vim.diagnostic.severity.WARN] or 0
    if error_count > 0 then
      mods = mods .. (error_count > 1 and string.format("  %d", error_count) or " ")
    elseif warn_count > 0 then
      mods = mods .. (warn_count > 1 and string.format("  %d", warn_count) or " ")
    end
  end
  return string.format("%d: %s%s", buf.bufnr, buf.name, mods)
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

  water_bufnr = buf

  local maps = M.options.keymaps
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    maps.open,
    ":lua require('water').open_selected_buffer()<CR>",
    { nowait = true, noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    maps.delete,
    ":lua require('water').delete_selected_buffer()<CR>",
    { nowait = true, noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    maps.split,
    ":lua require('water').open_selected_buffer_split()<CR>",
    { nowait = true, noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    maps.vsplit,
    ":lua require('water').open_selected_buffer_vsplit()<CR>",
    { nowait = true, noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    maps.refresh,
    ":lua require('water').refresh_water()<CR>",
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
