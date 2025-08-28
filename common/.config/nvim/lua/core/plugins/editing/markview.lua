return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- Recommended
  opts = {
    preview = {
      filetypes = { "markdown", "codecompanion" }, -- If you decide to lazy-load anyway
      ignore_buftypes = {},
    },
  },

  dependencies = {
    -- You will not need this if you installed the
    -- parsers manually
    -- Or if the parsers are in your $RUNTIMEPATH
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local status_ok, markview = pcall(require, "markview")
    if not status_ok then
      return
    end

    markview.setup {}
  end,
}
