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
      layout_config = { width = 0.3, height = 0.3 },
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
        width = 0.3,
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
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sp", ":Telescope project project theme=dropdown layout_config={width=0.4, height=0.4}<CR>", { desc = "[S]earch [P]rojects" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>st", ":TodoTelescope theme=dropdown previewer=false layout_config={width=0.4,height=0.3}<CR>", { desc = "[S]earch [T]odos" })
vim.keymap.set("n", "<leader>sa", ":Telescope aerial theme=dropdown layout_config={width=0.4,height=0.3}<CR>", { desc = "[S]earch [A]erial" })
vim.keymap.set("", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "[S]earch in current [B]uffer (Fuzzy)" })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
  builtin.find_files { cwd = vim.fn.stdpath "config" }
end, { desc = "[S]earch [N]eovim files" })
