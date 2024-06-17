return {
  "folke/trouble.nvim",
  event = "VeryLazy",
  config = function()
    local status_ok, trouble = pcall(require, "trouble")
    if not status_ok then
      return
    end
    trouble.setup {
      win = {
        position = "right",
        size = { width = 0.3 },
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

    vim.keymap.set("n", "<leader>cx", ":Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })
    vim.keymap.set(
      "n",
      "<leader>cX",
      ":Trouble diagnostics toggle filter.buf=0<CR>",
      { desc = "Buffer diagnostics (Trouble)" }
    )
    vim.keymap.set("n", "<leader>cL", ":Trouble loclist toggle<CR>", { desc = "Location list (Trouble)" })
    vim.keymap.set("n", "<leader>cQ", ":Trouble qflist toggle<CR>", { desc = "Quickfix list (Trouble)" })
  end,
}
