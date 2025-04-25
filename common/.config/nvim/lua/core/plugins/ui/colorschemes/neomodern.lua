return {
  "cdmill/neomodern.nvim",
  lazy = false,
  priority = 1000,
  name = "neomodern",
  config = function()
    local status_ok, neomodern = pcall(require, "neomodern")
    if not status_ok then
      return
    end

    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
    end

    neomodern.setup {
      plain_float = true,
    }
  end,
}
