return {
  "stevearc/conform.nvim",
  lazy = "BufWritePre",
  cmd = "ConformInfo",
  config = function()
    local status_ok, conform = pcall(require, "conform")
    if not status_ok then
      return
    end

    local disabled_filetypes = {
      c = true,
      cpp = true,
    }

    conform.setup {
      notify_on_error = false,
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        scss = { { "prettierd", "prettier" } },
      },
    }
  end,
}
