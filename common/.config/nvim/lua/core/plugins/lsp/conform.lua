return {
  "stevearc/conform.nvim",
  event = { "BufWritePre", "BufWinEnter", "BufNewFile" },

  cmd = "ConformInfo",
  config = function()
    local status_ok, conform = pcall(require, "conform")
    if not status_ok then
      return
    end

    -- [[ Auto formatting ]]
    vim.keymap.set("n", "<leader>f", function()
      require("conform").format { async = true, lsp_fallback = true }
    end, { desc = "Format buffer" })

    conform.setup {
      notify_on_error = false,
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
      },
    }
  end,
}
