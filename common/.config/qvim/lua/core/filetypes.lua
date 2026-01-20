-- forces specific "filetypes" for files with odd extensions
-- helps with syntax highlighting especially for configuration files
vim.filetype.add {
  extension = {
    conf = "conf",
    env = "sh",
    rasi = "rasi",
    cfg = "cfg",
    tfvars = "terraform",
    tf = "terraform",
    yamlfmt = "yaml",
  },
  filename = {
    ["tsconfig.json"] = "jsonc",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "sh",
    [".*/kitty/.*%.conf"] = "bash",
    [".*%.rc"] = "bash",
    [".*/hypr/.*%.conf"] = "hyprlang",
  },
}

-- custom filetype icons
-- require("nvim-web-devicons").set_icon {
--   ["cfg"] = {
--     icon = "",
--     name = "Configuration",
--   },
-- }
