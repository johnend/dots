return {
  { "<leader>d", group = "Diagnostics" },
  {
    "<leader>de",
    function()
      vim.diagnostic.open_float()
    end,
    desc = "Diagnostic error messages",
  },
  {
    "<leader>dq",
    function()
      vim.diagnostic.setloclist()
    end,
    desc = "Diagnostic quickfix list",
  },
  {
    "<leader>df",
    function()
      vim.diagnostic.open_float(nil, { focus = false })
    end,
    desc = "Show diagnostic popup",
  },
  {
    "<leader>dn",
    function()
      vim.diagnostic.jump { count = 1 }
    end,
    desc = "Next diagnostic",
  },
  {
    "<leader>dp",
    function()
      vim.diagnostic.jump { count = -1 }
    end,
    desc = "Previous diagnostic",
  },
}
