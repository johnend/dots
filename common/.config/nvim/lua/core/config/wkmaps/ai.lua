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
    { "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle" },
  },
  {
    mode = { "v" },
    { "<leader>ca", "<cmd>CodeCompanionChat Add<cr>", desc = "Add visual selection" },
  },
}
