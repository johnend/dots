local wezterm = require "wezterm"
local action = wezterm.action

local keys = {}

wezterm.on("update-right-status", function(window, pane)
  local leader = ""
  if window:leader_is_active() then
    leader = "LEADER"
  end
  window:set_right_status(leader)
end)

function keys.apply_to_config(config)
  -- set config options here
  -- config.config_option = config_option_value
  config.leader = { key = " ", mods = "SHIFT" }

  -- Normal keys
  config.keys = {
    {
      key = "s",
      mods = "LEADER",
      action = action.ActivateKeyTable {
        name = "splits",
        one_shot = false,
      },
    },

    {
      key = "w",
      mods = "CMD",
      action = action.CloseCurrentTab { confirm = false },
    },

    { key = "h", mods = "CMD|SHIFT", action = action.ActivatePaneDirection "Left" },
    { key = "l", mods = "CMD|SHIFT", action = action.ActivatePaneDirection "Right" },
    { key = "k", mods = "CMD|SHIFT", action = action.ActivatePaneDirection "Up" },
    { key = "j", mods = "CMD|SHIFT", action = action.ActivatePaneDirection "Down" },

    {key = "p", mods = "CMD|SHIFT", action = action.ActivateCommandPalette }
  }


  -- Key tables (chords)
  config.key_tables = {
    splits = {
      { key = "d", action = action.SplitVertical { domain = "CurrentPaneDomain" } },
      { key = "f", action = action.SplitHorizontal { domain = "CurrentPaneDomain" } },
      { key = "LeftArrow", action = action.AdjustPaneSize { "Left", 1 } },
      { key = "h", action = action.AdjustPaneSize { "Left", 1 } },

      { key = "RightArrow", action = action.AdjustPaneSize { "Right", 1 } },
      { key = "l", action = action.AdjustPaneSize { "Right", 1 } },

      { key = "UpArrow", action = action.AdjustPaneSize { "Up", 1 } },
      { key = "k", action = action.AdjustPaneSize { "Up", 1 } },

      { key = "DownArrow", action = action.AdjustPaneSize { "Down", 1 } },
      { key = "j", action = action.AdjustPaneSize { "Down", 1 } },
      { key = "Escape", action = "PopKeyTable" },
    },
  }
end

return keys
