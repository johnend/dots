-- UI highlight policies for transparency.
local M = {}

M.default = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "Pmenu",
  "Terminal",
  "EndOfBuffer",
  "FoldColumn",
  "Folded",
  "SignColumn",
  "NeoTreeNormal",
  "NeoTreeNormalNC",
  "NeoTreeVertSplit",
  "NeoTreeWinSeparator",
  "NeoTreeEndOfBuffer",
}

M.preserve_fg_highlights = {
  -- These groups preserve foreground/style and only get transparent background
  -- when they already define one. This avoids clobbering link-derived fg colors.
  "GitSignsAdd",
  "GitSignsChange",
  "GitSignsDelete",
  "GitSignsChangedelete",
  "GitSignsTopdelete",
  "GitSignsUntracked",
  "GitSignsAddNr",
  "GitSignsChangeNr",
  "GitSignsDeleteNr",
  "GitSignsChangedeleteNr",
  "GitSignsTopdeleteNr",
  "GitSignsUntrackedNr",
  "GitSignsAddLn",
  "GitSignsChangeLn",
  "GitSignsChangedeleteLn",
  "GitSignsTopdeleteLn",
  "GitSignsUntrackedLn",
  "GitSignsAddCul",
  "GitSignsChangeCul",
  "GitSignsDeleteCul",
  "GitSignsChangedeleteCul",
  "GitSignsTopdeleteCul",
  "GitSignsUntrackedCul",
  "GitSignsStagedAdd",
  "GitSignsStagedChange",
  "GitSignsStagedDelete",
  "GitSignsStagedChangedelete",
  "GitSignsStagedTopdelete",
  "GitSignsStagedUntracked",
  "GitSignsStagedAddNr",
  "GitSignsStagedChangeNr",
  "GitSignsStagedDeleteNr",
  "GitSignsStagedChangedeleteNr",
  "GitSignsStagedTopdeleteNr",
  "GitSignsStagedUntrackedNr",
  "GitSignsStagedAddLn",
  "GitSignsStagedChangeLn",
  "GitSignsStagedChangedeleteLn",
  "GitSignsStagedTopdeleteLn",
  "GitSignsStagedUntrackedLn",
  "GitSignsStagedAddCul",
  "GitSignsStagedChangeCul",
  "GitSignsStagedDeleteCul",
  "GitSignsStagedChangedeleteCul",
  "GitSignsStagedTopdeleteCul",
  "GitSignsStagedUntrackedCul",
  "GitSignsAddPreview",
  "GitSignsDeletePreview",
  "GitSignsNoEOLPreview",
  "GitSignsCurrentLineBlame",
  "GitSignsAddInline",
  "GitSignsDeleteInline",
  "GitSignsChangeInline",
  "GitSignsAddLnInline",
  "GitSignsChangeLnInline",
  "GitSignsDeleteLnInline",
  "GitSignsDeleteVirtLn",
  "GitSignsDeleteVirtLnInLine",
  "GitSignsVirtLnum",
}

function M.apply_transparency_highlights()
  for _, highlight in ipairs(M.default) do
    vim.api.nvim_set_hl(0, highlight, { bg = "none" })
  end

  for _, highlight in ipairs(M.preserve_fg_highlights) do
    local current = vim.api.nvim_get_hl(0, { name = highlight, link = false })
    if current and next(current) ~= nil and current.bg ~= nil then
      local next_hl = vim.tbl_extend("force", {}, current, { bg = "none" })
      vim.api.nvim_set_hl(0, highlight, next_hl)
    end
  end
end

return M
