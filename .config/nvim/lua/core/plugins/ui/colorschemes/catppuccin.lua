return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  config = function()
    local status_ok, catppuccin = pcall(require, "catppuccin")
    if not status_ok then
      return
    end

    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
    end

    catppuccin.setup {
      flavour = "mocha",
      transparent_background = true,
      styles = { -- Handles the styles of general hi groups (see: :h highlight-args):
      },
      highlight_overrides = {
        all = function()
          return {
            CursorLine = { fg = "", bg = colors.base },
            Folded = { fg = colors.overlay0, bg = colors.mantle },
            WinSeparator = { fg = "#301e48", bg = "" },
            VertSplit = { fg = "#301e48", bg = "" },
            IncSearch = { fg = colors.mantle, bg = colors.mauve },
            FloatBorder = { fg = colors.mauve, bg = "" },
            NotifyBackground = { bg = colors.crust },
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
            RainbowDelimiterRed = { fg = colors.red },
            RainbowDelimiterYellow = { fg = colors.yellow },
            RainbowDelimiterBlue = { fg = colors.blue },
            RainbowDelimiterOrange = { fg = colors.flamingo },
            RainbowDelimiterGreen = { fg = colors.green },
            RainbowDelimiterViolet = { fg = colors.mauve },
            RainbowDelimiterCyan = { fg = colors.sapphire },

            -- Noice highlights
            NoiceCmdlinePopupBorder = { fg = colors.mauve },

            -- IBL highlights
            IblIndent = { fg = colors.mantle },
            RainbowRed = { bg = colors.transparent.red },
            RainbowYellow = { bg = colors.transparent.yellow },
            RainbowBlue = { bg = colors.transparent.blue },
            RainbowOrange = { bg = colors.transparent.peach },
            RainbowGreen = { bg = colors.transparent.green },
            RainbowViolet = { bg = colors.transparent.mauve },
            RainbowCyan = { bg = colors.transparent.sapphire },
          }
        end,
      },
    }
    vim.cmd.colorscheme "catppuccin"

  end,
}
