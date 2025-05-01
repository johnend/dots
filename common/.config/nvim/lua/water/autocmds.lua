-- lua/water/autocmds.lua
local M = {}
local aug = vim.api.nvim_create_augroup("Water", { clear = true })

function M.setup()
  -- clear out any old Water autocommands
  vim.api.nvim_clear_autocmds { group = aug }

  -- 1) disable wrapping in the exact window that just got filetype=water
  vim.api.nvim_create_autocmd("FileType", {
    group = aug,
    pattern = "water",
    callback = function()
      -- disable wrap
      vim.api.nvim_set_option_value("wrap", false, { scope = "local", win = 0 })

      -- prevent cursor landing on header (first two lines)
      local HEADER_SIZE = 2
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = aug,
        buffer = 0, -- only in this water buffer
        callback = function()
          local row = vim.api.nvim_win_get_cursor(0)[1]
          if row <= HEADER_SIZE then
            -- jump down to first real data line
            vim.api.nvim_win_set_cursor(0, { HEADER_SIZE + 1, 0 })
          end
        end,
      })
    end,
  })

  -- 2) re-render whenever the layout changes or you jump back into the Water window
  vim.api.nvim_create_autocmd({ "WinResized", "WinEnter", "BufWinEnter" }, {
    group = aug,
    callback = function()
      local st = require "water.state"
      local bufnr = st.water_bufnr
      local opts = st.options

      -- bail out if we haven't yet opened Water (or options got wiped)
      if not bufnr or not opts or not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      -- only re-render when the current window is showing your Water buffer
      if vim.api.nvim_get_current_buf() == bufnr then
        require("water.ui.water").render(bufnr, opts)
      end
    end,
  })

  -- 3) refresh on buffer or diagnostic events if Water is visible
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

  -- in lua/water/autocmds.lua, inside M.setup():
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
