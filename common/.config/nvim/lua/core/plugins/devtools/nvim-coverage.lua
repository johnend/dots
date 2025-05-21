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
        covered = { fg = colors.green },
        uncovered = { fg = colors.red },
      },
      -- signs = {
      --   covered = { text = icons.ui.TestCovered },
      --   uncovered = { text = icons.ui.TestUncovered },
      -- },
    }
  end,
}
