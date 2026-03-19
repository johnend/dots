return {

  "Rics-Dev/project-explorer.nvim",
  dependecies = {
    "nvim-telescope/telescope.nvim",
  },

  opts = {
    paths = {
      "~/Developer",
      "~/Developer/dots/common/.config",
      "~/Developer/dots/linux/common/.config",
      "~/Developer/dots/linux/sway/.config",
    },
    newProjectPath = "~/Developer",
    file_explorer = function(dir)
      vim.cmd "Neotree close"
      vim.cmd("Neotree " .. dir)
    end,
  },

  config = function(_, opts)
    require("project_explorer").setup(opts)
  end,

  keys = {},

  lazy = false,
}
