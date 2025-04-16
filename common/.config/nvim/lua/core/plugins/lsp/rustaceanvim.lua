return {
  "mrcjkb/rustaceanvim",
  version = "^6",
  lazy = false,

  config = function()
    local status_ok, rustacean = pcall(require, "rustaceanvim")
    if not status_ok then
      return
    end
  end,
}
