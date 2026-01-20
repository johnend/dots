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
      diff = { ignore_whitespace = true },
    }
  end,
}
