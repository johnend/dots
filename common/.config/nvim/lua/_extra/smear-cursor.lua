return {
  "sphamba/smear-cursor.nvim",
  cond = vim.g.neovide == nil,
  config = function()
    local status_ok, smear = pcall(require, "smear_cursor")
    if not status_ok then
      return
    end

    smear.setup {
      -- Motion rules
      smear_between_buffers = false,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,

      -- Cursor and color rules
      cursor_color = "#FF00AF",
      hide_target_hack = true,
      never_draw_over_target = true,

      -- Inser mode rules
      smear_insert_mode = true,

      -- Physics
      stiffness = 1.0,
      trailing_stiffness = 0.3,
      stiffness_insert_mode = 1.0,
      trailing_stiffness_insert_mode = 0.3,
      distance_stop_animating = 0.1,

      -- Timing
      time_interval = 17,
    }
  end,
}
