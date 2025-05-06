return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",

  config = function()
    local status_ok, harpoon = pcall(require, "harpoon")
    if not status_ok then
      return
    end

    harpoon.setup {}
    -- Toggle previous & next buffers stored within Harpoon list
    -- vim.keymap.set("n", "<C-S-P>", function()
    --   harpoon:list():prev()
    -- end)
    -- vim.keymap.set("n", "<C-S-N>", function()
    --   harpoon:list():next()
    -- end)
  end,
}
