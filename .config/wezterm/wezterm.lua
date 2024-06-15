local wezterm = require "wezterm"
local theme = require "config.theme"
local window = require "config.window"
local behaviour = require "config.behaviour"
local keys = require "config.keys"

local M = wezterm.config_builder()

wezterm.on("update-right-status", function(window, pane)
  local leader = ""
  if window:leader_is_active() then
    leader = "LEADER"
  end
  window:set_right_status(leader)
end)
theme.apply_to_config(M)
window.apply_to_config(M)
behaviour.apply_to_config(M)
keys.apply_to_config(M)

M.colors.compose_cursor = "orange"

return M
