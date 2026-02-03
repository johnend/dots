return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPre", "BufNewFile" },
  submodules = false,
  config = function()
    local status_ok, rainbow = pcall(require, "rainbow-delimiters.setup")
    if not status_ok then
      return
    end
    rainbow.setup {}
  end,
}
