local copilot_chat = require "CopilotChat"

return {
  {
    mode = { "n" },
    { "<leader>c", group = "CoPilot", icon = icons.misc.CoPilot },
    { "<leader>cj", "<Plug>(copilot-next)", desc = "Next Suggestion" },
    { "<leader>ck", "<Plug>(copilot-previous)", desc = "Previous Suggestion" },
    { "<leader>cy", "<Plug>(copilot-accept)", desc = "Accept Suggestion" },
    { "<leader>cd", "<Plug>(copilot-dismiss)", desc = "Dismiss Suggestion" },
    { "<leader>ct", ":Copilot toggle<CR>", desc = "Copilot: Toggle" },
    {
      "<leader>cc",
      function()
        copilot_chat.toggle()
      end,
      desc = "Toggle Chat",
    },
    {
      "<leader>cr",
      function()
        copilot_chat.reset()
      end,
      desc = "Reset Chat",
    },
  },
  {
    mode = { "v" },
    { "<leader>c", group = "CoPilot", icon = icons.misc.CoPilot },
    {
      "<leader>ca",
      function()
        copilot_chat.ask("How can I optimise this?", {
          context = { "selection", "buffer", "git:staged" },
        })
      end,
      desc = "Ask (Visual Selection)",
    },
    {
      "<leader>ce",
      function()
        vim.cmd "CopilotChatExplain"
      end,
      desc = "Ask (Visual Selection)",
    },
  },
}
