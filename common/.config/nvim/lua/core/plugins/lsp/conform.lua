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
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        graphql = { "prettierd", "prettier", stop_after_first = true },
      },
    }

    vim.api.nvim_create_user_command("ToggleFormat", function()
      vim.notify = require "notify"
      if vim.b.disable_autoformat then
        vim.b.disable_autoformat = false
        vim.notify "Auto format on save enabled for this buffer"
      else
        vim.b.disable_autoformat = true
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.notify("Auto format on save disabled for this buffer", "warn")
      end
    end, {
      desc = "Toggle auto format on save - buffer",
    })
  end,
}
