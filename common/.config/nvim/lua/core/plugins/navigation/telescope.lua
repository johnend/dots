return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  branch = "0.1.x",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      event = "VeryLazy",
      build = "make",
      cond = function()
        return vim.fn.executable "make" == 1
      end,
    },
    { "nvim-telescope/telescope-project.nvim", event = "VeryLazy" },
    { "nvim-telescope/telescope-ui-select.nvim", event = "VeryLazy" },

    {
      "nvim-tree/nvim-web-devicons",
      event = "VeryLazy",
      enabled = vim.g.have_nerd_font,
    },
  },
  config = function()
    local status_ok, telescope = pcall(require, "telescope")
    if not status_ok then
      return
    end

    ---@alias telescope_themes
    ---| "cursor"   # see `telescope.themes.get_cursor()`
    ---| "dropdown" # see `telescope.themes.get_dropdown()`
    ---| "ivy"      # see `telescope.themes.get_ivy()`
    ---| "center"   # use the default telescope theme

    local dropdown_config = { theme = "dropdown", layout_config = { width = 0.8, height = 0.3 } }
    local ignore_patterns = {
      -- folders
      "^node_modules/",
      "^.git/",
      "^dist.*/",
      "^%.build/",
      "^.vscode/",
      "^.next/",
      "^coverage/",
      -- specific files
      "package%.lock",
      "yarn%.lock",
    }

    -- more performant sorting with rg
    local glob_args = vim.tbl_map(function(pattern)
      return "--glob=!" .. pattern
    end, ignore_patterns)
    local find_command = { "rg", "--files", "--hidden", "--sortr=modified" }
    vim.list_extend(find_command, glob_args)

    local actions = require "telescope.actions"

    telescope.setup {
      theme = "dropdown", ---@type telescope_themes
      defaults = {
        prompt_prefix = " " .. icons.ui.Telescope .. "  ",
        selection_caret = " " .. icons.ui.Forward .. "  ",
        entry_prefix = " ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_config = {},
        file_ignore_patterns = ignore_patterns,
        -- path_display = { "" },
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" },
        mappings = {
          i = {
            ["<c-q>"] = function(prompt_bufnr)
              actions.smart_send_to_qflist(prompt_bufnr)
              vim.cmd "Trouble quickfix"
            end,
          },
          n = {
            ["<c-d>"] = actions.delete_buffer,
            ["<c-q>"] = function(prompt_bufnr)
              actions.smart_send_to_qflist(prompt_bufnr)
              vim.cmd "Trouble quickfix"
            end,
          },
        },
      },
      -- TODO: figure out how to change the layouts of the pickers (increased width for preview for example)
      pickers = {
        help_tags = {
          theme = dropdown_config.theme,
          layout_config = dropdown_config.layout_config,
        },
        keymaps = {
          theme = dropdown_config.theme,
          layout_config = dropdown_config.layout_config,
          selection_caret = icons.ui.Forward,
        },
        commands = {
          theme = dropdown_config.theme,
          layout_config = dropdown_config.layout_config,
          selection_caret = icons.ui.Forward,
        },
        find_files = {
          theme = dropdown_config.theme,
          sorting_strategy = nil,
          layout_config = dropdown_config.layout_config,
          find_command = find_command,
          hidden = true,
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
        builtin = {
          theme = "dropdown",
          previewer = false,
        },
        colorscheme = {
          theme = dropdown_config.theme,
          layout_config = dropdown_config.layout_config,
          enable_preview = true,
        },
        grep_string = {
          theme = dropdown_config.theme,
          file_ignore_patterns = vim.list_extend(vim.deepcopy(ignore_patterns), {
            "package%-lock%.json",
            "yarn%.lock",
          }),
        },
        diagnostics = {
          theme = "dropdown",
        },
        oldfiles = {
          theme = dropdown_config.theme,
          layout_config = dropdown_config.layout_config,
        },
        buffers = {
          initial_mode = "normal",
          theme = dropdown_config.theme,
          layout_config = dropdown_config.layout_config,
        },
        current_buffer_fuzzy_find = {
          previewer = false,
          theme = dropdown_config.theme,
          layout_config = dropdown_config.layout_config,
        },
      },
    }
    pcall(telescope.load_extension "fzf")
    pcall(telescope.load_extension "ui-select")
    pcall(telescope.load_extension "project")
  end,
}
