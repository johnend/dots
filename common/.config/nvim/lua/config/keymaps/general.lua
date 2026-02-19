return {
  { "<leader>z", group = "Shell", icon = Icons.misc.Shell },
  {
    mode = { "n", "v" },
    {
      "<leader>F",
      function()
        require("conform").format { async = true, lsp_fallback = true }
      end,
      desc = "Format buffer",
    },
    { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment toggle current line" },
    { "<leader>;", "<cmd>Alpha<cr>", desc = "Dashboard" },
    { "<leader>w", "<cmd>w<cr>", desc = "Write" },
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
  },
}
