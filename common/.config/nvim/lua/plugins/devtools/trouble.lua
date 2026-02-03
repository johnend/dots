return {
  "folke/trouble.nvim",
  event = "VeryLazy",
  config = function()
    local status_ok, trouble = pcall(require, "trouble")
    if not status_ok then
      return
    end

    -- TODO: there's probably a bunch of stuff in here that is worth configuring as well as the keymaps for it
    trouble.setup {
      auto_close = false, -- auto close when there are no items
      auto_open = false, -- auto open when there are items
      auto_preview = false, -- automatically open preview when on an item
      auto_refresh = true, -- auto refresh when open
      auto_jump = false, -- auto jump to the item when there's only one
      focus = true, -- Focus the window when opened
      restore = true, -- restores the last location in the list when opening
      follow = true, -- Follow the current item
      indent_guides = true, -- show indent guides
      max_items = 200, -- limit number of items that can be displayed per section
      multiline = true, -- render multi-line messages
      pinned = false, -- When pinned, the opened trouble window will be bound to the current buffer
      warn_no_results = true, -- show a warning when there are no results
      open_no_results = false, -- open the trouble window when there are no results
      ---@type trouble.Window.opts
      win = {
        border = "single",
      }, -- window options for the results window. Can be a split or a floating window.
      -- Window options for the preview window. Can be a split, floating window,
      -- or `main` to show the preview in the main editor window.
      ---@type trouble.Window.opts
      preview = {
        type = "float",
        border = "rounded",
        title = "Preview",
        title_pos = "center",
        size = { width = 0.5, height = 0.5 },
        position = { 0.3, 0.5 },
        -- when a buffer is not yet loaded, the preview window will be created
        -- in a scratch buffer with only syntax highlighting enabled.
        -- Set to false, if you want the preview to always be a real loaded buffer.
        scratch = true,
      },
      -- Throttle/Debounce settings. Should usually not be changed.
      ---@type table<string, number|{ms:number, debounce?:boolean}>
      throttle = {
        refresh = 20, -- fetches new data when needed
        update = 10, -- updates the window
        render = 10, -- renders the window
        follow = 100, -- follows the current item
        preview = { ms = 100, debounce = true }, -- shows the preview for the current item
      },
      -- Key mappings can be set to the name of a builtin action,
      -- or you can define your own custom action.
      ---@type table<string, trouble.Mode>
      modes = {
        -- sources define their own modes, which you can use directly,
        -- or override like in the example below
        lsp_references = {
          -- some modes are configurable, see the source code for more details
          params = {
            include_declaration = true,
          },
        },
        -- The LSP base mode for:
        -- * lsp_definitions, lsp_references, lsp_implementations
        -- * lsp_type_definitions, lsp_declarations, lsp_command
        lsp_base = {
          params = {
            -- don't include the current location in the results
            include_current = false,
          },
        },
        symbols = {
          desc = "document symbols",
          mode = "lsp_document_symbols",
          focus = false,
          win = { position = "right", size = 40 },
          filter = {
            -- remove Package since luals uses it for control flow structures
            ["not"] = { ft = "lua", kind = "Package" },
            any = {
              -- all symbol kinds for help / markdown files
              ft = { "help", "markdown" },
              -- default set of symbol kinds
              kind = {
                "File",
                "Module",
                "Namespace",
                -- "Package",
                "Class",
                "Method",
                "Property",
                "Field",
                "Constructor",
                "Enum",
                "Interface",
                "Function",
                "Variable",
                "Constant",
                "String",
                "Number",
                "Boolean",
                "Array",
                -- "Object",
                "Key",
                "Null",
                "EnumMember",
                "Struct",
                "Event",
                "Operator",
                "TypeParameter",
              },
            },
          },
        },
      },
    }
  end,
}
