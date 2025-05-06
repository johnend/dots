return {
  { "<leader>h", group = "Harpoon", icon = icons.misc.Hook },
  {
    "<leader>hh",
    "<cmd>Grapple toggle<cr>",
    desc = "Add to list",
  },

  {
    "<leader>hl",
    "<cmd>Grapple toggle_tags<cr>",
    desc = "Toggle list",
  },

  {
    "<leader>ha",
    "<cmd>Grapple select index=1<cr>",
    desc = "Harpoon 1",
  },

  {
    "<leader>hs",
    "<cmd>Grapple select index=2<cr>",
    desc = "Harpoon 2",
  },

  {
    "<leader>hd",
    "<cmd>Grapple select index=3<cr>",
    desc = "Harpoon 3",
  },

  {
    "<leader>hf",
    "<cmd>Grapple select index=4<cr>",
    desc = "Harpoon 4",
  },

  {
    "<C-S-N>",
    "<cmd>Grapple cycle_tags next<cr>",
    desc = "Go to next tag",
  },

  {
    "<C-S-P>",
    "<cmd>Grapple cycle_tags prev<cr>",
    desc = "Go to previous tag",
  },
}
