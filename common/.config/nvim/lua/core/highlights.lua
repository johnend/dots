-- Noice highlights (cmdline popup border)
vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { link = "NormalFloat" })

-- Terminal (toggleterm)
vim.api.nvim_set_hl(0, "TermCursor", { fg = colors.mantle, bg = "#D20F39" })

-- Treesitter context separator
vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { link = "LineNr" })

-- Flash label (search highlight)
vim.api.nvim_set_hl(0, "FlashLabel", { link = "Search" })

vim.cmd [[
  augroup CustomHighlights
    autocmd!
    autocmd ColorScheme * lua require('core.highlights')  -- Adjust to where your highlight code is
  augroup END
]]
