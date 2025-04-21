return {
  { "<leader>t", group = "Toggle" },
  { "<leader>ta", "<cmd>ASToggle<cr>", desc = "AutoSave" },
  { "<leader>tb", "<cmd>lua require('barbecue.ui').toggle()<cr>", desc = "Barbecue" },
  { "<leader>tc", "<cmd>ColorizerToggle<cr>", desc = "Colorizer" },
  {
    "<leader>tf",
    ":ToggleFormat<cr>",
    desc = "Format on save (buffer)",
  },
  { "<leader>ti", ":IBLToggle<CR>", desc = "Indent line" },
  {
    "<leader>to",
    ":TSContextToggle<cr>",
    desc = "Treesitter context",
  },
  {
    "<leader>tn",
    function()
      vim.wo.relativenumber = not vim.wo.relativenumber
    end,
    desc = "Relative line numbers",
  },
  { "<leader>tp", ":lua require('precognition').toggle()<CR>", desc = "Precognition" },
  {
    "<leader>ts",
    "<cmd>let &scrolloff=999-&scrolloff<CR>",
    desc = "Scrolloff values",
  },
  { "<leader>tt", ":Twilight<CR>", desc = "Twilight" },
  {
    "<leader>tv",
    function()
      local cfg = vim.diagnostic.config().virtual_text
      vim.diagnostic.config { virtual_text = not cfg }
    end,
    desc = "Virtual text (diagnostics)",
  },
  {
    "<leader>th",
    function()
      local buf = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_clients { bufnr = buf }

      for _, client in ipairs(clients) do
        if client.server_capabilities.inlayHintProvider then
          local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = buf }
          vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
          return
        end
      end

      vim.notify("No attached LSP supports inlay hints", vim.log.levels.WARN)
    end,
    desc = "Toggle Inlay Hints",
  },
}
