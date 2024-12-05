return {
  "rose-pine/neovim",
  lazy = false,
  priority = 1000,
  name = "rose-pine",
  config = function()
    local status_ok, rose_pine = pcall(require, "rose-pine")
    if not status_ok then
      return
    end

    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
    end

    rose_pine.setup {
      variant = "main",
      styles = {
        transparency = true,
      },

      highlight_groups = {
        CursorLine = { fg = "", bg = "surface" },
        Folded = { fg = "muted", bg = "surface" },
        WinSeparator = { fg = "#301e48", bg = "" },
        VertSplit = { fg = "#301e48", bg = "" },
        IncSearch = { fg = "surface", bg = "iris" },
        FloatBorder = { fg = "iris", bg = "" },
        NotifyBackground = { bg = "base" },
        NeoTreeCursorLine = { fg = "", bg = "#1e1825" },
        NeoTreeDirectoryIcon = { fg = "iris", bg = "" },
        NeoTreeDirectoryName = { fg = "text", bg = "" },
        NeoTreeFileName = { fg = "text", bg = "" },
        NeoTreeFileNameOpened = { fg = "pine", bg = "iris" },
        NeoTreeFloatBorder = { fg = "iris", bg = "" },
        NeoTreeFloatTitle = { fg = "iris", bg = "" },
        NeoTreeIndentMarker = { fg = "overlay", bg = "" },
        NeoTreeWinSeparator = { fg = "#956dc5", bg = "" },
        NeoTreeRootName = { fg = "iris", bg = "" },

        -- Rainbow delimeters
        RainbowDelimiterRed = { fg = "love" },
        RainbowDelimiterYellow = { fg = "gold" },
        RainbowDelimiterBlue = { fg = "pine" },
        RainbowDelimiterOrange = { fg = "rose" },
        RainbowDelimiterGreen = { fg = "foam" },
        RainbowDelimiterViolet = { fg = "iris" },
        RainbowDelimiterCyan = { fg = "pine" },

        -- Noice highlights
        NoiceCmdlinePopupBorder = { fg = "iris" },

        -- IBL highlights
        IblIndent = { fg = "iris" },
        RainbowRed = { bg = "love" },
        RainbowYellow = { bg = "gold" },
        RainbowBlue = { bg = "pine" },
        RainbowOrange = { bg = "rose" },
        RainbowGreen = { bg = "foam" },
        RainbowViolet = { bg = "iris" },
        RainbowCyan = { bg = "pine" },

        -- Terminal (toggleterm)
        TermCursor = { fg = "surface", bg = "#D20F39" },
      },
    }
    vim.cmd.colorscheme "rose-pine"
  end,
}
