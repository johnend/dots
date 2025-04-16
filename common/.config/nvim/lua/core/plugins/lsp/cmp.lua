return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-emoji" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "saadparwaiz1/cmp_luasnip" },
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp",
      dependencies = {
        "rafamadriz/friendly-snippets",
      },
      opts = function()
        local types = require "luasnip.util.types"
        return {
          ext_opts = {
            [types.insertNode] = {
              unvisited = {
                virt_text = { { "|", "Conceal" } },
                virt_text_pos = "inline",
              },
            },

            [types.exitNode] = {
              unvisited = {
                virt_text = { { "|", "Conceal" } },
                virt_text_pos = "inline",
              },
            },
          },
        }
      end,
      config = function(_, opts)
        local luasnip = require "luasnip"
        luasnip.setup(opts)

        vim.api.nvim_create_autocmd("ModeChanged", {
          group = vim.api.nvim_create_augroup("quantumvim/unlink-snippet", { clear = true }),
          desc = "Cancel snippet selection when leaving insert mode",
          pattern = { "s:n", "i:*" },
          callback = function()
            local ok, _ = pcall(function()
              local current_buf = vim.api.nvim_get_current_buf()
              if
                luasnip.session
                and luasnip.session.current_nodes
                and luasnip.session.current_nodes[current_buf]
                and not luasnip.session.jump_active
                and not luasnip.choice_active()
              then
                luasnip.unlink_current()
              end
            end)
          end,
        })
      end,
    },
    { "hrsh7th/cmp-nvim-lua", event = "InsertEnter" },
    -- { "mmolhoek/cmp-scss", event = "InsertEnter" },
  },

  config = function()
    local status_ok, cmp = pcall(require, "cmp")
    if not status_ok then
      return
    end

    local snip_status_ok, luasnip = pcall(require, "luasnip")
    if not snip_status_ok then
      return
    end

    require("luasnip/loaders/from_vscode").lazy_load()

    local kind_icons = {
      Text = "󰊄",
      Method = "m",
      Function = "󰊕",
      Constructor = "",
      Field = "",
      Variable = "󰫧",
      Class = "",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "",
      Enum = "",
      Keyword = "󰌆",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "",
      Event = "",
      Operator = "",
      TypeParameter = "󰉺",
    }

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = "menu,menuone,noinsert" },
      mapping = {
        -- NOTE: move up and down completion list items
        -- ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<Up>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),

        -- ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<Down>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),

        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        -- ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<C-s>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.mapping.confirm { select = true }, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.

        -- Move between cursor location after snippet completion
        ["<C-k>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }), -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-j>"] = cmp.mapping(function()
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),
        ["<C-c>"] = cmp.mapping {
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        },
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer" },
        -- {
        --   name = "scss",
        --   option = {
        --     triggers = { "$" },
        --     extension = ".scss",
        --
        --     folders = { "node_modules/@fanduel/formation-tokens/build/scss" },
        --   },
        -- },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      experimental = {
        ghost_text = false,
        native_menu = false,
      },
    }
  end,
}

--[[ NOTE: these are some alternative keybindings ]]
-- "Super tab"
--   ["<Tab>"] = cmp.mapping(function(fallback)
--     if cmp.visible() then
--       cmp.select_next_item()
--     else
--       fallback()
--     end
--   end, { "i", "s" }),
--   ["<S-Tab>"] = cmp.mapping(function(fallback)
--     if cmp.visible() then
--       cmp.select_prev_item()
--     else
--       fallback()
--     end
--   end, { "i", "s" }),
