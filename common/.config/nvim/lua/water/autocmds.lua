-- lua/water/autocmds.lua
---@class water.autocmds

local M = {}
---@type number Water autocommand group ID
local aug = vim.api.nvim_create_augroup("Water", { clear = true })

---Set up Water-specific autocommands to manage buffer behavior and rendering.
function M.setup()
  -- Clear any existing Water autocommands in this group
  vim.api.nvim_clear_autocmds { group = aug }

  -- 1) When the Water filetype is detected, disable wrapping and lock cursor below header
  vim.api.nvim_create_autocmd("FileType", {
    group = aug,
    pattern = "water",
    callback = function()
      -- Disable wrap for this window
      vim.api.nvim_set_option_value("wrap", false, { scope = "local", win = 0 })

      -- Prevent cursor from landing on header lines (first two lines)
      local HEADER_SIZE = 2
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = aug,
        buffer = 0, -- only affect this buffer
        callback = function()
          local row = vim.api.nvim_win_get_cursor(0)[1]
          if row <= HEADER_SIZE then
            -- Move cursor to first data line
            vim.api.nvim_win_set_cursor(0, { HEADER_SIZE + 1, 0 })
          end
        end,
      })
    end,
  })

  -- 2) Re-render Water buffer on layout changes or when entering its window
  vim.api.nvim_create_autocmd({ "WinResized", "WinEnter", "BufWinEnter" }, {
    group = aug,
    callback = function()
      local st = require "water.state"
      local bufnr = st.water_bufnr
      local opts = st.options

      -- Only proceed if Water has been opened and buffer is valid
      if not bufnr or not opts or not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      -- Re-render if current buffer is the Water buffer
      if vim.api.nvim_get_current_buf() == bufnr then
        require("water.ui.water").render(bufnr, opts)
      end
    end,
  })

  -- 3) Refresh Water view on buffer or diagnostic changes
  vim.api.nvim_create_autocmd({
    "BufAdd",
    "BufCreate",
    "DiagnosticChanged",
    "BufWritePost",
    "BufReadPost",
  }, {
    group = aug,
    callback = function()
      local bufnr = require("water.state").water_bufnr
      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      -- If Water buffer is visible, schedule a refresh
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == bufnr then
          vim.defer_fn(function()
            require("water.ui.water").refresh()
          end, 20)
          break
        end
      end
    end,
  })

  -- 4) On buffer wipeout, clear Water state if it's the Water buffer
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = aug,
    pattern = "*",
    callback = function(e)
      if vim.bo[e.buf].filetype == "water" then
        local st = require "water.state"
        st.water_bufnr = nil
        st.water_winid = nil
      end
    end,
  })
end

return M
