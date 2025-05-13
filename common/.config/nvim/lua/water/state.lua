-- lua/water/state.lua
---@class water.state
---Global state for the Water UI, tracking buffer, window, and rendering options.
---@field water_bufnr number? Buffer number of the active Water UI buffer, or nil if closed.
---@field last_buf number? Buffer number of the buffer active before opening Water UI.
---@field water_winid number? Window ID displaying the Water UI, or nil if none.
---@field options table? The rendering options in use for the Water UI, or nil if not set.
local M = {
  water_bufnr = nil,
  last_buf = nil,
  water_winid = nil,
  options = nil,
  preview_on_cursor = false,
}

return M
