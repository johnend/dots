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
    [".*/hypr/.*%.conf"] = "hyprlang",
  },
}
