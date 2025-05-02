return {
  "cdmill/focus.nvim",

  config = function()
    local status_ok, focus = pcall(require, "focus")
    if not status_ok then
      return
    end

    focus.setup {
      window = {
        backdrop = 1,
        width = 160,
      },
      plugins = {
        twilight = { enabled = false },
      },
    }
  end,
}
