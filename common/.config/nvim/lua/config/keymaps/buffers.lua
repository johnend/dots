return {
  { "<leader>b", group = "Buffer" },
  { "<leader>bn", ":bnext<cr>", desc = "Next" },
  { "<leader>bb", ":bprevious<cr>", desc = "Previous" },
  { "<leader>bd", ":bd<cr>", desc = "Delete" },
  { "<leader>bx", ":%bd|e#|bd#<cr>", desc = "Delete all except current" },
}
