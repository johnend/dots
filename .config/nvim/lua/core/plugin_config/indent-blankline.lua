local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}
local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = colors.transparent.red })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = colors.transparent.yellow })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = colors.transparent.blue })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = colors.transparent.peach })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = colors.transparent.green })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = colors.transparent.mauve })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = colors.transparent.sapphire })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
require("ibl").setup { scope = { highlight = highlight } }

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
