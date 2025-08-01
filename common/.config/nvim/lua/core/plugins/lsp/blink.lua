local dedupe = function(ctx, items)
  if not ctx.seen_labels then
    ctx.seen_labels = ctx.seen_labels or {}
  end

  local unique = {}

  for _, item in ipairs(items) do
    if not ctx.seen_labels[item.label] then
      ctx.seen_labels[item.label] = true
      table.insert(unique, item)
    end
  end
  return unique
end

---@diagnostic disable-next-line: unused-local
local function sanitize(ctx, items)
  for _, item in ipairs(items) do
    if item.label then
      item.label = item.label:gsub("\n", " ")
    end
    if item.label_description then
      item.label_description = item.label_description:gsub("\n", " ")
    end
  end
  return items
end

local function sanitize_and_dedupe(ctx, items)
  items = sanitize(ctx, items)
  return dedupe(ctx, items)
end

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

    snippets = { preset = "luasnip" },

    sources = {
      default = { "snippets", "lsp", "path", "buffer", "lazydev" },
      providers = {
        lsp = {
          enabled = true,
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          score_offset = 90,
          transform_items = sanitize_and_dedupe,
        },
        lazydev = {
          enabled = true,
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 70,
        },
        snippets = {
          enabled = true,
          name = "LuaSnip",
          max_items = 15,
          min_keyword_length = 2,
          module = "blink.cmp.sources.snippets",
          score_offset = 100,
        },
        path = {
          enabled = true,
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 50,
          fallbacks = { "snippets", "buffer" },
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
          },
        },
        buffer = {
          enabled = true,
          name = "Buffer",
          max_items = 80,
          module = "blink.cmp.sources.buffer",
          score_offset = 2,
        },
      },
    },

    keymap = {
      -- use the built-in preset; see docs for other presets :contentReference[oaicite:0]{index=0}
      preset = "default",
      ["<C-e>"] = {
        function(cmp)
          cmp.show { providers = { "snippets", "lsp", "path", "buffer" } }
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
          preselect = true,
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
