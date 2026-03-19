local is_neovide = vim.g.neovide or false

return {
  {
    "Rics-Dev/project-explorer.nvim",
    enabled = is_neovide,
  },
}
