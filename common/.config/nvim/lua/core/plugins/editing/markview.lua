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
      ignore_buftypes = {},
      condition = function(buffer)
        local ft = vim.bo[buffer].ft
        local bt = vim.bo[buffer].bt

        -- Special handling for codecompanion buffers which have buftype=nofile
        if bt == "nofile" and ft == "codecompanion" then
          return true
        elseif bt == "nofile" then
          return false
        else
          return true
        end
      end,
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
