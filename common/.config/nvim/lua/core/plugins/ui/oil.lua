return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    local status_ok, oil = pcall(require, "oil")
    if not status_ok then
      return
    end

    oil.setup {
      view_options = {
        show_hidden = true,
      },
    }

    vim.keymap.set("n", "-", function()
      local util = require "oil.util"
      oil.open()
      util.run_after_load(0, function()
        oil.open_preview()
      end)
    end, { desc = "Oil" })
  end,
}
