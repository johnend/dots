return {
  -------------------------------------
  --- LSP
  -------------------------------------
  { "<leader>l", group = "LSP", icon = icons.ui.Code },
  {
    "<leader>lc",
    ":TSC<cr>",
    desc = "Check TypeScript types",
  },
  { "<leader>li", ":LspInfo<cr>", desc = "LSP info" },
  { "<leader>ll", ":Trouble loclist toggle<cr>", desc = "Location list (Trouble)" },
  { "<leader>lq", ":Trouble qflist toggle<cr>", desc = "Quickfix list (Trouble)" },
  { "<leader>lv", ":Trouble lsp toggle focus=false<cr>", desc = "LSP toggle (Trouble)" },
  { "<leader>lR", ":LspRestart<cr>", desc = "Restart LSP Server" },
  -------------------------------------
  --- Diagnostics
  -------------------------------------
  { "<leader>ld", group = "Diagnostics" },
  { "<leader>ldX", ":Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
  { "<leader>ldx", ":Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
  -------------------------------------
  --- Quickfix
  -------------------------------------
  { "<leader>a", group = "Append to:", icon = icons.ui.List },
  {
    "<leader>aq",
    function()
      local entry = {
        filename = vim.fn.expand "%:p",
        lnum = vim.fn.line ".",
        col = vim.fn.col ".",
        text = vim.fn.getline ".",
      }

      vim.fn.setqflist({ entry }, "a")
      print("Added to quickfix list: " .. entry.text)
    end,
    desc = "Qflist",
    icon = icons.ui.List,
  },
  {
    "<leader>al",
    function()
      local entry = {
        filename = vim.fn.expand "%:p",
        lnum = vim.fn.line ".",
        col = vim.fn.col ".",
        text = vim.fn.getline ".",
      }

      vim.fn.setloclist(0, { entry }, "a")
      print("Added to location list: " .. entry.text)
    end,
    desc = "Loclist",
    icon = icons.ui.List,
  },
  {
    "K",
    function()
      vim.lsp.buf.hover()
    end,
    desc = "Hover Documentation",
  },
}
