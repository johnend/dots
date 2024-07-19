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

    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "Add to list" })

    vim.keymap.set("n", "<leader>he", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Toggle list" })

    -- Got to specific list item
    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon 1" })

    vim.keymap.set("n", "<leader>hs", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon 2" })

    vim.keymap.set("n", "<leader>hd", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon 3" })

    vim.keymap.set("n", "<leader>hf", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon 4" })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<C-S-P>", function()
      harpoon:list():prev()
    end)
    vim.keymap.set("n", "<C-S-N>", function()
      harpoon:list():next()
    end)
  end,
}
