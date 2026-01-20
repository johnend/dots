return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
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
      {
        filter = {
          event = "msg_show",
          find = ".*Java Language Server.*",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "ServiceReady",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "Service Ready",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "Defining diagnostic signs.*deprecated",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "sign%-define.*deprecated",
        },
        opts = { skip = true },
      },
    },
    views = {
      mini = { win_options = { winblend = 0 } },
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
          border = UI.border,
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
              row = "25%",
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
              style = UI.border,
            },
            win_options = {
              winhighlight = { Normal = "Normal", FloatBorder = "FloatBorder" },
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
        cmdline = { icon = Icons.misc.Industry, title = "" },
        help = { icon = Icons.ui.Lightbulb },
      },
    },
  },
}
