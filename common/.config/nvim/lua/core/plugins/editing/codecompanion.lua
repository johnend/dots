return {
  "olimorris/codecompanion.nvim",
  cmd = {
    "CodeCompanion",
    "CodeCompanionActions",
    "CodeCompanionChat",
    "CodeCompanionChat Toggle",
    "CodeCompanionCmd",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    system_prompt = require "core.config.codecompanion.system_prompt",
    tools_prompt = require "core.config.codecompanion.tools_prompt",
    display = {
      action_palette = {
        provider = "telescope",
      },
      chat = {
        -- Disable CodeCompanion's built-in formatting to allow markview to handle it
        show_header_separator = false, -- This is the key setting!
        show_references = false,
        show_settings = false,
        show_token_count = false,
      },
    },
    interactions = {
      chat = {
        name = "copilot",
        model = "claude-sonnet-4.5",
      },
    },
    -- NOTE: The log_level is in `opts.opts`
    opts = {
      log_level = "DEBUG", -- or "TRACE"
      send_code = true,
      use_default_actions = true,
      use_default_prompt_library = true,
    },
  },

  config = function(_, opts)
    local status_ok, codecompanion = pcall(require, "codecompanion")
    if not status_ok then
      return
    end

    codecompanion.setup(opts)
  end,
}
