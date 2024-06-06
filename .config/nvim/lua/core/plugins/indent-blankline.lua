local highlight = {
  "RainbowCyan",
  "RainbowViolet",
  "RainbowGreen",
  "RainbowBlue",
  "RainbowRed",
  "RainbowYellow",
  "RainbowOrange",
}

require("ibl").setup {
  indent = { highlight = highlight, char = "" },
  whitespace = { highlight = highlight, remove_blankline_trail = false },
  scope = { enabled = false },
}

vim.keymap.set("n", "<leader>ti", ":IBLToggle<CR>", { desc = "Toggle indent line" })
