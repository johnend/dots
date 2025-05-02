-- lua/water/highlights.lua
---@class water.highlights

local M = {}

---Define custom highlight groups for the Water UI.
---Links groups to existing highlight definitions, applied by default.
function M.define()
  ---Alias for setting highlight groups
  ---@type fun(namespace: number, name: string, opts: table)
  local highlight = vim.api.nvim_set_hl

  -- Buffer ID number styling
  highlight(0, "WaterBufferID", { link = "@comment", default = true })
  -- Buffer name styling
  highlight(0, "WaterBufferName", { link = "@text", default = true })
  -- Diagnostic error icon styling
  highlight(0, "WaterDiagnosticError", { link = "DiagnosticError", default = true })
  -- Diagnostic warning icon styling
  highlight(0, "WaterDiagnosticWarn", { link = "DiagnosticWarn", default = true })
  -- Timestamp text styling
  highlight(0, "WaterTimestamp", { link = "@comment", default = true })
end

return M
