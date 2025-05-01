local config = require "water.config"
local ui = require "water.ui.water"
local highlights = require "water.highlights"
local help = require "water.ui.help"
local state = require "water.state"

local M = {}

local has_setup_run = false

local function lazy_setup()
  if not has_setup_run then
    M.setup {}
  end
end

function M.setup(opts)
  has_setup_run = true
  M.options = config.merge(opts)
  help.setup(M.options)
  highlights.define()

  -- Autocommands
  vim.api.nvim_create_user_command("Water", function()
    ui.toggle(M.options)
  end, { desc = "Toggle Water" })

  vim.api.nvim_create_user_command("WaterRefresh", function()
    require("water.ui.water").render()
  end, { desc = "Refresh Water buffer layout" })

  -- Update the UI and layout (tries to avoid lines wrapping)
  vim.api.nvim_create_autocmd({ "WinResized", "VimResized", "BufWinEnter", "WinEnter", "BufEnter" }, {
    callback = function()
      local bufnr = state.water_bufnr
      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) or not opts then
        return
      end

      local current_win = vim.api.nvim_get_current_win()
      if vim.api.nvim_win_get_buf(current_win) == bufnr then
        vim.defer_fn(function()
          require("water.ui.water").refresh()
        end, 20) -- Small delay allows layout to fully settle
      end
    end,
  })

  -- Update the list when other buffers are created
  vim.api.nvim_create_autocmd({ "BufAdd", "BufCreate", "DiagnosticChanged", "BufWritePost", "BufReadPost" }, {
    callback = function()
      local bufnr = state.water_bufnr
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

  -- Keymaps
  vim.keymap.set("n", M.options.keymaps.toggle, function()
    ui.toggle(M.options)
  end, { desc = "Toggle Water" })

  vim.keymap.set("n", M.options.keymaps.help, function()
    help.open_help_window()
  end, { desc = "Open Water help window" })
end

lazy_setup()

return M
