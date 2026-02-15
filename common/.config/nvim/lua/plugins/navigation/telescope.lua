return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  branch = "master",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter", -- managed by plugins.syntax.treesitter
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

    local center_config = {
      layout_strategy = "horizontal",
      layout_config = {
        prompt_position = "top",
        height = 0.5,
        width = 0.6,
        preview_width = 0.5,
      },
      sorting_strategy = "ascending",
    }

    telescope.setup {
      defaults = {
        prompt_prefix = " " .. Icons.ui.Telescope .. "  ",
        selection_caret = Icons.ui.HandPointRight .. " ",
        -- entry_prefix = " ",
        initial_mode = "insert",
        selection_strategy = "reset",
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
        help_tags = center_config,
        diagnostics = center_config,
        commands = {
          layout_strategy = center_config.layout_strategy,
          layout_config = {
            prompt_position = "top",
            height = 0.5,
            width = 0.6,
          },
          previewer = false,
          sorting_strategy = "ascending",
        },
        keymaps = center_config,
        find_files = {
          layout_strategy = center_config.layout_strategy,
          layout_config = center_config.layout_config,
          sorting_strategy = "ascending",
          find_command = find_command,
          hidden = true,
        },
        git_files = {
          layout_strategy = center_config.layout_strategy,
          layout_config = center_config.layout_config,
          sorting_strategy = "ascending",
          find_command = find_command,
          hidden = true,
        },
        live_grep = {
          layout_strategy = center_config.layout_strategy,
          layout_config = center_config.layout_config,
          sorting_strategy = "ascending",
          additional_args = function()
            return { "--hidden" }
          end,
        },
        builtin = {
          theme = "dropdown",
          previewer = false,
        },
        colorscheme = center_config,
        grep_string = {
          layout_strategy = center_config.layout_strategy,
          layout_config = center_config.layout_config,
          sorting_strategy = "ascending",
          file_ignore_patterns = vim.list_extend(vim.deepcopy(ignore_patterns), {
            "package%-lock%.json",
            "yarn%.lock",
          }),
        },
        oldfiles = center_config,
        buffers = {
          layout_strategy = center_config.layout_strategy,
          layout_config = center_config.layout_config,
          sorting_strategy = "ascending",
          initial_mode = "normal",
        },
      },
    }
    pcall(telescope.load_extension "fzf")
    pcall(telescope.load_extension "ui-select")
    pcall(telescope.load_extension "project")
    pcall(telescope.load_extension "grapple")
  end,
}
