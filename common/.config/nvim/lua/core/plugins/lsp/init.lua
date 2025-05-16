return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- mason.nvim will be set up with opts = {}
    { "mason-org/mason.nvim", opts = {
      ui = {
        border = "rounded",
      },
    } },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "saghen/blink.cmp",
    "b0o/schemastore.nvim",
  },
  config = function()
    local schemastore = require "schemastore"
    -- 1) Define the servers we actually want, and any special settings
    local servers = {
      bashls = {},
      cssls = {},
      css_variables = {},
      cssmodules_ls = {},
      emmet_language_server = {},
      eslint = {},
      graphql = {},
      helm_ls = {},
      html = {},
      jsonls = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = schemastore.json.schemas(),
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = { disable = { "missing-fields" } }, -- fix: use '=' not '-'
          },
        },
      },
      pyright = {},
      somesass_ls = {},
      terraformls = {},
      tflint = {},
      vtsls = {
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = schemastore.yaml.schemas(),
          },
        },
      },
      yamlls = {},
      -- add other servers here, e.g. pyright = {}, tsserver = {}, etc.
    }

    local formatters = { "stylua", "prettier", "prettierd" }
    -- local dap = { "js-debug-adapter", "codelldb" } -- table for formatters

    -- 2) Turn Blink into LSP-capabilities for cmp
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- 3) Ensure mason-tool-installer actually installs the right binaries
    local ensure_tools = vim.tbl_keys(servers) -- e.g. { "lua_ls" }

    vim.list_extend(ensure_tools, formatters) -- add stylua as a formatter
    -- vim.list_extend(ensure_tools, dap) -- uncomment to add dap tooling
    require("mason-tool-installer").setup {
      ensure_installed = ensure_tools,
    }

    -- 4) Configure mason-lspconfig to install & wire up our LSPs
    require("mason-lspconfig").setup {
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = true,
      automatic_enable = true,
      handlers = {
        -- default handler (will be called for each server_name)
        function(server_name)
          local opts = vim.tbl_deep_extend("force", { capabilities = capabilities }, servers[server_name] or {})
          require("lspconfig")[server_name].setup(opts)
        end,
      },
    }

    ------------------------------------------------

    local sign_keys = {
      Error = "Error",
      Warning = "Warn",
      Information = "Info",
      Hint = "Hint",
    }

    for long, short in pairs(sign_keys) do
      local icon = icons.diagnostics[long]
      local hl = "DiagnosticSign" .. short
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- diagnostics styling
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.WARN },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
          [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
          [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
          [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
        },
      } or {},
      virtual_text = false,
    }

    -- 5) Finally, set up our LspAttach autocmd for keymaps & highlights
    local group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
      group = group,
      callback = function(event)
        -- helper for buffer-local mappings
        local function map(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- your mappings…
        map("gO", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
        map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
        map("grD", vim.lsp.buf.declaration, "Declaration")
        map("gra", require("actions-preview").code_actions, "Code Action")
        map("grd", require("telescope.builtin").lsp_definitions, "Definitions")
        map("gre", vim.diagnostic.open_float, "Open Diagnostic Float", { "n", "x" })
        map("gri", require("telescope.builtin").lsp_implementations, "Implementations")
        map("grj", function()
          vim.diagnostic.jump { count = 1 }
        end, "Next diagnostic", { "n", "x" })
        map("grk", function()
          vim.diagnostic.jump { count = -1 }
        end, "Previous diagnostic", { "n", "x" })
        map("grl", vim.diagnostic.setloclist, "Diagnostic loclist", { "n", "x" })
        map("grn", vim.lsp.buf.rename, "Rename")
        map("grr", require("telescope.builtin").lsp_references, "References")
        map("grt", require("telescope.builtin").lsp_type_definitions, "Type Definitions")

        -- highlight on CursorHold, clear on move
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method "textDocument/documentHighlight" then
          local hl_grp = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = hl_grp,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = hl_grp,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = hl_grp,
            buffer = event.buf,
            callback = function(ev2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = ev2.buf }
            end,
          })
        end
      end,
    })
  end,
}
