local wezterm = require "wezterm"

local window = {}

function window.apply_to_config(config)
  -- tab bar
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true

  -- window decorations
  config.window_decorations = "RESIZE"

  -- window padding
  config.window_padding = {
    top = 8,
  }
end

return window