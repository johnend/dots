local M = {}

M.buffers = {
  { "<leader>b", group = "Buffer" },
  { "<leader>bn", ":bnext<cr>", desc = "Next" },
  { "<leader>bb", ":bprevious<cr>", desc = "Previous" },
  { "<leader>bd", ":bd<cr>", desc = "Delete" },
  { "<leader>bx", ":%bd|e#|bd#<cr>", desc = "Delete all except current" },
}

M.telescope = {
  { "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "Open files" },
  { "<leader>s", group = "Search" },
  { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  { "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Colorschemes" },
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
    desc = "Diagnostics",
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

M.lsp = {
  { "<leader>l", group = "LSP" },
  { "<leader>lX", ":Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
  { "<leader>la", ":lua require('actions-preview').code_actions<cr>", desc = "Code action" },
  { "<leader>ld", ":Telescope lsp_type_definitions<cr>", desc = "Type definition" },
  { "<leader>li", ":LspInfo<cr>", desc = "LSP info" },
  { "<leader>lv", ":Trouble loclist toggle<cr>", desc = "Location list (Trouble)" },
  { "<leader>ll", ":Trouble lsp toggle focus=false<cr>", "LSP toggle (Trouble)" },
  { "<leader>lq", ":Trouble qflist toggle<cr>", desc = "Quickfix list (Trouble)" },
  {
    "<leader>lr",
    function()
      vim.lsp.buf.rename()
    end,
    desc = "Rename",
  },
  { "<leader>ls", ":Trouble symbols toggle focus=true<cr>", "Document symbols" },
  {
    "<leader>lt",
    ":TSC<cr>",
    desc = "Check TypeScript types",
  },
  { "<leader>lw", ":Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
  { "<leader>lx", ":Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
  { "<leader>r", ":LspRestart<cr>", "Restart LSP Server" },
  {
    "K",
    function()
      vim.lsp.buf.hover()
    end,
    desc = "Hover Documentation",
  },
  {
    "gD",
    function()
      vim.lsp.buf.declaration()
    end,
    desc = "Goto declaration",
  },
  { "gI", ":Telescope lsp_implementations<cr>", desc = "Goto implementation" },
  { "gd", ":Telescope lsp_definitions<cr>", desc = "Goto definition" },
  { "gr", ":Telescope lsp_references<cr>", desc = "Goto references" },
}

M.plugins = {
  { "<leader>p", group = "Plugins", icon = icons.misc.Lazy },
  { "<leader>p?", ":Lazy help<cr>", desc = "Help" },
  { "<leader>pd", ":Lazy debug<cr>", desc = "Debug" },
  { "<leader>ph", ":Lazy health<cr>", desc = "Health" },
  { "<leader>pl", ":Lazy log<cr>", desc = "Log" },
  { "<leader>pm", ":Mason<cr>", icon = icons.misc.Plug, desc = "Mason" },
  { "<leader>po", ":Lazy<cr>", desc = "Open" },
  { "<leader>pp", ":Lazy profile<cr>", desc = "Profile" },
  { "<leader>ps", ":Lazy sync<cr>", desc = "Sync" },
  { "<leader>pu", ":Lazy update<cr>", desc = "Update" },
}

return M
