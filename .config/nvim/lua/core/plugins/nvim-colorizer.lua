require("colorizer").setup {
  filetypes = { "*" },
  user_default_options = {
    RGB = true,
    RRGGBB = true,
    RRGGBBAA = true,
    AARRGGBB = true,
    mode = "background",
    virtualtext = "■",
    always_update = true,
  },
  css = { css = true },
  html = { css = true },
  javascript = { css = true },
}
