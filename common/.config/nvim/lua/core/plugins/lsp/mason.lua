local servers = require "core.plugins.lsp.configs.servers"
return {
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    config = function()
      local status_ok, masonlsp = pcall(require, "mason-lspconfig")
      if not status_ok then
        return
      end

      local capabilties = vim.lsp.protocol.make_client_capabilities()
      ---@diagnostic disable-next-line: lowercase-global
      capabilities = vim.tbl_deep_extend("force", capabilties, require("cmp_nvim_lsp").default_capabilities())

      masonlsp.setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}

            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      }
    end,
    dependencies = {
      "williamboman/mason.nvim",
      config = function()
        local status_ok, mason = pcall(require, "mason")
        if not status_ok then
          return
        end

        mason.setup {
          ui = {
            border = "rounded",
          },
        }
      end,
      dependencies = {
        {
          "WhoIsSethDaniel/mason-tool-installer.nvim",
          event = "VeryLazy",
          config = function()
            local status_ok, masontools = pcall(require, "mason-tool-installer")
            if not status_ok then
              return
            end

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
              -------------------------
              -- LSPs
              -------------------------
              "bash-language-server",
              "css-lsp",
              "cssmodules-language-server",
              "css-variables-language-server",
              "emmet-language-server",
              "graphql",
              "helm-ls",
              "html-lsp",
              "json-lsp",
              "lua-language-server",
              "prettier",
              "prettierd",
              "pyright",
              "some-sass-language-server",
              "stylua",
              -- "ts_ls", # this can be useful but is much slower than vtsls
              "vtsls",
              "yaml-language-server",
              -------------------------
              -- DAPs
              -------------------------
              "codelldb",
              -------------------------
              -- Linters
              -------------------------
              "eslint_d",
              "sonarlint-language-server",
              "shellcheck",
            })
            masontools.setup { ensure_installed = ensure_installed }
          end,
        },
      },
    },
  },
}
