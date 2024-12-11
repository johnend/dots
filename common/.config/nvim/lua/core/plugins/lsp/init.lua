return {
  "neovim/nvim-lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  dependencies = {
    { "folke/lazydev.nvim", ft = "lua", opts = {} },
    { "Bilal2453/luvit-meta", lazy = true },
    { "nvimtools/none-ls.nvim" },
    { "b0o/schemastore.nvim" },
  },
  config = function()
    local status_ok, _ = pcall(require, "lspconfig")
    if not status_ok then
      return
    end
    require("core.plugins.lsp.configs.lsp").config()
    require("lspconfig.ui.windows").default_options.border = "rounded"

    vim.diagnostic.config {
      -- virtual_text = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
          [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
          [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
          [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
        },
      },
      underline = true,
      float = {
        header = "",
        border = "rounded",
        max_width = 160,
      },
      virtual_text = false,
    }
    vim.keymap.set(
      "n",
      "<leader>df",
      ":lua vim.diagnostic.open_float(nil, {focus=false})<CR>",
      { desc = "Show diagnostic popup" }
    )
  end,
  lazy = true,
}
