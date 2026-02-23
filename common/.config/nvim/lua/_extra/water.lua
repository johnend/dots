return {
  dir = vim.fn.expand("~/Developer/personal/water.nvim"),
  name = "water.nvim",
  dependencies = {
    "lewis6991/gitsigns.nvim", -- Optional: for git status
  },
  config = function()
    require("water").setup({
      -- Default configuration
      show_modified = true,
      show_readonly = true,
      show_diagnostics = true,
      highlight_cursorline = true,
      sort_buffers = "last_modified",
      use_nerd_icons = true,
      path_display = "short_path",
      date_format = "dd/mm",
      time_format = "24h",
      delete_last_buf_fallback = "q",
      icons = {
        git = { added = "", changed = "", removed = "", untracked = "" },
        diagnostics = { err = "", warn = "" },
      },
      keymaps = {
        toggle = "_",
        open_buffer = "<cr>",
        delete = "dd",
        split = "s",
        vsplit = "v",
        refresh = "r",
        help = "?",
      },
    })
  end,
}
