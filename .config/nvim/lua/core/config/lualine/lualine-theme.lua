local catppuccin = require "lualine.themes.dracula"

catppuccin.normal = {
  a = { bg = colors.mauve, fg = colors.crust, gui = "bold" },
  b = { bg = colors.mantle, fg = colors.text },
  c = { bg = colors.surface0, fg = colors.subtext0 },
  x = { bg = colors.surface0, fg = colors.subtext0 },
  y = { bg = colors.flamingo, fg = colors.crust },
  z = { bg = colors.lavender, fg = colors.crust, gui = "bold" },
}
catppuccin.insert = {
  a = { bg = colors.green, fg = colors.crust, gui = "bold" },
  b = { bg = colors.mantle, fg = colors.text },
  c = { bg = colors.surface0, fg = colors.subtext0 },
  x = { bg = colors.surface0, fg = colors.subtext0 },
  y = { bg = colors.flamingo, fg = colors.crust },
  z = { bg = colors.lavender, fg = colors.crust, gui = "bold" },
}
catppuccin.visual = {
  a = { bg = colors.peach, fg = colors.crust },
  b = { bg = colors.mantle, fg = colors.text },
  c = { bg = colors.surface0, fg = colors.subtext0 },
  x = { bg = colors.surface0, fg = colors.subtext0 },
  y = { bg = colors.flamingo, fg = colors.crust },
  z = { bg = colors.lavender, fg = colors.crust, gui = "bold" },
}
catppuccin.command = {
  a = { bg = colors.flamingo, fg = colors.crust, gui = "bold" },
  b = { bg = colors.mantle, fg = colors.text },
  c = { bg = colors.surface0, fg = colors.subtext0 },
  x = { bg = colors.surface0, fg = colors.subtext0 },
  y = { bg = colors.flamingo, fg = colors.crust },
  z = { bg = colors.lavender, fg = colors.crust, gui = "bold" },
}
catppuccin.replace = {
  a = { bg = colors.red, fg = colors.crust, gui = "bold" },
  b = { bg = colors.mantle, fg = colors.text },
  c = { be = colors.surface0, fg = colors.subtext0 },
  x = { bg = colors.surface0, fg = colors.subtext0 },
  y = { bg = colors.flamingo, fg = colors.crust },
  z = { bg = colors.lavender, fg = colors.crust, gui = "bold" },
}
catppuccin.inactive = {
  a = { bg = colors.base, fg = colors.text, gui = "bold" },
  b = { bg = colors.mantle, fg = colors.text },
  c = { bg = colors.surface0, fg = colors.subtext0 },
  x = { bg = colors.surface0, fg = colors.subtext0 },
  y = { bg = colors.flamingo, fg = colors.crust },
  z = { bg = colors.lavender, fg = colors.crust, gui = "bold" },
}
return catppuccin
