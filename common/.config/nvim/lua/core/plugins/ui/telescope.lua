return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  branch = "0.1.x",
  lazy = true,
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable "make" == 1
      end,
    },
    { "nvim-telescope/telescope-project.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    {
      "nvim-tree/nvim-web-devicons",
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

    telescope.setup {
      theme = "dropdown", ---@type telescope_themes
      defaults = {
        prompt_prefix = " " .. icons.ui.Telescope .. "  ",
        selection_caret = " " .. icons.ui.Forward .. "  ",
        entry_prefix = " ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = nil,
        layout_strategy = nil,
        layout_config = {},
        file_ignore_patterns = {},
        path_display = { "smart" },
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" },
      },
      -- TODO: figure out how to change the layouts of the pickers (increased width for preview for example)
      pickers = {
        help_tags = {
          theme = "dropdown",
          layout_config = {
            width = 0.5,
            height = 0.3,
          },
        },
        keymaps = {
          selection_caret = icons.ui.Forward,
          theme = "dropdown",
          layout_config = { width = 0.6, height = 0.3 },
        },
        commands = {
          selection_caret = icons.ui.Forward,
          theme = "dropdown",
          layout_config = { width = 0.5, height = 0.3 },
        },
        find_files = {
          theme = "dropdown",
          file_ignore_patterns = { "node_modules", ".git", ".build", "dist", ".vscode", ".next" },
          layout_config = {
            width = 0.5,
            height = 0.3,
          },
          find_command = {
            "fd",
            "--hidden",
          },
        },
        builtin = {
          theme = "dropdown",
          previewer = false,
        },
        grep_string = {
          theme = "dropdown",
        },
        diagnostics = {
          theme = "dropdown",
        },
        oldfiles = {
          theme = "dropdown",
          layout_config = {
            width = 0.5,
            height = 0.3,
          },
        },
        buffers = {
          theme = "dropdown",
          layout_config = {
            width = 0.5,
            height = 0.3,
          },
          initial_mode = "normal",
        },
        current_buffer_fuzzy_find = {
          theme = "dropdown",
          previewer = false,
          layout_config = {
            width = 0.4,
            height = 0.3,
          },
        },
      },
    }

    telescope.load_extension "fzf"
    telescope.load_extension "ui-select"
    telescope.load_extension "project"

    -- [[ Keymaps ]]
    local builtin = require "telescope.builtin"
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
    vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "Commands" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Files" })
    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "Select Telescope picker" })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search current word" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Grep" })
    vim.keymap.set("n", "<leader>sv", builtin.git_files, { desc = "Git files" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
    vim.keymap.set(
      "n",
      "<leader>sp",
      ":Telescope project project theme=dropdown layout_config={width=0.5, height=0.4}<CR>",
      { desc = "Projects" }
    )
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume" })
    vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = 'Recent Files ("." for repeat)' })
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Open buffers" })
    vim.keymap.set(
      "n",
      "<leader>st",
      ":TodoTelescope theme=dropdown previewer=false layout_config={width=0.5,height=0.3}<CR>",
      { desc = "Todos" }
    )
    vim.keymap.set("", "<leader>sb", builtin.buffers, { desc = "Search open buffers" })
    vim.keymap.set("", "<leader>sc", builtin.current_buffer_fuzzy_find, { desc = "Search in current buffer" })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set("n", "<leader>sn", function()
      builtin.find_files { cwd = vim.fn.stdpath "config" }
    end, { desc = "Search Neovim files" })
  end,
}
