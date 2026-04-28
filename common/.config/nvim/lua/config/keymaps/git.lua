return {
  { "<leader>g", group = "Git" },
  {
    "<leader>gg",
    "<cmd>lua require 'plugins.devtools.toggleterm'.lazygit_toggle()<cr>",
    desc = "LazyGit",
    icon = Icons.git.Octoface,
  },
  {
    "<leader>gh",
    "<cmd>lua require 'plugins.devtools.toggleterm'.gh_dash_toggle()<cr>",
    desc = "gh Dash",
    icon = Icons.git.Octoface,
  },
  { "<leader>gb", ":Gitsigns blame_line<CR>", desc = "Git blame line" },
  { "<leader>gB", ":Gitsigns blame<CR>", desc = "Git blame sidebar" },
  { "<leader>gd", group = "Diff view" },
  { "<leader>gdo", ":DiffviewOpen<cr>", desc = "Open diffview" },
  { "<leader>gdc", ":DiffviewClose<cr>", desc = "Close diffview" },
  { "<leader>gdr", ":DiffviewRefresh<cr>", desc = "Refresh diffview" },
  {
    "<leader>gdb",
    function()
      local base = nil
      for _, ref in ipairs { "origin/HEAD", "origin/main", "origin/master" } do
        local result = vim.fn.trim(vim.fn.system("git merge-base HEAD " .. ref .. " 2>/dev/null"))
        if result ~= "" and not result:find "fatal" then
          base = result
          break
        end
      end
      if base then
        vim.cmd("DiffviewOpen " .. base)
      else
        vim.notify("Could not find branch base", vim.log.levels.WARN)
      end
    end,
    desc = "Diff branch vs base",
  },
  { "<leader>gx", ":lua Snacks.gitbrowse()<cr>", desc = "Open GitRepo" },

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
