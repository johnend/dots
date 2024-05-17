local disabled_filetypes = {
  c = true,
  cpp = true,
}

require("conform").setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = disabled_filetypes
    return {
      timeout_ms = 500,
      lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
    }
  end,
  formatters_by_ft = {
    lua = { "stylua" },
  },
}
