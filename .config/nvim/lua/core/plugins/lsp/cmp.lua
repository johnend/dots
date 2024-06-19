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
            if
              luasnip.session
              and luasnip.session.current_nodes
              and not luasnip.session.jump_active
              and not luasnip.choice_active()
            then
              luasnip.unlink_current()
            end
          end,
        })
      end,
    },
    { "hrsh7th/cmp-nvim-lua", event = "InsertEnter" },
    { "mmolhoek/cmp-scss", event = "InsertEnter" },
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
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.mapping.confirm { select = true }, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-c>"] = cmp.mapping {
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        },
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.expand_or_locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
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
        {
          name = "scss",
          option = {
            folders = { "node_modules/@fanduel/formation-tokens/build/scss" },
          },
        },
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
