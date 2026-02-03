return {
  "nvim-treesitter/nvim-treesitter",
  enabled = true,
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- Auto-enable treesitter highlighting for installed parsers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(args)
        -- Only start if a parser exists for this filetype
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
