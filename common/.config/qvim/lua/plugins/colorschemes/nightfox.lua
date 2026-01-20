return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  name = "nightfox",
  config = function()
    local status_ok, nightfox = pcall(require, "nightfox")
    if not status_ok then
      return
    end

    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
    end
  end,
}
