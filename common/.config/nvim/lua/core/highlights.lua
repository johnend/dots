-- core/highlights.lua
-- Custom highlight overrides and fixes

local M = {}

---Remove underlines from which-key icons
function M.setup_whichkey_fixes()
  require("config.ui.highlights-overrides").setup_whichkey_fixes()
end

---Fix highlights across colorschemes in a consistent way by linking to existing highlight groups
---Should be careful working with these, as they're global
---Colorschemes that apply highlights different for visual style should be considered
function M.fix_highlights()
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("FixHighlights", { clear = true }),
    callback = function()
      ---Link an existing highlight (from pluging etc.) to a pre-existing highlight group
      ---@param initialName string
      ---@param linkName string
      local override = function(initialName, linkName)
        vim.api.nvim_set_hl(0, initialName, { link = linkName, default = true })
      end

      override("TreesitterContextSeparator", "Comment")
    end,
  })
end

function M.setup()
  M.setup_whichkey_fixes()
  M.fix_highlights()
  -- Add more custom highlight fixes here in the future
end

return M
