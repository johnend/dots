return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "mason-org/mason.nvim", cmd = { "Mason" }, opts = { ui = { border = UI.border } } },
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp",
    "b0o/schemastore.nvim",
  },
  config = function()
    --------------------------------------
    --- Setup servers and capabilities ---
    --------------------------------------
    local servers = require "config.lsp.servers"
    local formatters = { "stylua", "prettier", "prettierd" }
    -- local dap = {"js-debug-adapter", "codelldb"} -- uncomment to include daps
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    local ensure_tools = vim.tbl_keys(servers)

    vim.list_extend(ensure_tools, formatters)

    require("mason-lspconfig").setup {
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = true,
      automatic_enable = true,
      handlers = {
        function(server_name)
          local opts = vim.tbl_deep_extend("force", { capabilities = capabilities }, servers[server_name] or {})
          require("lspconfig")[server_name].setup(opts)
        end,
      },
    }

    -----------------------------------------------
    --- Use nicer looking icons for diagnostics ---
    -----------------------------------------------
    local sign_keys = {
      Error = "Error",
      Warning = "Warn",
      Information = "Info",
      Hint = "Hint",
    }

    for long, short in pairs(sign_keys) do
      local icon = Icons.diagnostics[long]
      local hl = "DiagnosticSign" .. short
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    vim.diagnostic.config {
      severity_sort = true,
      float = { border = UI.border, source = "if_many" },
      underline = { severity = vim.diagnostic.severity.WARN },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = Icons.diagnostics.Error,
          [vim.diagnostic.severity.WARN] = Icons.diagnostics.Warning,
          [vim.diagnostic.severity.INFO] = Icons.diagnostics.Information,
          [vim.diagnostic.severity.HINT] = Icons.diagnostics.Hint,
        },
      } or {},
      virtual_text = false,
    }

    ----------------------------------------------------------
    --- Set up LspAttch autocmd for keymaps and highlights ---
    ----------------------------------------------------------
    local group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
      group = group,
      callback = function(event)
        local function map(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
        end

        --- Add LSP keymaps here

        ----------------------------------------------
        --- Highlight on CursorHold, clear on move ---
        ----------------------------------------------
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method "textDocument/documentHighlight" then
          local hl_grp = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = hl_grp,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMoved" }, {
            buffer = event.buf,
            group = hl_grp,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            buffer = event.buf,
            group = hl_grp,
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = event2.buf }
            end,
          })
        end
      end,
    })
  end,
}
