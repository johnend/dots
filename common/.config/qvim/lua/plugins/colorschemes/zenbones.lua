return {
  "zenbones-theme/zenbones.nvim",
  -- Optionally install Lush. Allows for more configuration or extending the colorscheme
  -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
  -- In Vim, compat mode is turned on as Lush only works in Neovim.
  dependencies = "rktjmp/lush.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- Update to use Comment for dim mode in Snacks rather than DiagnosticUnnecessary
    -- Otherwise the contrast between dimmed text and highlighted text is poor
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*bones",
      callback = function()
        local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
        vim.api.nvim_set_hl(0, "SnacksDim", {
          fg = comment_hl.fg,
          bg = comment_hl.bg,
          italic = false,
        })
      end,
    })
  end,
}
