return {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "SmiteshP/nvim-navic",
    "MuniTanjim/nui.nvim",
  },
  config = function()
    local status_ok, navbuddy = pcall(require, "nvim-navbuddy")
    if not status_ok then
      return
    end

    navbuddy.setup {
      window = {
        border = "rounded",
        scrolloff = 4,
      },
      icons = {
        File = icons.kind.File .. " ",
        Module = icons.kind.Module .. " ",
        Namespace = icons.kind.Namespace .. " ",
        Package = icons.kind.Package .. " ",
        Class = icons.kind.Class .. " ",
        Method = icons.kind.Method .. " ",
        Property = icons.kind.Property .. " ",
        Field = icons.kind.Field .. " ",
        Constructor = icons.kind.Constructor .. " ",
        Enum = icons.kind.Enum .. " ",
        Interface = icons.kind.Interface .. " ",
        Function = icons.kind.Function .. " ",
        Variable = icons.kind.Variable .. " ",
        Constant = icons.kind.Constant .. " ",
        String = icons.kind.String .. " ",
        Number = icons.kind.Number .. " ",
        Boolean = icons.kind.Boolean .. " ",
        Array = icons.kind.Array .. " ",
        Object = icons.kind.Object .. " ",
        Key = icons.kind.Key .. " ",
        Null = icons.kind.Null .. " ",
        EnumMember = icons.kind.EnumMember .. " ",
        Struct = icons.kind.Struct .. " ",
        Event = icons.kind.Event .. " ",
        Operator = icons.kind.Operator .. " ",
        TypeParameter = icons.kind.TypeParameter .. " ",
      },
      lsp = {
        auto_attach = true,
      },
    }
  end,
}
