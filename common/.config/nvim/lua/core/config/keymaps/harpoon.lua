local harpoon = require "harpoon"
return {
  { "<leader>h", group = "Harpoon", icon = icons.misc.Hook },
  {
    "<leader>hp",
    function()
      harpoon:list():add()
    end,
    desc = "Add to list",
  },

  {
    "<leader>he",
    function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end,
    desc = "Toggle list",
  },

  {
    "<leader>ha",
    function()
      harpoon:list():select(1)
    end,
    desc = "Harpoon 1",
  },

  {
    "<leader>hs",
    function()
      harpoon:list():select(2)
    end,
    desc = "Harpoon 2",
  },

  {
    "<leader>hd",
    function()
      harpoon:list():select(3)
    end,
    desc = "Harpoon 3",
  },

  {
    "<leader>hf",
    function()
      harpoon:list():select(4)
    end,
    desc = "Harpoon 4",
  },
}
