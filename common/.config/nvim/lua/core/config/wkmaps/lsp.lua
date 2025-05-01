return {
  { "<leader>l", group = "LSP" },
  { "<leader>lX", ":Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
  { "<leader>la", ":lua require('actions-preview').code_actions()<cr>", desc = "Code action" },
  { "<leader>ld", ":Telescope lsp_type_definitions<cr>", desc = "Type definition" },
  { "<leader>li", ":LspInfo<cr>", desc = "LSP info" },
  { "<leader>ll", ":Trouble loclist toggle<cr>", desc = "Location list (Trouble)" },
  { "<leader>lv", ":Trouble lsp toggle focus=false<cr>", desc = "LSP toggle (Trouble)" },
  { "<leader>lq", ":Trouble qflist toggle<cr>", desc = "Quickfix list (Trouble)" },
  { "<leader>a", group = "Append to:" },
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
    "<leader>lr",
    function()
      vim.lsp.buf.rename()
    end,
    desc = "Rename",
  },
  { "<leader>ls", ":Trouble symbols toggle focus=true<cr>", desc = "Document symbols" },
  {
    "<leader>lt",
    ":TSC<cr>",
    desc = "Check TypeScript types",
  },
  { "<leader>lw", ":Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
  { "<leader>lx", ":Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
  { "<leader>lR", ":LspRestart<cr>", desc = "Restart LSP Server" },
  {
    "K",
    function()
      vim.lsp.buf.hover()
    end,
    desc = "Hover Documentation",
  },
  {
    "gD",
    function()
      vim.lsp.buf.declaration()
    end,
    desc = "Goto declaration",
  },
  { "gI", ":Telescope lsp_implementations<cr>", desc = "Goto implementation" },
  { "gd", ":Telescope lsp_definitions<cr>", desc = "Goto definition" },
  { "gr", ":Telescope lsp_references<cr>", desc = "Goto references" },
}
