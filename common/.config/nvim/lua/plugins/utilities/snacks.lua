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
    vim.cmd "highlight link SnacksIndent WinBarNC"

    snacks.setup {
      -- Enabled
      animate = {
        duration = 7,
        easing = "inOutQuad",
        fps = 120,
      },
      styles = {
        zen = {
          backdrop = { transparent = true, blend = 21 },
        },
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
      image = {
        enabled = false,
        doc = { float = true, inline = false, max_width = 80, max_height = 40 },
        convert = { notify = false },
      },
      notifier = {
        enabled = true,
        timeout = 2000,
        style = "minimal",
        top_down = false,
      },
      quickfile = { enabled = true },
      statuscolumn = {
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
          open = true, -- show open fold icons
          git_hl = false, -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
      },
      zen = { enable = true },
      -- Disabled
      dashboard = { enabled = false }, -- could replace alpha, but not sure if I care enough to be honest
      debug = { enabled = false },
      explorer = { enabled = false }, -- could replace neo-tree looks nice tbh
      git = { enabled = false },
      indent = {
        enabled = true,
        only_scope = true,
        only_current = true,
        animate = {
          style = "out",
          easing = "inOutQuad",
          duration = {
            step = 20,
            total = 300,
          },
        },
      }, -- replaces indent line

      layout = { enabled = false },
      lazygit = { enabled = false },
      picker = { enabled = false }, -- actually really like this ui, replaces telescope
      profiler = { enabled = false }, -- not sure if this even works, maybe? useful
      rename = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      terminal = { enabled = false },
      toggle = { enabled = false },
    }
  end,
}
