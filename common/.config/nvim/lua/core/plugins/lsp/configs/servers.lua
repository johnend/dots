--[[
--
--  ██╗     ███████╗██████╗     ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗ ███████╗
--  ██║     ██╔════╝██╔══██╗    ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗██╔════╝
--  ██║     ███████╗██████╔╝    ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝███████╗
--  ██║     ╚════██║██╔═══╝     ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗╚════██║
--  ███████╗███████║██║         ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║███████║
--  ╚══════╝╚══════╝╚═╝         ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚══════╝
--
--]]

local schemastore = require "schemastore"

local servers = {
  -----------------------------------------------------------------------------
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = { disable = { "missing-fields" } },
      },
    },
  },
  -----------------------------------------------------------------------------
  jsonls = {
    settings = {
      json = {
        schemas = schemastore.json.schemas(),
        validate = { enable = true },
      },
    },
  },
  -----------------------------------------------------------------------------
  yamlls = {
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = schemastore.yaml.schemas(),
        validate = { enable = true },
      },
    },
  },
  -----------------------------------------------------------------------------
  cssmodules_ls = {
    on_attach = function(client)
      client.server_capabilities.definitionProvider = false
    end,
  },
  -----------------------------------------------------------------------------
  cssls = {
    filetypes = { "css", "scss", "less" },
    on_attach = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
    end,
  },
  -----------------------------------------------------------------------------
  -- rust_analyzer = { function() end },
  -----------------------------------------------------------------------------
  graphql = {
    filetypes = { "graphql", "typescriptreact", "javascriptreact", "typescript", "javascript" },
    root_dir = require("lspconfig.util").root_pattern("graphql.config.*", ".git"),
  },
}

return servers
