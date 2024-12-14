return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "VeryLazy",
  config = function()
    local status_ok, tscontext = pcall(require, "treesitter-context")
    if not status_ok then
      return
    end

    tscontext.setup {
      enable = false,
      multiwindow = false,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = "─",
      zindex = 20,
      on_attach = nil,
    }
  end,
  vim.keymap.set("n", "<leader>to", ":TSContextToggle<cr>", { desc = "Treesitter context" }),
}
