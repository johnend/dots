return {
  -------------------------------------
  --- LSP
  -------------------------------------
  { "gr", group = "LSP go to", icon = Icons.ui.Code },
  { "<leader>l", group = "LSP", icon = Icons.ui.Code },
  { "<leader>li", ":LspInfo<cr>", desc = "LSP info" },
  { "<leader>ll", ":Trouble loclist toggle<cr>", desc = "Location list" },
  { "<leader>lq", ":Trouble qflist toggle<cr>", desc = "Quickfix list" },
  { "<leader>lv", ":Trouble lsp toggle focus=false<cr>", desc = "LSP toggle" },
  -- TODO: need to create a picker that passes LSP name to LspRestart
  -- { "<leader>lr", ":LspRestart<cr>", desc = "Restart LSP Server" },
  {
    "<leader>ls",
    ":Trouble symbols<cr>",
    desc = "Document Symbols",
  },
  -------------------------------------
  --- Diagnostics
  -------------------------------------
  { "<leader>ld", group = "Diagnostics" },
  { "<leader>ldX", ":Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
  { "<leader>ldx", ":Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
  -------------------------------------
  --- Quickfix
  -------------------------------------
  {
    "<leader>lQ",
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
    desc = "Add to qflist",
    icon = Icons.ui.List,
  },
  {
    "<leader>lL",
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
    desc = "Add to loclist",
    icon = Icons.ui.List,
  },
  {
    "K",
    function()
      vim.lsp.buf.hover()
    end,
    desc = "Hover Documentation",
  },
}
