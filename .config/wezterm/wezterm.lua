local wezterm = require "wezterm"
local theme = require "config.theme"
local window = require "config.window"
local behaviour = require "config.behaviour"
local layouts = require "config.layouts"
local keys = require "config.keys"

local M = wezterm.config_builder()

theme.apply_to_config(M)
window.apply_to_config(M)
behaviour.apply_to_config(M)
keys.apply_to_config(M)

M.colors.compose_cursor = "orange"

wezterm.on("update-right-status", function(window, pane)
  local leader = ""
  if window:leader_is_active() then
    leader = "LEADER"
  end
  window:set_right_status(leader)
end)

wezterm.on("setup_custom_layout", function(window, pane, name, value)
  print "Custom layout event triggered"
  layouts.setup_layout()
end)

return M
