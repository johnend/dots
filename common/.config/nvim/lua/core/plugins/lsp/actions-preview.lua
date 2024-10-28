return {
  "aznhe21/actions-preview.nvim",
  event = { "BufRead", "BufNewFile" },
  config = function()
    local status_ok, ap = pcall(require, "actions-preview")
    if not status_ok then
      return
    end

    local hl = require "actions-preview.highlight"

    ap.setup {
      highlight_command = {
        hl.delta "delta --side-by-side",
      },
      diff = {
        ignore_whitespace = true,
      },
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.8,
          height = 0.7,
          preview_cutoff = 20,
        },
      },
    }
  end,
}
