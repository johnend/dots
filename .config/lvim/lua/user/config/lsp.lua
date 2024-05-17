local lsp_manager = require("lvim.lsp.manager")
lsp_manager.setup("cssmodules_ls", {
  on_attach = function(client, bufnr)
    client.server_capabilities.definitionProvider = false
    require("lvim.lsp").common_on_attach(client, bufnr)
  end,
  capabilities = require("lvim.lsp").common_capabilities(),
  init_options = {
    camelCase = 'dashes',
  },
})

require("lvim.lsp.manager").setup("emmet_ls")
