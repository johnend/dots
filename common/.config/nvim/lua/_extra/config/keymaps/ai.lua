return {
  {
    mode = { "n" },
    { "<leader>c", group = "Code Companion", icon = icons.misc.CoPilot },
    {
      "<leader>ca",
      "<cmd>Telescope codecompanion theme=dropdown previewer=false layout_config={height=10}<cr>",
      desc = "Actions",
    },
    { "<leader>cc", "<cmd>CodeCompanionChat<cr>", desc = "Chat" },
    { "<leader>ci", "<cmd>CodeCompanion<cr>", desc = "Inline Assistant" },
    {
      "<leader>ct",
      function()
        local has_chat = false
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.bo[buf].filetype
          if ft and ft:match "^codecompanion" then
            has_chat = true
            break
          end
        end
        if has_chat then
          vim.cmd "CodeCompanionChat Toggle"
        else
          vim.cmd "CodeCompanionChat"
        end
      end,
      desc = "Toggle Chat (safe)",
    },
    { "<leader>cb", "<cmd>CodeCompanionChat /buffer<cr>", desc = "Attach current buffer" },
    { "<leader>cs", "<cmd>CodeCompanionChat /symbols<cr>", desc = "Attach symbols" },
    { "<leader>cf", "<cmd>CodeCompanionChat /file<cr>", desc = "Attach this file" },
  },
  {
    mode = { "v" },
    { "<leader>ca", "<cmd>CodeCompanionChat Add<cr>", desc = "Add visual selection" },
    { "<leader>ci", "<cmd>CodeCompanion<cr>", desc = "Inline from selection" },
  },
}
