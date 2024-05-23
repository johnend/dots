local noice = require "noice"

noice.setup {
  views = {
    notify = {
      replace = true,
    },
  },
  lsp = {
    progress = {
      enabled = true,
      format = "lsp_progress",
      format_done = "lsp_progress_done",
      view = "notify",
    },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },

  presets = {
    bottom_search = false,
    command_palette = {
      views = {
        cmdline_popup = {
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            min_width = 60,
            width = "auto",
            height = "auto",
          },
        },
        cmdline_popupmenu = {
          relative = "editor",
          position = {
            row = 11,
            col = "50%",
          },
          size = {
            width = 60,
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
