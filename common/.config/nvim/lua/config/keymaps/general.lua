local path = require "config.path"

return {
  { "<leader>z", group = "Shell", icon = Icons.misc.Shell },
  { "<leader>y", group = "Yank", icon = Icons.kind.Reference, mode = "n" },
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
  { "<leader>yy", path.copy_current_buffer_absolute_path, desc = "Copy absolute buffer path", icon = Icons.ui.FileSymlink, mode = "n" },
  { "<leader>yY", path.copy_current_buffer_relative_path, desc = "Copy relative buffer path", icon = Icons.kind.Reference, mode = "n" },
}
