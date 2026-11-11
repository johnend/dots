-- Parsers nvim-treesitter dropped because upstream stopped committing generated
-- src/parser.c. The grammars are still maintained and ship Neovim queries, so we
-- build them from grammar.js (needs the tree-sitter CLI and Node). Pinned to
-- release tag commits because upstream rewrites history on main.
local CUSTOM_PARSERS = {
  tmux = {
    url = "https://github.com/Freed-Wu/tree-sitter-tmux",
    revision = "bd334851188206824595987350c0bfb60ff76f75", -- 0.1.4
  },
  zathurarc = {
    url = "https://github.com/Freed-Wu/tree-sitter-zathurarc",
    revision = "23588658bfaa76e06e18eaf11bc547c06eb69484", -- 0.1.7
  },
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  enabled = true,
  lazy = false,
  build = ":TSUpdate",
  init = function()
    -- Registered in init so it exists before lazy's build step runs :TSUpdate
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        local parsers = require "nvim-treesitter.parsers"
        for lang, source in pairs(CUSTOM_PARSERS) do
          parsers[lang] = {
            install_info = {
              url = source.url,
              revision = source.revision,
              generate = true,
              generate_from_json = false,
              queries = "queries",
            },
          }
        end
      end,
    })
  end,
  config = function()
    -- Auto-enable treesitter highlighting for installed parsers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end
        -- A parser without highlight queries (e.g. one orphaned when upstream drops
        -- it) would still start and clear regex syntax, leaving the buffer
        -- unhighlighted. Keep Vim syntax in that case.
        local has_query, query = pcall(vim.treesitter.query.get, lang, "highlights")
        if not has_query or not query then
          return
        end
        pcall(vim.treesitter.start, args.buf, lang)
      end,
    })
  end,
}
