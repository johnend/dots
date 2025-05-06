return {
  "cbochs/grapple.nvim",
  cmd = "Grapple",
  config = function()
    local status_ok, grapple = pcall(require, "grapple")
    if not status_ok then
      return
    end

    grapple.setup {
      scope = "git",
      icons = true,
      status = true,
    }
  end,
}
