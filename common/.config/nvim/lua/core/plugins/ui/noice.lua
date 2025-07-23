return {
  "folke/noice.nvim",
  event = "VimEnter",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local status_ok, noice = pcall(require, "noice")
    if not status_ok then
      return
    end

    noice.setup {
      -- TODO: remove the routes once updates come through
      -- Routes are filtering some things that aren't needed
      routes = {
        {
          filter = {
            event = "notify",
            find = "position_encoding param is required",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            find = "vim%.lsp%.util%.jump_to_location is deprecated",
          },
          opts = { skip = true },
        },
      },
      -- Global view behaviour
      views = {
        -- notify = { replace = true, merge = true },
        mini = {
          win_options = {
            winblend = 0,
          },
        },
      },
      lsp = {
        progress = {
          enabled = true,
          format = "lsp_progress",
          format_done = "lsp_progress_done",
          view = "mini",
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          silent = false,
          view = nil,
          opts = {
            border = "rounded",
            max_width = math.floor(vim.o.columns * 0.5),
          },
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
        },
      },

      presets = {
        bottom_search = false,
        command_palette = {
          views = {
            cmdline_popup = {
              position = {
                row = 10,
                col = "50%",
              },
              size = {
                min_width = 75,
                width = "auto",
                height = "auto",
              },
            },
            cmdline_popupmenu = {
              relative = "editor",
              position = {
                row = 13,
                col = "50%",
              },
              size = {
                width = 75,
                height = "auto",
                max_height = 16,
              },
              border = {
                style = "rounded",
                padding = { 0, 1 },
              },
              win_options = {
                winhighlight = { Normal = "Normal", FloatBorder = "NoiceCmdlinePopupBorder" },
              },
            },
          },
        },
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      cmdline = {
        format = {
          cmdline = { icon = icons.misc.Industry },
          help = { icon = icons.ui.Lightbulb },
        },
      },
    }
  end,
}
