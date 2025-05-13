-- lua/water/keymaps.lua
---@class water.keymaps

local M = {}

---Apply key mappings within the Water buffer for navigation and actions.
---@param bufnr number The Water buffer number where mappings are applied.
---@param buffer_map table<number, number> Mapping from line numbers to buffer numbers.
---@param opts table Configuration options including keymaps and fallback behavior.
---@param reopen_cb fun() Callback to reopen or refresh the Water UI after certain actions.
function M.apply(bufnr, buffer_map, opts, reopen_cb)
  -- Validate buffer before setting keymaps
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  ---Helper to define a normal-mode keymap in the Water buffer
  ---@param lhs string The key sequence to map.
  ---@param fn fun() The function to execute on key press.
  local function map(lhs, fn)
    if type(lhs) == "string" and lhs ~= "" then
      vim.keymap.set("n", lhs, fn, { buffer = bufnr, nowait = true, noremap = true, silent = true })
    end
  end

  -- Use custom keymaps or defaults
  local keymaps = opts.keymaps or {}

  -- Open buffer under cursor
  map(keymaps.open_buffer, function()
    local line = vim.fn.line "."
    local target = buffer_map[line]
    if target then
      vim.api.nvim_set_current_buf(target)
    end
  end)

  -- Delete buffer under cursor with fallback logic
  map(keymaps.delete, function()
    local line = vim.fn.line "."
    local target = buffer_map[line]
    if not target then
      return
    end
    local listed = vim.fn.getbufinfo { buflisted = 1 }
    -- If last buffer, use fallback command
    if #listed <= 1 then
      local fallback = opts.delete_last_buf_fallback or "q"
      if type(fallback) == "function" then
        fallback()
      elseif fallback == "enew" then
        vim.cmd "enew"
      elseif fallback == "q" then
        -- Confirm quitting if unsaved changes
        local cur = vim.api.nvim_get_current_buf()
        if vim.bo[cur].modified then
          local choice = vim.fn.confirm("You have unsaved changes—quit anyway?", "&Yes\n&No", 2)
          if choice == 1 then
            vim.cmd "qa"
          end
        else
          vim.cmd "qa"
        end
      else
        vim.notify("[Water] Invalid delete_last_buf_fallback option: " .. tostring(fallback), vim.log.levels.WARN)
      end
    else
      -- Delete buffer and reopen Water UI
      pcall(vim.api.nvim_buf_delete, target, { force = true })
      reopen_cb()
    end
  end)

  -- Split window and open buffer under cursor
  map(keymaps.split, function()
    local line = vim.fn.line "."
    local target = buffer_map[line]
    if target then
      vim.cmd "split"
      vim.api.nvim_set_current_buf(target)
    end
  end)

  -- Vertical split and open buffer under cursor
  map(keymaps.vsplit, function()
    local line = vim.fn.line "."
    local target = buffer_map[line]
    if target then
      vim.cmd "vsplit"
      vim.api.nvim_set_current_buf(target)
    end
  end)

  -- Refresh the Water UI
  map(keymaps.refresh, function()
    require("water.ui.water").refresh()
  end)

  -- Open help window for Water
  map(keymaps.help, function()
    require("water.ui.help").open_help_window()
  end)

  -- Quit with <Esc> or q
  map("q", function()
    require("water.ui.water").close()
  end)

  map("<Esc>", function()
    require("water.ui.water").close()
  end)
end

return M
