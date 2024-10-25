return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {},
  config = function()
    local status_ok, ts_tools = pcall(require, "typescript-tools")
    if not status_ok then
      return
    end

    ts_tools.setup {
      settings = {
        tsserver_plugins = {
          "@styled/typescript-styled-plugin",
        },
      },
    }
  end,
}
