local M = {
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
  zen = {
    backdrop = { transparent = false, blend = 21 },
  },
}

return M
