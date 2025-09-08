return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  priority = 49,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  opts = {
    preview = {
      filetypes = { "markdown", "md", "codecompanion" },
    },
  },

  config = function()
    local status_ok, markview = pcall(require, "markview")
    if not status_ok then
      return
    end

    markview.setup {}
  end,
}
