return {
  "folke/lazydev.nvim",
  lazy = false,
  ft = "lua",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
