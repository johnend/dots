return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  config = function()
    local status_ok, catppuccin = pcall(require, "catppuccin")
    if not status_ok then
      return
    end

    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
    end

    catppuccin.setup {
      flavour = "mocha",
      transparent_background = true,
      styles = { -- Handles the styles of general hi groups (see: :h highlight-args):
      },
    }
  end,
}
