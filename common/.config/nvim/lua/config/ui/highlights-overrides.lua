-- UI highlight overrides that are not purely transparency policy.
local M = {}

M.whichkey_icon_groups = {
  "WhichKeyIcon",
  "WhichKeyIconAzure",
  "WhichKeyIconBlue",
  "WhichKeyIconCyan",
  "WhichKeyIconGreen",
  "WhichKeyIconGrey",
  "WhichKeyIconOrange",
  "WhichKeyIconPurple",
  "WhichKeyIconRed",
  "WhichKeyIconYellow",
}

---@param transparent boolean
function M.fix_whichkey_icon_highlights(transparent)
  for _, group in ipairs(M.whichkey_icon_groups) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    if hl and next(hl) ~= nil then
      hl.underline = nil
      if transparent then
        hl.bg = nil
      end
      vim.api.nvim_set_hl(0, group, hl)
    end
  end
end

function M.setup_whichkey_fixes()
  vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    group = vim.api.nvim_create_augroup("FixWhichKeyIconUnderlines", { clear = true }),
    callback = function()
      -- Run after which-key's own ColorScheme handler (wk-colors).
      vim.defer_fn(function()
        local transparent = require("core.colorscheme").load().transparent
        M.fix_whichkey_icon_highlights(transparent)
      end, 50)
    end,
  })
end

return M
