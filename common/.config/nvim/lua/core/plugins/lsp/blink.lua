return {
  "saghen/blink.cmp",
  -- only load when we enter insert or cmdline
  version = "1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
        "folke/lazydev.nvim",
        "onsails/lspkind.nvim",
        "xzbdmw/colorful-menu.nvim",
      },
    },
  },
  -- this opts block now configures blink.cmp itself, not LuaSnip!
  opts = {
    enabled = function()
      local filetype = vim.bo[0].filetype
      if filetype == "TelescopePrompt" then
        return false
      end
      return true
    end,

    sources = {
      default = { "lsp", "path", "snippets", "buffer", "lazydev" },
      providers = {
        lsp = {
          enabled = true,
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          score_offset = 100,
        },
        lazydev = {
          enabled = true,
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 90,
        },
        snippets = {
          enabled = true,
          name = "LuaSnip",
          max_items = 15,
          min_keyword_length = 2,
          module = "blink.cmp.sources.snippets",
          score_offset = 80,
        },
        path = {
          enabled = true,
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 30,
          fallbacks = { "snippets", "buffer" },
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
          },
        },
        buffers = {
          enabled = true,
          name = "Buffer",
          max_items = 5,
          module = "blink.cmp.sources.buffer",
          score_offset = 10,
        },
      },
    },

    keymap = {
      -- use the built-in preset; see docs for other presets :contentReference[oaicite:0]{index=0}
      preset = "default",
      ["<C-e>"] = {
        function(cmp)
          cmp.show { providers = { "lsp", "snippets", "buffers" } }
        end,
      },
      ["<Up>"] = {},
      ["<Down>"] = {},
      -- you can override individual keys here, too
    },

    appearance = {
      nerd_font_variant = "mono",
      kind_icons = icons.kind,
    },
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
      documentation = {
        window = {
          border = "rounded",
          winhighlight = "FloatBorder:FloatBorder",
        },
        auto_show = true,
        auto_show_delay_ms = 300,
      },
      menu = {
        border = "rounded",
        winhighlight = "FloatBorder:FloatBorder",
        -- Controls how the completion items are rendered on the popup window
        draw = {
          -- Aligns the keyword you've typed to a component in the menu
          align_to = "label", -- or 'none' to disable, or 'cursor' to align to the cursor
          -- Left and right padding, optionally { left, right } for different padding on each side
          padding = 1,
          -- Gap between columns
          gap = 1,
          -- Priority of the cursorline highlight, setting this to 0 will render it below other highlights
          cursorline_priority = 10000,
          -- Use treesitter to highlight the label text for the given list of sources
          treesitter = { "lsp", "buffers" },
          -- treesitter = { 'lsp' }

          -- Components to render, grouped by column
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
          -- Definitions for possible components to render. Each defines:
          --   ellipsis: whether to add an ellipsis when truncating the text
          --   width: control the min, max and fill behavior of the component
          --   text function: will be called for each item
          --   highlight function: will be called only when the line appears on screen
          components = {

            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                return ctx.kind_icon .. ctx.icon_gap
              end,
              -- Set the highlight priority to 20000 to beat the cursorline's default priority of 10000
              highlight = function(ctx)
                return { { group = ctx.kind_hl, priority = 20000 } }
              end,
            },

            kind = {
              ellipsis = false,
              width = { fill = true },
              text = function(ctx)
                return ctx.kind
              end,
              highlight = function(ctx)
                return ctx.kind_hl
              end,
            },

            label = {
              width = { fill = true, max = 60 },
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },

            label_description = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.label_description
              end,
              highlight = "BlinkCmpLabelDescription",
            },

            source_name = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.source_name
              end,
              highlight = "BlinkCmpSource",
            },

            source_id = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.source_id
              end,
              highlight = "BlinkCmpSource",
            },
          },
        },
      },
    },
    snippets = {
      preset = "luasnip",
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      use_frecency = false,
    },
    signature = {
      enabled = true,
      window = {
        border = "rounded",
        winhighlight = "FloatBorder:FloatBorder",
      },
    },
  },
  -- ensure Lazy.nvim actually calls the setup
  config = function(_, opts)
    local status_ok, blink = pcall(require, "blink.cmp")
    if not status_ok then
      return
    end

    blink.setup(opts) -- wire your opts into blink :contentReference[oaicite:1]{index=1}
  end,
}
