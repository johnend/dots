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
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "bash",
    [".*/kitty/.*%.conf"] = "bash",
    [".*%.rc"] = "bash",
    [".*/hypr/.*%.conf"] = "hyprlang",
  },
}
