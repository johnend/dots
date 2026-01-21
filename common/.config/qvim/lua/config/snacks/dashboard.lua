local header = require("config.dashboard.headers").grim_repo

local M = {
  enabled = true,
  preset = {
    keys = {
      {
        icon = Icons.ui.FindFile,
        key = "f",
        desc = "Find file",
        action = ":lua Snacks.dashboard.pick('files')",
      },
      {
        icon = Icons.ui.NewFile,
        key = "n",
        desc = "New file",
        action = ":ene | startinsert",
      },
      {
        icon = Icons.ui.FindText,
        key = "g",
        desc = "Find text",
        action = ":lua Snacks.dashboard.pick('live_grep')",
      },
      {
        icon = Icons.kind.File,
        key = "r",
        desc = "Recent files",
        action = ":lua Snacks.dashboard.pick('oldfiles')",
      },
      {
        icon = Icons.ui.Gear,
        key = "c",
        desc = "Config",
        action = ":lua Snacks.dashboard.pick('files',{cwd = vim.fn.stdpath('config')})",
      },
      {
        icon = Icons.misc.Lazy,
        key = "l",
        desc = "Lazy",
        action = ":Lazy",
        enabled = package.loaded.lazy ~= nil,
      },
      {
        icon = Icons.misc.Mason,
        key = "m",
        desc = "Mason",
        action = ":Mason",
      },
      {
        icon = Icons.ui.SignOut,
        key = "q",
        desc = "Quit",
        action = ":qa",
      },
    },
    header = header,
  },
}

return M
