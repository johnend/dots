return {
  "LunarVim/bigfile.nvim",
  config = function()
    local status_ok, bigfile = pcall(require, "bigfile")
    if not status_ok then
      return
    end

    bigfile.setup {
      filesize = 3,
      features = {
        "indent_blankline",
        "illuminate",
        "lsp",
        "treesitter",
        "syntax",
        "matchparen",
        "vimopts",
        "filetype",
      },
    }
  end,
}
