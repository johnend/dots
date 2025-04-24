return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufRead",
  config = function()
    local status_ok, ibl = pcall(require, "ibl")
    if not status_ok then
      return
    end

    local hooks = require "ibl.hooks"
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = colors.transparent.red })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = colors.transparent.yellow })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = colors.transparent.blue })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = colors.transparent.flamingo })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = colors.transparent.green })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = colors.transparent.mauve })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = colors.transparent.sapphire })
    end)

    local highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    }

    ibl.setup {
      enabled = false,
      indent = { highlight = highlight },
      scope = { enabled = false },
    }
  end,
}
