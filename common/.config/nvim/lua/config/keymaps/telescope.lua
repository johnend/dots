return {
  { "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "Open files" },
  { "<leader>s", group = "Search" },
  { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  {
    "<leader>sc",
    function()
      require("config.telescope-colorscheme").colorscheme(
        require("telescope.themes").get_dropdown {
          layout_config = { width = 0.8, height = 0.3 },
          enable_preview = true,
        }
      )
    end,
    desc = "Colorschemes",
  },
  { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
  { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Files" },
  { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
  { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
  { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
  {
    "<leader>sn",
    ":lua require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }<cr>",
    desc = "Neovim config files",
  },
  {
    "<leader>sp",
    "<cmd>Telescope project project theme=dropdown layout_config={width=0.5, height=0.4}<cr>",
    desc = "Projects",
  },
  { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume project" },
  { "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "Builtin pickers" },
  {
    "<leader>st",
    "<cmd>TodoTelescope theme=dropdown previewer=false layout_config={width=0.5,height=0.3}<cr>",
    desc = "TODOs",
  },
  { "<leader>sv", "<cmd>Telescope git_files<cr>", desc = "Git files" },
  { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Current word" },
  { "<leader>sx", "<cmd>Telescope commands<cr>", desc = "Commands" },
  { "<leader>s.", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
}
