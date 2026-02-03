return {
  { "<leader>f", group = "Find & Replace", icon = Icons.ui.Search },
  {
    "<leader>ff",
    function()
      require("grug-far").open { prefills = { paths = vim.fn.expand "%" } }
    end,
    desc = "Current file",
  },
  { "<leader>fr", "<cmd>GrugFar<cr>", desc = "Within project" },
  { "<leader>fv", "<cmd>GrugFarWithin<cr>", desc = "Within selection" },
  {
    "<leader>fe",
    function()
      local grug = require "grug-far"
      local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
      grug.open {
        transient = true,
        prefills = {
          filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        },
      }
    end,
    mode = { "n", "v" },
    desc = "Search and Replace",
  },
}
