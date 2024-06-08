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
  end,
  lazy = true,
}
