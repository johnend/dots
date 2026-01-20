return {
  { "<leader>b", group = "Buffer" },
  { "<leader>bn", ":bnext<cr>", desc = "Next" },
  { "<leader>bb", ":bprevious<cr>", desc = "Previous" },
  { "<leader>bd", ":lua Snacks.bufdelete.delete() <cr>", desc = "Delete" },
  { "<leader>bx", ":lua Snacks.bufdelete.other() <cr>", desc = "Delete all except current" },
}
