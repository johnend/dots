local schemastore = require "schemastore"

return {
  bashls = {},
  cssls = {},
  css_variables = {},
  cssmodules_ls = {},
  emmet_language_server = {},
  eslint = {
    setting = {
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = "separateLine",
        },
        showDocumentation = {
          enable = true,
        },
      },
    },
  },
  graphql = {},
  helm_ls = {},
  html = {},
  jsonls = {
    settings = {
      json = {
        validate = { enable = true },
        schemas = vim.list_extend({
          {
            description = "Lua language server config file",
            filematch = { ".luarc.json" },
            url = "https://raw.githubusercontent.com/LuaLS/vscode-lua/master/settings/schema.json",
          },
        }, schemastore.json.schemas()),
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = "Replace" },
        diagnostics = { disable = { "missing-fields" } },
      },
    },
  },
  pyright = {},
  somesass_ls = {},
  stylua = {},
  terraformls = {},
  tflint = {},
  vtsls = {
    settings = {
      typescript = {
        preferences = {
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
          importModuleSpecifierPreference = "non-relative",
          quotePreference = "auto",
          allowTextChangesInNewFile = true,
          provideRefactorNotApplicableReason = true,
        },
        suggest = {
          autoImports = true,
          completeFunctionCalls = true,
          paths = true,
        },
      },
      javascript = {
        preferences = {
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
          importModuleSpecifierPreference = "non-relative",
          quotePreference = "auto",
        },
        suggest = {
          autoImports = true,
          completeFunctionCalls = true,
          paths = true,
        },
      },
    },
  },
  yamlls = {
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
}
