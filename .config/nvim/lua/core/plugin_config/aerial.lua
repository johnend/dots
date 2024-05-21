local aerial = require "aerial"

aerial.setup {
  backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
  on_attach = function(bufnr)
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
  end,
  layout = {
    max_width = { 60, 0.25 },
    width = nil,
    min_width = 20,
    default_direction = "prefer_left",
    resize_to_content = false,
  },
  filter_kind = false,
  ignore = {
    filetypes = {
      "dirvish",
      "fugitive",
      "alpha",
      "Neotree",
      "lazy",
      "toggleterm",
      "TelescopePropmt",
    },
    buftypes = "special",
    wintypes = "special",
  },
}

vim.keymap.set("n", "<leader>ta", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial" })
