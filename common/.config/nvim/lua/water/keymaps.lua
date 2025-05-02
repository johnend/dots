-- lua/water/keymaps.lua
local M = {}

function M.apply(bufnr, buffer_map, opts, reopen_cb)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  local function map(lhs, fn)
    if type(lhs) == "string" and lhs ~= "" then
      vim.keymap.set("n", lhs, fn, { buffer = bufnr, nowait = true, noremap = true, silent = true })
    end
  end

  local keymaps = opts.keymaps or {}

  map(keymaps.open_buffer, function()
    local line = vim.fn.line "."
    local target = buffer_map[line]
    if target then
      vim.api.nvim_set_current_buf(target)
    end
  end)

  map(keymaps.delete, function()
    local line = vim.fn.line "."
    local target = buffer_map[line]
    if target then
      local listed = vim.fn.getbufinfo { buflisted = 1 }
      if #listed <= 1 then
        local fallback = opts.delete_last_buf_fallback or "q"
        if type(fallback) == "function" then
          fallback()
        elseif fallback == "enew" then
          vim.cmd "enew"
        elseif fallback == "q" then
          -- if there are unsaved changes in the current buffer, confirm first
          local bufnr = vim.api.nvim_get_current_buf()
          if vim.bo[bufnr].modified then
            -- 1 = Yes, 2 = No
            local choice = vim.fn.confirm("You have unsaved changes—quit anyway?", "&Yes\n&No", 2)
            if choice == 1 then
              vim.cmd "qa"
            end
          else
            vim.cmd "qa"
          end
          vim.notify("[Water] Invalid delete_last_buf_fallback option: " .. tostring(fallback), vim.log.levels.WARN)
        end
      else
        pcall(vim.api.nvim_buf_delete, target, { force = true })
        reopen_cb()
      end
    end
  end)

  map(keymaps.split, function()
    local line = vim.fn.line "."
    local target = buffer_map[line]
    if target then
      vim.cmd "split"
      vim.api.nvim_set_current_buf(target)
    end
  end)

  map(keymaps.vsplit, function()
    local line = vim.fn.line "."
    local target = buffer_map[line]
    if target then
      vim.cmd "vsplit"
      vim.api.nvim_set_current_buf(target)
    end
  end)

  map(keymaps.refresh, function()
    require("water.ui.water").refresh()
  end)

  map(keymaps.help, function()
    require("water.ui.help").open_help_window()
  end)
end

return M
