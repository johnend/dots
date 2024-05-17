require("catppuccin").setup ({
  flavour = "mocha",
  transparent_background = true,
  styles = { -- handles styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" },
  },
  -- TODO this needs something to be updated
  custom_highlights = function(colors)
    return {
      Todo = { bg = colors.mauve, fg = colors.crust, },
      ['@text.todo'] = { bg = colors.mauve, fg = colors.crust },
    }
  end
})

vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd.colorscheme("catppuccin")
lvim.colorscheme = "catppuccin"
lvim.transparent_window = true
