return {
  "CopilotC-Nvim/CopilotChat.nvim",
  cmd = { "InsertEnter", "CopilotChat", "CopilotChatExplain" },
  dependencies = {
    "zbirenbaum/copilot.lua",
  },
  build = "make tiktoken",
  config = function()
    local status_ok, copilot_chat = pcall(require, "CopilotChat")
    if not status_ok then
      return
    end

    copilot_chat.setup {}
  end,
}
