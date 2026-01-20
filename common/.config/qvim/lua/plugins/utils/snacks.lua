local header = require("config.dashboard.headers").grim_repo

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -----------------
    --- Animate -----
    -----------------
    animate = {
      enabled = true,
      duration = 3,
      easing = "inOutQuad",
      fps = 120,
    },
    -----------------
    --- Big file ----
    -----------------
    bigfile = { enabled = true },
    -----------------
    --- Dashboard ---
    -----------------
    dashboard = {
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
    },
    -----------
    --- Dim ---
    -----------
    dim = {
      enabled = true,
      animate = {
        duration = {
          step = 7,
          total = 210,
        },
      },
    },
    ----------------
    --- Explorer ---
    ----------------
    explorer = {
      enabled = true,
      hidden = true,
    },
    --------------
    --- Indent ---
    --------------
    indent = {
      enabled = true,
      only_scope = true,
      only_current = true,
    },
    -------------
    --- Input ---
    -------------
    input = {
      enabled = true,
    },
    -------------
    --- Image ---
    -------------
    image = {
      enabled = true,
      doc = {
        float = true,
        inline = false,
        max_width = 80,
        max_height = 40,
      },
    },
    -----------------
    --- Lazygit -----
    -----------------
    lazygit = {
      enabled = true,
    },
    --------------
    --- Picker ---
    --------------
    picker = { enabled = true, sources = { explorer = { hidden = true } } },
    ----------------
    --- Notifier ---
    ----------------
    notifier = {
      enabled = true,
      timeout = 2000,
      style = "minimal",
      top_down = false,
    },
    ------------------
    --- Quick file ---
    ------------------
    quickfile = { enabled = true },
    -------------
    --- Scope ---
    -------------
    scope = { enabled = true },
    --------------
    --- Scroll ---
    --------------
    scroll = { enabled = true },
    ---------------------
    --- Status column ---
    ---------------------
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" },
      right = { "fold", "git" },
      folds = {
        open = true,
        git_hl = false,
      },
      git = {
        patterns = { "GitSign", "MiniDiffSign" },
      },
    },
    -------------
    --- Words ---
    -------------
    words = { enabled = true },
    -----------
    --- Zen ---
    -----------
    zen = {
      enabled = true,
    },
  },
  --------------------
  ------ Styles ------
  --------------------
  styles = {
    input = {
      backdrop = false,
      position = "float",
      border = true,
      title_pos = "left",
      height = 1,
      width = 60,
      relative = "editor",
      noautocmd = true,
      row = 13,
      -- relative = "cursor",
      -- row = -3,
      -- col = 0,
      wo = {
        winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
        cursorline = false,
      },
      bo = {
        filetype = "snacks_input",
        buftype = "prompt",
      },
      --- buffer local variables
      b = {
        completion = false, -- disable blink completions in input
      },
      keys = {
        n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
        i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
        i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = { "i", "n" }, expr = true },
        i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i", expr = true },
        i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
        i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
        i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
        q = "cancel",
      },
    },
  },
  zen = {
    backdrop = { transparent = false, blend = 21 },
  },
}
