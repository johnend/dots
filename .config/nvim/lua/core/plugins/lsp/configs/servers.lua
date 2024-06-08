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
}

return servers
