local mason_packages = vim.fn.stdpath "data" .. "/mason/packages"
local jdtls_path = mason_packages .. "/jdtls"

-- Resolve Java home dynamically: mise sets JAVA_HOME via shell hooks, so that's
-- the authoritative source. Fall back to asking mise directly (handles cases where
-- Neovim was opened without shell hooks, e.g. from a GUI launcher).
local function resolve_java_home()
  local from_env = vim.env.JAVA_HOME
  if from_env and from_env ~= "" then
    return from_env
  end
  local java_bin = vim.fn.system("mise which java 2>/dev/null"):gsub("%s+$", "")
  if java_bin ~= "" and vim.fn.filereadable(java_bin) == 1 then
    return java_bin:gsub("/bin/java$", "")
  end
  vim.notify("ftplugin/java: could not resolve JAVA_HOME from mise", vim.log.levels.WARN)
  return nil
end

local java_home = resolve_java_home()

-- Unique workspace dir per project root to avoid classpath conflicts between projects
local project_root = require("jdtls.setup").find_root { "settings.gradle", "build.gradle", ".git" }
local project_name = vim.fn.fnamemodify(project_root, ":p:h:t")
local workspace_dir = vim.fn.expand "~/.local/share/nvim/jdtls-workspace/" .. project_name

-- Bundles for DAP (java-debug-adapter + java-test)
local bundles = {}
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_packages .. "/java-debug-adapter/extension/server/*.jar"), "\n", { trimempty = true }))
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_packages .. "/java-test/extension/server/*.jar"), "\n", { trimempty = true }))

if not java_home then
  return
end

-- Derive JavaSE-XX name from the actual runtime version for the runtimes config
local java_version = vim.fn.system(java_home .. "/bin/java -XshowSettings:property -version 2>&1"):match "java%.specification%.version = (%S+)"
local java_se_name = java_version and ("JavaSE-" .. java_version) or "JavaSE-21"

require("jdtls").start_or_attach {
  cmd = {
    java_home .. "/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.level=ALL",
    "-Xmx4g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    -- Lombok support: pass jar as javaagent so annotations resolve correctly
    "-javaagent:" .. jdtls_path .. "/lombok.jar",
    "-jar", vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", jdtls_path .. "/config_mac_arm",
    "-data", workspace_dir,
  },

  root_dir = project_root,

  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = java_se_name,
            path = java_home,
            default = true,
          },
        },
      },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = false },
      format = { enabled = false }, -- formatting handled by conform (google-java-format)
      -- Annotation processing required for Lombok to work in the LSP
      autobuild = { enabled = true },
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.junit.Assert.*",
        "org.junit.Assume.*",
        "org.junit.jupiter.api.Assertions.*",
        "org.junit.jupiter.api.Assumptions.*",
        "org.mockito.Mockito.*",
        "org.mockito.ArgumentMatchers.*",
      },
    },
  },

  init_options = {
    bundles = bundles,
    extendedClientCapabilities = require("jdtls").extendedClientCapabilities,
  },

  capabilities = require("blink.cmp").get_lsp_capabilities(),

  on_attach = function(_, bufnr)
    -- Enable DAP once jdtls is attached
    require("jdtls").setup_dap { hotcodereplace = "auto" }
    require("jdtls.dap").setup_dap_main_class_configs()
  end,
}
