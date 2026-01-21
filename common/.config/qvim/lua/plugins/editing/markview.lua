return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  opts = {
    preview = {
      filetypes = { "markdown", "md", "codecompanion" },
      ignore_buftypes = {},
    },
    experimental = {
      check_rtp_message = false,
    },
  },

  config = function(_, opts)
    local status_ok, markview = pcall(require, "markview")
    if not status_ok then
      return
    end

    markview.setup(opts) -- Use the opts instead of empty table
  end,
}
