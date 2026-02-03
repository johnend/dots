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
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
    }
  end,

  -- Register user commands to enable/disable formatting
  vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
      -- FormatDisable! will disable formatting just for this buffer
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
  end, {
    desc = "Disable autoformat-on-save",
    bang = true,
  }),

  vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
  end, {
    desc = "Re-enable autoformat-on-save",
  }),

  vim.api.nvim_create_user_command("FormatToggle", function()
    local buf_disabled = vim.b.disable_autoformat
    local global_disabled = vim.g.disable_autoformat

    if buf_disabled or global_disabled then
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
      vim.notify("Format on save enabled", 2, {
        timeout = 1000,
        id = "auto_format_status",
        title = "Conform Status",
        icon = Icons.diagnostics.Information,
      })
    else
      vim.b.disable_autoformat = true
      vim.g.disable_autoformat = true
      vim.notify("Format on save disabled", 4, {
        timeout = 1000,
        id = "auto_format_status",
        title = "Conform Status",
        icon = Icons.diagnostics.BoldError,
      })
    end
  end, {
    desc = "Toggle autoformat-on-save with notification",
  }),
}
