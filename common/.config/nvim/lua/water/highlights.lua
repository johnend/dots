local M = {}

function M.define()
  local highlight = vim.api.nvim_set_hl

  highlight(0, "WaterBufferID", { link = "@comment", default = true })
  highlight(0, "WaterBufferName", { link = "@text", default = true })
  highlight(0, "WaterDiagnosticError", { link = "DiagnosticError", default = true })
  highlight(0, "WaterDiagnosticWarn", { link = "DiagnosticWarn", default = true })
  highlight(0, "WaterTimestamp", { link = "@comment", default = true })
end

return M
