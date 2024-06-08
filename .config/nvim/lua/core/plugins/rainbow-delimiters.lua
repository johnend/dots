return {
  "HiPhish/rainbow-delimiters.nvim",
  event = {"BufReadPre", "BufNewFile"},
  config = function()
    local status_ok, rainbow = pcall(require, "rainbow-delimiters.setup")
    if not status_ok then
      return
    end
    rainbow.setup {
      ignore_filetypes = { "markdown", "help", "neogitstatus", "alpha", "TelescopePrompt", "TelescopeResults", "lspinfo", "NeoTree" },
    }
  end,
}
