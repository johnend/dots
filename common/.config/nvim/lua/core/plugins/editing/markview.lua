return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- Recommended
  opts = {
    preview = {
      filetypes = { "markdown", "codecompanion" }, -- If you decide to lazy-load anyway
      ignore_buftypes = {},
    },
    experimental = { check_rtp_message = false },
  },

  dependencies = {
    -- You will not need this if you installed the
    -- parsers manually
    -- Or if the parsers are in your $RUNTIMEPATH
    "nvim-tree/nvim-web-devicons",
  },
}
