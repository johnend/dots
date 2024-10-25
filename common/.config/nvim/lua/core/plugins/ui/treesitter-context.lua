return {
  "nvim-treesitter/nvim-treesitter-context",
  config = function()
    local status_ok, tscontext = pcall(require, "treesitter-context")
    if not status_ok then
      return
    end
    tscontext.setup = {}
  end,
}
