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

  config = function()
    -- Load configuration from modular files
    local config = require("config.codecompanion")

    -- Setup CodeCompanion with config
    require("codecompanion").setup(config)

    -- Note: Agent switching is now handled via prompt library
    -- No additional setup needed - agents are available via :CodeCompanion <AgentName>
  end,
}
