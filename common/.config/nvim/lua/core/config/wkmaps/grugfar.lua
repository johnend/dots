return {
  { "<leader>f", group = "Find & Replace", icon = icons.ui.Search },
  {
    "<leader>ff",
    function()
      require("grug-far").open { prefills = { paths = vim.fn.expand "%" } }
    end,
    desc = "Current file",
  },
  { "<leader>fr", "<cmd>GrugFar<cr>", desc = "Within project" },
  { "<leader>fv", "<cmd>GrugFarWithin<cr>", desc = "Within selection" },
}
