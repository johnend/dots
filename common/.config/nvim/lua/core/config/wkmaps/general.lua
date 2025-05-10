return {
  {
    mode = { "n", "v" },
    {
      "<leader>c",
      function()
        require("conform").format { async = true, lsp_fallback = true }
      end,
      desc = "Format buffer",
    },
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
    { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment toggle current line" },
  },
}
