return {
  { "<leader>g", group = "Git" },
  {
    "<leader>gg",
    "<cmd>lua require 'core.plugins.devtools.toggleterm'.lazygit_toggle()<cr>",
    desc = "LazyGit",
    icon = icons.git.Octoface,
  },
  { "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", desc = "Git blame" },
  { "<leader>gd", group = "Diff view" },
  { "<leader>gdo", ":DiffviewOpen<cr>", desc = "Open diffview" },
  { "<leader>gdc", ":DiffviewClose<cr>", desc = "Close diffview" },
  { "<leader>gdr", ":DiffviewRefresh<cr>", desc = "Refresh diffview" },
}
