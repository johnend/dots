-- ftplugin/java.lua
-- nvim-jdtls configuration for Java development
-- This file is automatically sourced when opening Java files

local jdtls = require('jdtls')

-- Paths to jdtls installation (using mason)
local jdtls_install = vim.fn.stdpath('data') .. '/mason/packages/jdtls'

-- Find the launcher JAR
local launcher_jar = vim.fn.glob(jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar')
if launcher_jar == '' then
  vim.notify('Could not find equinox launcher jar', vim.log.levels.ERROR)
  return
end

-- Lombok JAR path
local lombok_jar = jdtls_install .. '/lombok.jar'

-- Find the OS-specific configuration
local config_dir = jdtls_install .. '/config_mac'
if vim.fn.has('mac') == 1 then
  if vim.fn.system('uname -m'):match('arm') then
    config_dir = jdtls_install .. '/config_mac_arm'
  end
elseif vim.fn.has('linux') == 1 then
  if vim.fn.system('uname -m'):match('aarch64') then
    config_dir = jdtls_install .. '/config_linux_arm'
  else
    config_dir = jdtls_install .. '/config_linux'
  end
elseif vim.fn.has('win32') == 1 then
  config_dir = jdtls_install .. '/config_win'
end

-- Project-specific workspace directory
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('cache') .. '/jdtls/' .. project_name

-- Create workspace directory if it doesn't exist
vim.fn.mkdir(workspace_dir, 'p')

-- Get capabilities from blink.cmp if available
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, 'blink.cmp')
if ok_cmp then
  capabilities = cmp_lsp.get_lsp_capabilities(capabilities)
end

-- Extended client capabilities for jdtls
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- Full jdtls configuration
local config = {
  -- Build the command manually to include Lombok support
  cmd = {
    'java',
    
    -- JVM options
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '-Xmx2G',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    
    -- CRITICAL: Lombok support (both flags are required)
    -- See: https://github.com/mfussenegger/nvim-jdtls/issues/680
    '-Xbootclasspath/a:' .. lombok_jar,
    '-javaagent:' .. lombok_jar,
    
    -- eclipse.jdt.ls launcher
    '-jar', launcher_jar,
    
    -- Platform configuration
    '-configuration', config_dir,
    
    -- Workspace data
    '-data', workspace_dir,
  },

  -- Identify the root directory of the project
  root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', 'settings.gradle'}),

  -- Server settings
  settings = {
    java = {
      -- Eclipse.jdt.ls specific settings
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      
      -- Configure multiple Java runtimes
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          {
            name = 'JavaSE-21',
            path = vim.fn.expand('~/.asdf/installs/java/corretto-21.0.6.7.1'),
            default = true,
          },
          {
            name = 'JavaSE-11',
            path = vim.fn.expand('~/.asdf/installs/java/temurin-11.0.22+7'),
          },
        },
      },

      -- Code formatting
      format = {
        enabled = true,
        settings = {
          -- Use project-specific formatter or default
          profile = 'GoogleStyle',
        },
      },

      -- Signature help
      signatureHelp = {
        enabled = true,
        description = {
          enabled = true,
        },
      },

      -- Import organization
      sources = {
        organizeImports = {
          starThreshold = 3,
          staticStarThreshold = 3,
        },
      },

      -- Code completion
      completion = {
        favoriteStaticMembers = {
          'org.junit.jupiter.api.Assertions.*',
          'org.junit.jupiter.api.Assumptions.*',
          'org.junit.jupiter.api.DynamicContainer.*',
          'org.junit.jupiter.api.DynamicTest.*',
          'org.mockito.Mockito.*',
          'org.mockito.ArgumentMatchers.*',
          'java.util.Objects.requireNonNull',
          'java.util.Objects.requireNonNullElse',
        },
        filteredTypes = {
          'com.sun.*',
          'sun.*',
          'jdk.*',
        },
        importOrder = {
          'java',
          'javax',
          'com',
          'org',
        },
      },

      -- Code generation
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },

      -- Code lens
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },

      -- Inlay hints
      inlayHints = {
        parameterNames = {
          enabled = 'all',
        },
      },
    },
  },

  -- Initialization options
  init_options = {
    bundles = {},
    extendedClientCapabilities = extendedClientCapabilities,
  },

  -- Client capabilities
  capabilities = capabilities,

  -- Flags for the LSP client
  flags = {
    debounce_text_changes = 150,
    allow_incremental_sync = true,
  },
}

-- Start or attach to the language server
jdtls.start_or_attach(config)
