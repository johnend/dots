local colors = require("user.variables.catppuccin-mocha-colors")

local bubbles_theme = {
  normal = {
    a = { fg = colors.crust, bg = colors.mauve },
    b = { fg = colors.text, bg = colors.base },
    c = { fg = colors.text, bg = colors.mantle },
  },

  insert = { a = { fg = colors.crust, bg = colors.green } },
  visual = { b = { fg = colors.crust, bg = colors.lavendar } },
  replace = { c = { fg = colors.sapphire, bg = colors.surface0 } },
}

lvim.builtin.lualine.options = {
  theme = bubbles_theme,
  section_separators = { left = '', right = '' },
}
