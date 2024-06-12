vim.filetype.add {
  extension = {
    conf = "conf",
    env = "dotenv",
  },
  filename = {
    [".env"] = "dotenv",
    ["tsconfig.json"] = "jsonc",
    [".yamlfmt"] = "yaml",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "bash",
  },
}
