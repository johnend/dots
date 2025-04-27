return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",

  config = function()
    local status_ok, dap = pcall(require, "nvim-dap")
    if not status_ok then
      return
    end
  end,
}
