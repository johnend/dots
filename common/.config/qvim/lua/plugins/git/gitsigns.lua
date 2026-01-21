return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  cmd = "GitSigns",
  config = function()
    local status_ok, gitsigns = pcall(require, "gitsigns")
    if not status_ok then
      return
    end
    gitsigns.setup {
      signs = {
        add = {
          text = Icons.ui.BoldLineLeft,
        },
        change = {
          text = Icons.ui.BoldLineLeft,
        },
        delete = {
          text = Icons.ui.Triangle,
        },
        topdelete = {
          text = Icons.ui.Triangle,
        },
        changedelete = {
          text = Icons.ui.BoldLineLeft,
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
