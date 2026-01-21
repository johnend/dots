local header = require("config.dashboard.headers").grim_repo

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  --@type snacks.Config
  opts = {
    animate = {
      enabled = true,
      duration = 3,
      easing = "inOutQuad",
      fps = 120,
    },
    bigfile = { enabled = true },
    dashboard = require "config.snacks.dashboard",
    dim = {
      enabled = true,
      animate = {
        duration = {
          step = 7,
          total = 210,
        },
      },
    },
    explorer = { enabled = true },
    indent = require "config.snacks.indent",
    input = { enabled = true },
    image = require "config.snacks.image",
    lazygit = require "config.snacks.lazygit",
    picker = require "config.snacks.picker",
    notifier = require "config.snacks.notifier",
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = require "config.snacks.status_column",
    words = { enabled = true },
    zen = { enabled = true },
  },
  styles = require "config.snacks.styles",
}
