-- LSP server configurations
-- Each server's configuration is defined here and imported by the main LSP setup
local schemastore = require "schemastore"

return {
  ---------------------------------------
  bashls = {},
  ---------------------------------------
  cssls = {},
  ---------------------------------------
  css_variables = {},
  ---------------------------------------
  cssmodules_ls = {},
  ---------------------------------------
  emmet_language_server = {},
  ---------------------------------------
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
  ---------------------------------------
  graphql = {},
  ---------------------------------------
  helm_ls = {},
  ---------------------------------------
  html = {},
  ---------------------------------------
  jdtls = {
    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "-Dlombok.config=" .. (vim.fs.find("lombok.config", { upward = true })[1] or ""),
      "-javaagent:/Users/john.enderby/.gradle/caches/modules-2/files-2.1/org.projectlombok/lombok/1.18.34/ec547ef414ab1d2c040118fb9c1c265ada63af14/lombok-1.18.34.jar",
      "-jar",
      "/Users/john.enderby/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.0.v20250519-0528.jar",
      "-configuration",
      "/Users/john.enderby/.local/share/nvim/mason/packages/jdtls/config_mac_arm",
      "-data",
      "/Users/john.enderby/Developer/lsp/jdtls_data/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
    },
    root_dir = function(startpath)
      return vim.fs.dirname(vim.fs.find(".git", { path = startpath, upward = true })[1])
    end,
    settings = {
      java = {
        configuration = {
          detectJdksAtStart = false,
          updateBuildConfiguration = "interactive",
          runtimes = {
            {
              name = "JavaSE-21",
              path = "/Users/john.enderby/.asdf/installs/java/corretto-21.0.6.7.1",
              default = true,
            },
            {
              name = "JavaSE-11",
              path = "/Users/john.enderby/.asdf/installs/java/temurin-11.0.22+7",
            },
          },
        },
        compile = {
          nullAnalysis = {
            mode = "automatic",
          },
        },
        autobuild = {
          enabled = false,
        },
        maxConcurrentBuilds = 1,
        eclipse = {
          downloadSources = true,
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        format = {
          enabled = true,
        },
        project = {
          outputPath = "bin",
        },
        completion = {
          favoriteStaticMembers = {
            "org.assertj.core.api.Assertions.*",
            "org.junit.jupiter.api.Assertions.*",
            "org.mockito.Mockito.*",
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 99,
            staticStarThreshold = 99,
          },
        },
        flags = {
          allow_incremental_sync = true,
          server_side_fuzzy_completion = true,
        },
      },
    },
    init_options = {
      bundles = {
        "/Users/john.enderby/.gradle/caches/modules-2/files-2.1/org.projectlombok/lombok/1.18.34/ec547ef414ab1d2c040118fb9c1c265ada63af14/lombok-1.18.34.jar",
      },
      extendedClientCapabilities = {
        progressReportsSupport = true,
        classFileContentsSupport = true,
        generateToStringPromptSupport = true,
        hashCodeEqualsPromptSupport = true,
        advancedExtractRefactoringSupport = true,
        advancedOrganizeImportsSupport = true,
        clientHoverProvider = true,
        clientDocumentSymbolProvider = true,
        gradleChecksumWrapperPromptSupport = true,
        resolveAdditionalTextEditsSupport = true,
        moveRefactoringSupport = true,
      },
      settings = {
        ["java.configuration.checkProjectSettings"] = false,
        ["java.project.referencedLibraries"] = {},
      },
    },
  },
  ---------------------------------------
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
  ---------------------------------------
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = "Replace" },
        diagnostics = { disable = { "missing-fields" } },
      },
    },
  },
  ---------------------------------------
  pyright = {},
  ---------------------------------------
  somesass_ls = {},
  ---------------------------------------
  terraformls = {},
  ---------------------------------------
  tflint = {},
  ---------------------------------------
  vtsls = {
    settings = {
      typescript = {
        preferences = {
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
          importModuleSpecifier = "non-relative",
          quotePreference = "auto", -- Automatically adjust quotes
          allowTextChangesInNewFiles = true, -- Allow refactoring in new files
          provideRefactorNotApplicableReason = true, -- Show why a refactor is unavailable
        },
        suggest = {
          autoImports = true,
          completeFunctionCalls = true,
        },
        tsconfig = {
          enableProjectWideIntellisense = true, -- Ensure project-wide alias resolution
        },
      },
    },
  },
  ---------------------------------------
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
