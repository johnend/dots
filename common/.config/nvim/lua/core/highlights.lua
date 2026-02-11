-- core/highlights.lua
-- Custom highlight overrides and fixes

local M = {}

-- Remove underlines from which-key icons
-- This runs after which-key's ColorScheme autocmd to fix icon highlights
function M.setup_whichkey_fixes()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("FixWhichKeyIconUnderlines", { clear = true }),
    callback = function()
      -- Defer to run AFTER which-key's fix_colors()
      vim.defer_fn(function()
        local icon_groups = {
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

        for _, group in ipairs(icon_groups) do
          -- Get the current highlight (after which-key's fix_colors)
          local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
          if hl and next(hl) ~= nil then
            -- Remove underline while preserving everything else
            hl.underline = nil
            vim.api.nvim_set_hl(0, group, hl)
          end
        end
      end, 50)
    end,
  })
end

function M.setup()
  M.setup_whichkey_fixes()
  -- Add more custom highlight fixes here in the future
end

return M
