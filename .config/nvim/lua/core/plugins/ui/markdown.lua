return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local status_ok, markdown = pcall(require, "render-markdown")
    if not status_ok then
      print("Error loading plugin: render-markdown", markdown)
      return
    end

    markdown.setup {
      start_enabled = true,
      highlights = {
        code = "RainbowGreen",
      }
    }

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
