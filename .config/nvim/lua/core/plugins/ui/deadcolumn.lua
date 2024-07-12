return {
  "Bekaboo/deadcolumn.nvim",
  event = { "BufRead", "BufNewFile" },
  config = function()
    local status_ok, deadcolumn = pcall(require, "deadcolumn")
    if not status_ok then
      return
    end
    deadcolumn.setup {
      blending = {
        threshold = 0.5,
        colorcode = colors.crust,
      },
      warning = {
        alpha = 0.2,
        colorcode = colors.red,
      },
    }
  end,
}
