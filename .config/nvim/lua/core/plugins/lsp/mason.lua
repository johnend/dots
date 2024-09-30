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
      event = "VeryLazy",
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
              "bash-language-server",
              "css-lsp",
              "cssmodules-language-server",
              "css-variables-language-server",
              "emmet-language-server",
              "eslint_d",
              "helm-ls",
              "html-lsp",
              "json-lsp",
              "lua-language-server",
              "prettier",
              "prettierd",
              "pyright",
              "shellcheck",
              "sonarlint-language-server",
              "some-sass-language-server",
              "stylua",
              "vtsls",
              -- typscript language server has been renamed, check Mason if you want to install
              "yaml-language-server",
              "rust-analyzer",
            })
            masontools.setup { ensure_installed = ensure_installed }
          end,
        },
      },
    },
  },
}
