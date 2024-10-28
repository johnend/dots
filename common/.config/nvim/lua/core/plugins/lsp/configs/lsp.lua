local M = {}

M.config = function()
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
      map("<leader>cd", require("telescope.builtin").lsp_type_definitions, "Type definition")

      -- Open document symbols in Trouble.
      -- Symbols are things like variables, functions, types, etc.
      map("<leader>cs", ":Trouble symbols toggle focus=false<CR>", "Document symbols")

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

      -- Show LSP info
      map("<leader>r", ":LspRestart<CR>", "Restart LSP Server")

      -- Opens a popup that displays documentation about the word under your cursor
      --  See `:help K` for why this keymap.
      map("K", vim.lsp.buf.hover, "Hover Documentation")

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map("gD", vim.lsp.buf.declaration, "Goto declaration")

      local client = vim.lsp.get_client_by_id(event.data.client_id)

      if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        map("<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, "Inlay Hints")
      end
    end,
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
end

return M
