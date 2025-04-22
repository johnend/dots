return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = "GitSigns",
  config = function()
    local status_ok, gitsigns = pcall(require, "gitsigns")
    if not status_ok then
      return
    end
    gitsigns.setup {
      signs = {
        add = {
          text = icons.ui.BoldLineLeft,
        },
        change = {
          text = icons.ui.BoldLineLeft,
        },
        delete = {
          text = icons.ui.Triangle,
        },
        topdelete = {
          text = icons.ui.Triangle,
        },
        changedelete = {
          text = icons.ui.BoldLineLeft,
        },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      sign_priority = 6,
      status_formatter = nil,
      update_debounce = 200,
      max_file_length = 40000,
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    }
  end,
}
