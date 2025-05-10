return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Scratch buffer",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "Scratch buffer",
    },
  },

  config = function()
    local status_ok, snacks = pcall(require, "snacks")
    if not status_ok then
      return
    end

    snacks.setup {
      -- Enabled
      animate = {
        duration = 7,
        easing = "inOutQuad",
        fps = 120,
      },
      bigfile = { enabled = true },
      dim = {
        animate = {
          duration = {
            step = 7,
            total = 210,
          },
        },
      }, -- replaces twilight - might as well replace because same author
      input = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      zen = { enabled = true },
      -- Disabled
      dashboard = { enabled = false }, -- could replace alpha, but not sure if I care enough to be honest
      debug = { enabled = false },
      explorer = { enabled = false }, -- could replace neo-tree looks nice tbh
      git = { enabled = false },
      indent = { enabled = false }, -- replaces indent line
      layout = { enabled = false },
      lazygit = { enabled = false },
      picker = { enabled = false }, -- actually really like this ui, replaces telescopes
      profiler = { enabled = false }, -- not sure if this even works, maybe? useful
      rename = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      terminal = { enabled = false },
      toggle = { enabled = false },
    }
  end,
}
