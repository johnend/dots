return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local status_ok, barbecue = pcall(require, "barbecue")
    if not status_ok then
      return
    end
    barbecue.setup()
    require("barbecue.ui").toggle(false)
    vim.keymap.set("n", "<leader>tb", "<cmd>lua require('barbecue.ui').toggle()<cr>", { desc = "Barbecue" })
  end,
}
