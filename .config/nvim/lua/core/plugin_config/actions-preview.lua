local hl = require "actions-preview.highlight"

require("actions-preview").setup {
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
