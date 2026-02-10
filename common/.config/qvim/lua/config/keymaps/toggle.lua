vim.g.colorizer_enabled = true
vim.g.scrolloff_max = true

return {
  { "<leader>t", group = "Toggle", icon = Icons.ui.Toggle },
  { "<leader>td", group = "Dim", icon = Icons.misc.Dim },
  { "<leader>ti", group = "Indent", icon = Icons.misc.Indent },
  {
    "<leader>ta",
    function()
      vim.g.autosave_enabled = not vim.g.autosave_enabled
      vim.notify("AutoSave " .. (vim.g.autosave_enabled and "enabled" or "disabled"))
    end,
    icon = Icons.ui.Toggle,
    desc = "AutoSave",
  },
  {
    "<leader>tc",
    function()
      vim.cmd "ColorizerToggle"
      vim.g.colorizer_enabled = not vim.g.colorizer_enabled
      vim.notify("Colorizer " .. (vim.g.colorizer_enabled and "enabled" or "disabled"))
    end,
    desc = "Colorizer",
  },
  { "<leader>tde", ":lua Snacks.dim() <cr>", icon = Icons.ui.ToggleOn, desc = "Enable" },
  { "<leader>tdd", ":lua Snacks.dim.disable() <cr>", icon = Icons.ui.ToggleOff, desc = "Disable" },
  { "<leader>tie", ":lua Snacks.indent.enable() <cr>", icon = Icons.ui.ToggleOn, desc = "Enable" },
  { "<leader>tid", ":lua Snacks.indent.disable() <cr>", icon = Icons.ui.ToggleOff, desc = "Disable" },
  {
    "<leader>ts",
    function()
      vim.g.scrolloff_max = not vim.g.scrolloff_max
      vim.wo.scrolloff = vim.wo.scrolloff == 999 and 8 or 999
      vim.notify("Scrolloff set to " .. (vim.g.scrolloff_max and "8" or "999"))
    end,
    desc = "Scrolloff",
  },
  { "<leader>tp", ":lua Snacks.image.hover() <cr>", icon = Icons.misc.Image, desc = "Image Preview" },
  { "<leader>tz", ":lua Snacks.zen() <cr>", icon = Icons.misc.Meditate, desc = "Zen" },
}
