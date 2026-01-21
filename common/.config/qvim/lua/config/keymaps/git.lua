return {
  { "<leader>g", group = "Git" },
  {
    "<leader>gg",
    ":lua Snacks.lazygit() <cr>",
    desc = "LazyGit",
    icon = Icons.git.Octoface,
  },
  {
    "<leader>gh",
    ":lua Snacks.terminal('gh dash')<cr>",
    desc = "gh Dash",
    icon = Icons.git.Octoface,
  },
  { "<leader>gb", ":Gitsigns blame_line<CR>", desc = "Git blame line" },
  { "<leader>gB", ":Gitsigns blame<CR>", desc = "Git blame sidebar" },
  { "<leader>gd", group = "DiffView" },
  { "<leader>gdo", ":DiffviewOpen<cr>", desc = "Open" },
  { "<leader>gdc", ":DiffviewClose<cr>", desc = "Close" },
  { "<leader>gdr", ":DiffviewRefresh<cr>", desc = "Refresh" },
  { "<leader>gx", ":lua Snacks.gitbrowse()<cr>", desc = "Open repo in browser" },

  -- Octo (GitHub) - Global launchers
  { "<leader>go", group = "Octo (GitHub)", icon = Icons.git.Octoface },

  -- Octo buffer-local groups (using localleader = ,)
  { ",a", group = "Assignees", icon = Icons.ui.SignIn },
  { ",c", group = "Comments", icon = Icons.ui.Comment },
  { ",d", group = "Discussion", icon = Icons.ui.Comment },
  { ",g", group = "Goto", icon = Icons.ui.Forward },
  { ",i", group = "Issues", icon = Icons.ui.Bug },
  { ",l", group = "Labels", icon = Icons.ui.Tag },
  { ",n", group = "Notifications", icon = Icons.ui.Note },
  { ",p", group = "Pull Requests", icon = Icons.git.Diff },
  { ",r", group = "Reactions/Resolve", icon = Icons.misc.Smiley },
  { ",s", group = "Suggestions", icon = Icons.ui.Lightbulb },
  { ",v", group = "Review", icon = Icons.ui.Search },
}
