--  ██╗     ███████╗██████╗      ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
--  ██║     ██╔════╝██╔══██╗    ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
--  ██║     ███████╗██████╔╝    ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
--  ██║     ╚════██║██╔═══╝     ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
--  ███████╗███████║██║         ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
--  ╚══════╝╚══════╝╚═╝          ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
--
--]]

require "core.lsp.config.styling"
require "lspconfig"

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
    end

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map("gd", require("telescope.builtin").lsp_definitions, "Goto definition")

    -- Find references for the word under your cursor.
    map("gr", require("telescope.builtin").lsp_references, "Goto references")

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map("gI", require("telescope.builtin").lsp_implementations, "Goto implementation")

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type definition")

    -- Open document symbols in Trouble.
    -- Symbols are things like variables, functions, types, etc.
    map("<leader>cd", ":Trouble symbols toggle focus=false<CR>", "Document symbols")

    map("<leader>cl", ":Trouble lsp toggle focus=false<CR>", "LSP toggle (Trouble)")
    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map("<leader>cw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace symbols")

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map("<leader>cr", vim.lsp.buf.rename, "Rename")

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map("<leader>ca", require("actions-preview").code_actions, "Code action")

    -- Show LSP info
    map("<leader>ci", ":LspInfo<CR>", "LSP info")
    -- Opens a popup that displays documentation about the word under your cursor
    --  See `:help K` for why this keymap.
    map("K", vim.lsp.buf.hover, "Hover Documentation")

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map("gD", vim.lsp.buf.declaration, "Goto declaration")

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup("quantum-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("quantum-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = "quantum-lsp-highlight", buffer = event2.buf }
        end,
      })
    end

    -- The following autocommand is used to enable inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, "Toggle inlay hints")
    end
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

local servers = require "core.lsp.config.servers"

require("mason").setup(require "core.lsp.config.mason")

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  "stylua", -- used to format Lua code
})

require("mason-tool-installer").setup { ensure_installed = ensure_installed }

require("mason-lspconfig").setup {
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}

      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      require("lspconfig")[server_name].setup(server)
    end,
  },
}
