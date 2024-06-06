local precognition = require "precognition"

precognition.setup {
  highlightColor = {
    link = "Comment",
  },
}

vim.keymap.set("n", "<leader>tp", ":lua require('precognition').toggle()<CR>", { desc = "Toggle precognition" })
