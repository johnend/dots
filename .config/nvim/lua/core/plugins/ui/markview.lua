return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- Recommended
  -- ft = "markdown" -- If you decide to lazy-load anyway

  dependencies = {
    -- You will not need this if you installed the
    -- parsers manually
    -- Or if the parsers are in your $RUNTIMEPATH
    "nvim-treesitter/nvim-treesitter",

    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.api.nvim_create_autocmd("BufWinLeave", {
      pattern = "*.md",
      callback = function()
        vim.opt.colorcolumn = "120"
        vim.opt.textwidth = 120
      end,
    })

    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "*.md",
      callback = function()
        vim.opt.colorcolumn = "80"
        vim.opt.textwidth = 80
      end,
    })
  end,
}
