return {
  { "<leader>g", group = "Git" },
  {
    "<leader>gg",
    "<cmd>lua require 'core.plugins.devtools.toggleterm'.lazygit_toggle()<cr>",
    desc = "LazyGit",
    icon = icons.git.Octoface,
  },
  {
    "<leader>gh",
    "<cmd>lua require 'core.plugins.devtools.toggleterm'.gh_dash_toggle()<cr>",
    desc = "gh Dash",
    icon = icons.git.Octoface,
  },
  { "<leader>gb", ":Gitsigns blame_line<CR>", desc = "Git blame line" },
  { "<leader>gB", ":Gitsigns blame<CR>", desc = "Git blame sidebar" },
  { "<leader>gd", group = "Diff view" },
  { "<leader>gdo", ":DiffviewOpen<cr>", desc = "Open diffview" },
  { "<leader>gdc", ":DiffviewClose<cr>", desc = "Close diffview" },
  { "<leader>gdr", ":DiffviewRefresh<cr>", desc = "Refresh diffview" },
  { "<leader>gx", ":lua Snacks.gitbrowse()<cr>", desc = "Open GitRepo" },

  -- Octo (GitHub) - Global launchers
  { "<leader>go", group = "Octo (GitHub)", icon = icons.git.Octoface },

  -- Octo buffer-local groups (using localleader = ,)
  { ",a", group = "Assignees", icon = icons.ui.SignIn },
  { ",c", group = "Comments", icon = icons.ui.Comment },
  { ",d", group = "Discussion", icon = icons.ui.Comment },
  { ",g", group = "Goto", icon = icons.ui.Forward },
  { ",i", group = "Issues", icon = icons.ui.Bug },
  { ",l", group = "Labels", icon = icons.ui.Tag },
  { ",n", group = "Notifications", icon = icons.ui.Note },
  { ",p", group = "Pull Requests", icon = icons.git.Diff },
  { ",r", group = "Reactions/Resolve", icon = icons.misc.Smiley },
  { ",s", group = "Suggestions", icon = icons.ui.Lightbulb },
  { ",v", group = "Review", icon = icons.ui.Search },
}
