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

    local dropdown_config = { theme = "dropdown", layout_config = { width = 0.5, height = 0.2 } }
    local ignore_patterns = { "node_modules", ".git", ".build", "dist", ".vscode", ".next" }

    -- more performant sorting with rg
    local glob_args = vim.tbl_map(function(pattern)
      return "--glob=!" .. pattern
    end, ignore_patterns)
    local find_command = { "rg", "--files", "--hidden", "--no-ignore", "--sortr=modified" }
    vim.list_extend(find_command, glob_args)

    telescope.setup {
      theme = "dropdown", ---@type telescope_themes
      defaults = {
        prompt_prefix = " " .. icons.ui.Telescope .. "  ",
        selection_caret = " " .. icons.ui.Forward .. "  ",
        entry_prefix = " ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
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
          file_ignore_patterns = ignore_patterns,
          find_command = find_command,
        },
        live_grep = {
          file_ignore_patterns = vim.list_extend(
            vim.deepcopy(ignore_patterns),
            { "package%-lock%.json", "yarn%.lock", "lazy%-lock%.json" }
          ),
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

    telescope.load_extension "fzf"
    telescope.load_extension "ui-select"
    telescope.load_extension "project"

    -- [[ Keymaps ]]
    local builtin = require "telescope.builtin"
    local keymaps = {
      { "n", "<leader>sh", builtin.help_tags, "Help" },
      { "n", "<leader>sk", builtin.keymaps, "Keymaps" },
      { "n", "<leader>sx", builtin.commands, "Commands" },
      { "n", "<leader>sc", builtin.colorscheme, "Colorscheme" },
      { "n", "<leader>sf", builtin.find_files, "Files" },
      { "n", "<leader>ss", builtin.builtin, "Select Telescope picker" },
      { "n", "<leader>sw", builtin.grep_string, "Search current word" },
      { "n", "<leader>sg", builtin.live_grep, "Grep" },
      { "n", "<leader>sv", builtin.git_files, "Git files" },
      { "n", "<leader>sd", builtin.diagnostics, "Diagnostics" },
      {
        "n",
        "<leader>sp",
        ":Telescope project project theme=dropdown layout_config={width=0.5, height=0.4}<CR>",
        "Projects",
      },
      { "n", "<leader>sr", builtin.resume, "Resume" },
      { "n", "<leader>s.", builtin.oldfiles, 'Recent Files ("." for repeat)' },
      { "n", "<leader><leader>", builtin.buffers, "Open buffers" },
      {
        "n",
        "<leader>st",
        ":TodoTelescope theme=dropdown previewer=false layout_config={width=0.5,height=0.3}<CR>",
        "TODOs",
      },
      { "", "<leader>sb", builtin.buffers, "Search open buffers" },
      {
        "n",
        "<leader>sn",
        function()
          builtin.find_files { cwd = vim.fn.stdpath "config" }
        end,
        "Neovim config",
      },
    }
    for _, map in ipairs(keymaps) do
      vim.keymap.set(map[1], map[2], map[3], { desc = map[4] })
    end
  end,
}
