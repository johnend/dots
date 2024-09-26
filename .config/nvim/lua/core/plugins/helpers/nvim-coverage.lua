return {
  "andythigpen/nvim-coverage",
  event = "BufRead",
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    local status_ok, coverage = pcall(require, "coverage")
    if not status_ok then
      return
    end
    coverage.setup {
      auto_reload = true,
      commands = true,
      highlights = {
        covered = { fg = colors.crust, bg = colors.green },
        uncovered = { fg = colors.crust, bg = colors.red },
      },
      signs = {
        covered = { text = icons.ui.TestCovered },
        uncovered = { text = icons.ui.TestUncovered },
      },
    }

    vim.keymap.set("n", "<leader>tc", "<cmd>CoverageToggle<cr>", { desc = "Test Coverage" })
  end,
}
