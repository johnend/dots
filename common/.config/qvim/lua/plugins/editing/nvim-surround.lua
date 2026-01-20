return {
  "kylechui/nvim-surround",
  version = "^3.0.0",
  event = "VeryLazy",
  config = function()
    local status_ok, surround = pcall(require, "nvim-surround")
    if not status_ok then
      return
    end

    surround.setup {}
  end,
}
