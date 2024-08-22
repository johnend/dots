return {
  "nvim-neotest/neotest",
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
          jestCommand = "yarn jest --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cw = function()
            return vim.fn.getcwd()
          end,
        },
      },
      
      -- stylua: ignore
      keys = {
        {"<leader>T", "", desc = "+Test"},
        { "<leader>Tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
        { "<leader>TT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
        { "<leader>Tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
        { "<leader>Tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
        { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
        { "<leader>To", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
        { "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
        { "<leader>TS", function() require("neotest").run.stop() end, desc = "Stop" },
        { "<leader>Tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
      },
    }
  end,
  
  -- stylua: ignore start
  vim.keymap.set("n", "<leader>T", "", { desc = "+Test" } ),
  vim.keymap.set ("n", "<leader>Tt", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run File" } ),
  vim.keymap.set("n", "<leader>TT", function() require("neotest").run.run(vim.uv.cwd()) end, { desc = "Run All Test Files" } ),
  vim.keymap.set("n", "<leader>Tr", function() require("neotest").run.run() end, { desc = "Run Nearest" } ),
  vim.keymap.set("n", "<leader>Tl", function() require("neotest").run.run_last() end, { desc = "Run Last" } ),
  vim.keymap.set("n", "<leader>Ts", function() require("neotest").summary.toggle() end, { desc = "Toggle Summary" } ),
  vim.keymap.set("n", "<leader>To", function() require("neotest").output.open({ enter = true, auto_close = true }) end, { desc = "Show Output" } ),
  vim.keymap.set("n", "<leader>TO", function() require("neotest").output_panel.toggle() end, { desc = "Toggle Output Panel" } ),
  vim.keymap.set("n", "<leader>TS", function() require("neotest").run.stop() end, { desc = "Stop" } ),
  vim.keymap.set("n", "<leader>Tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, { desc = "Toggle Watch" } ),
  -- stylua: ignore end
}
