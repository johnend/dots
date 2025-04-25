return {
  "rose-pine/neovim",
  lazy = false,
  priority = 1000,
  name = "rose-pine",
  config = function()
    local status_ok, rose_pine = pcall(require, "rose-pine")
    if not status_ok then
      return
    end

    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
    end

    rose_pine.setup {
      variant = "main",
      styles = {
        transparency = true,
      },
    }
  end,
}
