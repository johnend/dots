local plugins = {
  "actions-preview",
  "alpha",
  "autopairs",
  "autotags",
  "barbecue",
  "colorscheme",
  "cokeline",
  "conform",
  "comment",
  "cmp",
  "deadcolumn",
  "illuminate",
  "indent-blankline",
  "lightbulb",
  "lualine/lualine",
  "neo-tree",
  "neodev",
  "noice",
  "nvim-colorizer",
  "precognition",
  "which-key",
  "gitsigns",
  "telescope",
  "toggleterm",
  "todo-comments",
  "treesitter",
  "trouble",
  "twilight",
}

-- keep colorscheme at the top
-- will help with lazy in future
-- require("core.plugin_config.colorscheme")
--
-- require("core.plugin_config.cmp")
-- require("core.plugin_config.neo-tree")
-- require("core.plugin_config.nvim-colorizer")
-- require("core.plugin_config.which-key")
-- require("core.plugin_config.gitsigns")

for _, plugin in pairs(plugins) do
  require("core.plugin_config." .. plugin)
end
