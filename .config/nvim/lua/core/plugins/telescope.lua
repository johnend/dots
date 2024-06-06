local telescope = require "telescope"

---@alias telescope_themes
---| "cursor"   # see `telescope.themes.get_cursor()`
---| "dropdown" # see `telescope.themes.get_dropdown()`
---| "ivy"      # see `telescope.themes.get_ivy()`
---| "center"   # use the default telescope theme

-- [[ Configure Telescope ]]
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
      layout_config = {
        width = 0.5,
        height = 0.3,
      },
      find_command = {
        "rg",
        "--files",
        "--hidden",
        "--no-ignore-vcs",
        "--glob",
        "!**/.git/*",
        "--glob",
        "!**/node_modules/*",
        "--glob",
        "!**/dist/*",
        "--glob",
        "!**/.build/*",
        "--glob",
        "!**/.vscode/*",
        "--glob",
        "!**/.next/*",
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

-- Enable telescope extensions
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")
pcall(telescope.load_extension, "project")
pcall(telescope.load_extension, "aerial")
-- [[ Keymaps ]]
local builtin = require "telescope.builtin"
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "Commands" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Files" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "Select Telescope picker" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search current word" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Grep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sp", ":Telescope project project theme=dropdown layout_config={width=0.5, height=0.4}<CR>", { desc = "Projects" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = 'Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Open buffers" })
vim.keymap.set("n", "<leader>st", ":TodoTelescope theme=dropdown previewer=false layout_config={width=0.5,height=0.3}<CR>", { desc = "Todos" })
vim.keymap.set("", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Search in current buffer" })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
  builtin.find_files { cwd = vim.fn.stdpath "config" }
end, { desc = "Search Neovim files" })
