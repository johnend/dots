require("illuminate").configure {
  providers = {
    "lsp",
    "treesitter",
    "regex",
  },
  delay = 120,
  filetypes_overrides = {},
  filetypes_denylist = {
    "dirvish",
    "fugitive",
    "alpha",
    "Neotree",
    "lazy",
    "Trouble",
    "Outline",
    "spectre_panel",
    "toggleterm",
    "TelescopePrompt",
  },
  under_cursor = true,
}
