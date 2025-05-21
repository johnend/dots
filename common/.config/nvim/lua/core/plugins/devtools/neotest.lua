return {
  "nvim-neotest/neotest",
  event = "BufRead",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",

    -- Adapters etc.
    "nvim-neotest/neotest-jest",
  },

  config = function()
    local status_ok, neotest = pcall(require, "neotest")

    if not status_ok then
      return
    end

    neotest.setup {

      adapters = {
        -- JEST
        require "neotest-jest" {
          jestCommand = "npm run test --",
          jestConfigFile = "jest.config.ts",
          env = { CI = true },
          cw = function()
            return vim.fn.getcwd()
          end,
        },
      },
    }
  end,
}
