local wezterm = require "wezterm"
local act = wezterm.action

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
  -- config.leader = { key = "s", mods = "CTRL" }

  config.keys = {

    {
      key = "w",
      mods = "SUPER",
      action = act.CloseCurrentTab { confirm = false },
    },
    { key = "p", mods = "CMD|SHIFT", action = act.ActivateCommandPalette },
    { key = "p", mods = "CTRL|SHIFT", action = act.DisableDefaultAssignment },
    { key = "n", mods = "CTRL|SHIFT", action = act.DisableDefaultAssignment },

    -- reset zoom
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

    -- manage splits/panes
    { key = "s", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "v", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection "Left" },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection "Down" },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection "Up" },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection "Right" },
    { key = "o", mods = "LEADER", action = act.RotatePanes "Clockwise" },

    -- manage layouts and tabs
    { key = "a", mods = "LEADER", action = act.EmitEvent "work_layout" },
    { key = "p", mods = "LEADER", action = act.EmitEvent "personal_layout" },
    { key = "t", mods = "LEADER", action = act.SpawnTab "CurrentPaneDomain" },
    { key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "n", mods = "LEADER", action = act.ShowTabNavigator },
    {
      key = "e",
      mods = "LEADER",
      action = act.PromptInputLine {
        description = wezterm.format {
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { AnsiColor = "Fuchsia" } },
          { Text = "Enter a new tab title..." },
        },
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
    },

    -- key table activation
    {
      key = "r",
      mods = "LEADER",
      action = act.ActivateKeyTable { name = "resize_pane", one_shot = false, timeout_milliseconds = 2000 },
    },
    {
      key = "m",
      mods = "LEADER",
      action = act.ActivateKeyTable { name = "move_tab", one_shot = false, timeout_milliseconds = 2000 },
    },
  }

  config.key_tables = {
    resize_pane = {
      { key = "h", action = act.AdjustPaneSize { "Left", 1 } },
      { key = "j", action = act.AdjustPaneSize { "Down", 1 } },
      { key = "k", action = act.AdjustPaneSize { "Up", 1 } },
      { key = "l", action = act.AdjustPaneSize { "Right", 1 } },
      { key = "Escape", action = "PopKeyTable" },
    },
    move_tab = {
      { key = "h", action = act.MoveTabRelative(-1) },
      { key = "j", action = act.MoveTabRelative(-1) },
      { key = "k", action = act.MoveTabRelative(1) },
      { key = "l", action = act.MoveTabRelative(1) },
      { key = "Escape", action = "PopKeyTable" },
    },
  }
end

return keys
