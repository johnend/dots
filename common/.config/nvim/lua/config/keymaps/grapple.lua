return {
  { "<leader>h", group = "Grapple", icon = Icons.misc.Hook },
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
    desc = "Go to 1",
  },

  {
    "<leader>hs",
    "<cmd>Grapple select index=2<cr>",
    desc = "Go to 2",
  },

  {
    "<leader>hd",
    "<cmd>Grapple select index=3<cr>",
    desc = "Go to 3",
  },

  {
    "<leader>hf",
    "<cmd>Grapple select index=4<cr>",
    desc = "Go to 4",
  },

  {
    "<leader>hn",
    "<cmd>Grapple cycle_tags next<cr>",
    desc = "Go to next tag",
  },

  {
    "<leader>hp",
    "<cmd>Grapple cycle_tags prev<cr>",
    desc = "Go to previous tag",
  },
}
