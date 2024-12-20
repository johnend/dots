-- forces specific "filetypes" for files with odd extensions
-- helps with syntax highlighting especially for configuration files
vim.filetype.add {
  extension = {
    conf = "conf",
    env = "dotenv",
    rasi = "rasi",
  },
  filename = {
    [".env"] = "dotenv",
    ["tsconfig.json"] = "jsonc",
    [".yamlfmt"] = "yaml",
    [".cfg"] = "cfg",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "bash",
    [".*/kitty/.*%.conf"] = "bash",
    [".*%.rc"] = "bash",
    [".*/hypr/.*%.conf"] = "hyprlang",
  },
}

-- custom filetype icons

require("nvim-web-devicons").set_icon {
  ["cfg"] = {
    icon = "",
    name = "Configuration",
  },
}
