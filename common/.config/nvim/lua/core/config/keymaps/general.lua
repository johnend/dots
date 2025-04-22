return {
  {
    mode = { "n", "v" },
    {
      "<leader>f",
      function()
        require("conform").format { async = true, lsp_fallback = true }
      end,
      desc = "Format buffer",
    },
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
    { "<leader>w", "<cmd>w<cr>", desc = "Write", icon = icons.misc.Write },
    { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment toggle current line" },
  },
}
