local wezterm = require "wezterm"
-- example comment
local theme = {}

function theme.apply_to_config(config)
  config.color_scheme = "Catppuccin Mocha"

  config.colors = {
    background = "#11111B",
    cursor_bg = "#D20F39",
    selection_bg = "#cba6f7",
    selection_fg = "#11111b",
    split = "#cba6f7",
    ansi = {
      "#11111b", -- black
      "#f38ba8", -- red
      "#a6e3a1", -- green
      "#f9e2af", -- yellow
      "#89b4fa", -- blue
      "#cba6f7", -- magenta
      "#94e2d5", -- cyan
      "#bac2de", -- white
    },
    brights = {
      "#585b70", -- black
      "#f38ba8", -- red
      "#a6e3a1", -- green
      "#f9e2af", -- yellow
      "#89b4fa", -- blue
      "#cba6f7", -- magenta
      "#94e2d5", -- cyan
      "#a6adc8", -- white
    },
  }

  config.font = wezterm.font_with_fallback { { family = "Monaspace Argon", stretch = "Normal", weight = "DemiBold" } }

  -- config.cell_width = 1.1

  -- config.line_height = 1.2

  config.harfbuzz_features = { "calt", "liga", "dlig", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" }

  config.freetype_load_flags = "NO_HINTING"

  config.font_size = 12.5

  config.font_rules = {
    {
      intensity = "Bold",
      italic = true,
      font = wezterm.font {
        family = "Monaspace Radon",
        weight = "Bold",
        style = "Italic",
      },
    },
    {
      italic = true,
      intensity = "Half",
      font = wezterm.font {
        family = "Monaspace Radon",
        weight = "Bold",
        style = "Italic",
      },
    },
    {
      italic = true,
      intensity = "Normal",
      font = wezterm.font {
        family = "Monaspace Radon",
        style = "Italic",
        weight = "Medium",
      },
    },
  }

  config.command_palette_bg_color = "#181825"
  config.command_palette_fg_color = "#cdd6f4"
  config.command_palette_rows = 16

  config.cursor_blink_ease_in = "Constant"
  config.cursor_blink_ease_out = "Constant"
  config.cursor_blink_rate = 550

  config.inactive_pane_hsb = {
    -- saturation = 0.66,
    brightness = 0.5,
  }

  config.window_padding = {
    left = 8,
    right = 8,
    top = 0,
    bottom = 0,
  }
end

return theme
