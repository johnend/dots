return {
  "dmmulroy/tsc.nvim",
  event = "VeryLazy",
  config = function()
    local status_ok, tsc = pcall(require, "tsc")
    if not status_ok then
      return
    end

    local utils = require "tsc.utils"
    tsc.setup {
      auto_open_qflist = true,
      auto_close_qflist = false,
      auto_focus_qflist = false,
      auto_start_watch_mode = false,
      use_trouble_qflist = true,
      use_diagnostics = true,
      run_as_monorepo = false,
      bin_path = utils.find_tsc_bin(),
      enable_progress_notifications = true,
      enable_error_notifications = true,
      flags = {
        noEmit = true,
        project = function()
          return utils.find_nearest_tsconfig()
        end,
        watch = false,
      },
      hide_progress_notifications_from_history = true,
      spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
      pretty_errors = true,
    }
  end,
}
