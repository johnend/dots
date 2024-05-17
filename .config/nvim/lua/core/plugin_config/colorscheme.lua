require("catppuccin").setup {
  flavour = "mocha",
  transparent_background = true,
  styles = { -- Handles the styles of general hi groups (see: :h highlight-args):
  },
  highlight_overrides = {
    all = function(colors)
      return {
        CursorLine = { fg = "", bg = colors.base },
        Folded = { fg = colors.overlay0, bg = colors.mantle },
        WinSeparator = { fg = "#301e48", bg = "" },
        VertSplit = { fg = "#301e48", bg = "" },
        IncSearch = { fg = colors.mantle, bg = colors.mauve },
        FloatBorder = { fg = colors.mauve, bg = "" },
        NeoTreeCursorLine = { fg = "", bg = "#1e1825" },
        NeoTreeDirectoryIcon = { fg = colors.mauve, bg = "" },
        NeoTreeDirectoryName = { fg = colors.text, bg = "" },
        NeoTreeFileName = { fg = colors.text, bg = "" },
        NeoTreeFileNameOpened = { fg = colors.green, bg = colors.mauve },
        NeoTreeFloatBorder = { fg = colors.mauve, bg = "" },
        NeoTreeFloatTitle = { fg = colors.mauve, bg = "" },
        NeoTreeIndentMarker = { fg = colors.surface0, bg = "" },
        NeoTreeWinSeparator = { fg = "#956dc5", bg = "" },
        NeoTreeRootName = { fg = colors.mauve, bg = "" },

        -- Rainbow delimeters
        TSRainbowRed = { fg = colors.red },
        TSRainbowYellow = { fg = colors.yellow },
        TSRainbowBlue = { fg = colors.blue },
        TSRainbowOrange = { fg = colors.flamingo },
        TSRainbowGreen = { fg = colors.green },
        TSRainbowViolet = { fg = colors.mauve },
        TSRainbowCyan = { fg = colors.sapphire },
      }
    end,
  },
}

vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd.colorscheme "catppuccin"
