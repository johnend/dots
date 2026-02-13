return {
  "akinsho/bufferline.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    {
      "tiagovla/scope.nvim",
      event = "VeryLazy",
      opts = {}, -- Per-tab buffer scoping
    },
  },
  opts = {
    options = {},
  },
  config = function()
    local status_ok, bufferline = pcall(require, "bufferline")
    bufferline.setup {
      options = {
        -- mode = "buffers",
        style_preset = bufferline.style_preset.no_italic,
        -- themable = true,
        -- numbers = "none",
        color_icons = true,
        diagnostics = false,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        offsets = {
          {
            filetype = "neo-tree",
            text = Icons.ui.Folder .. " Files",
            text_align = "left",

            separator = true,
          },
        },
      },
    }
  end,
}
