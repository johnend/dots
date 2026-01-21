return {
  {
    mode = { "n", "v" },
    {
      "<leader>F",
      function()
        require("conform").format { async = true, lsp_fallback = true }
      end,
      desc = "Format buffer",
    },
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
    { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment toggle current line" },
    {
      "<leader>N",
      function()
        Snacks.win {
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        }
      end,
      icon = Icons.misc.NeoVim,
      desc = "NeoVim news",
    },
  },
}
