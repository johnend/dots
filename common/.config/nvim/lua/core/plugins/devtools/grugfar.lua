return {
  "MagicDuck/grug-far.nvim",
  config = function()
    local status_ok, grugfar = pcall(require, "grug-far")
    if not status_ok then
      return
    end

    grugfar.setup {}
  end,
}
