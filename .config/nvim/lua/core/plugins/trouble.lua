local trouble = require "trouble"

trouble.setup {
  win = {
    position = "right",
    size = { width = 0.2 },
  },
  modes = {
    preview_float = {
      mode = "diagnostics",
      preview = {
        type = "float",
        relative = "editor",
        border = "rounded",
        title = "Preview",
        title_pos = "center",
        position = { 0, -2 },
        size = { width = 0.3, height = 0.3 },
        zindex = 200,
      },
    },
  },
}

vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", ":Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xL", ":Trouble loclist toggle<CR>", { desc = "Location list (Trouble)" })
vim.keymap.set("n", "<leader>xQ", ":Trouble qflist toggle<CR>", { desc = "Quickfix list (Trouble)" })
