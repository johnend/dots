return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    -- NOTE: The log_level is in `opts.opts`
    opts = {
      log_level = "DEBUG", -- or "TRACE"
    },
  },

  config = function()
    local status_ok, codecompanion = pcall(require, "codecompanion")
    if not status_ok then
      return
    end

    codecompanion.setup {
      display = {
        action_palette = {
          provider = "telescope",
        },
      },
      strategies = {
        chat = {
          name = "copilot",
          model = "gpt-4.1",
        },
      },
    }
  end,
}
