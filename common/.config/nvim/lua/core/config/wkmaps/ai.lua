return {
  {
    mode = { "n" },
    { "<leader>c", group = "Code Companion", icon = icons.misc.CoPilot },
    {
      "<leader>ca",
      function()
        require("telescope").extensions.codecompanion.codecompanion(require("telescope.themes").get_dropdown {
          previewer = false,
          layout_config = {
            vertical = {
              width = 0.5,
              height = 0.3,
              prompt_postion = "top",
            },
          },
        })
      end,
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
