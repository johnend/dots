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
      -- 'wrap' is a window-local option, so target win=0 (the window where
      -- this autocmd fired)
      vim.api.nvim_set_option_value("wrap", false, { scope = "local", win = 0 })
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
end

return M
