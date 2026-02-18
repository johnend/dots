-- core/lazy-config.lua
-- Lazy.nvim plugin specifications and configuration

local M = {}

-- Helper to check if a plugin folder is non-empty
local function plugin_folder_has_files(folder)
  local path = vim.fn.stdpath "config" .. "/lua/core/plugins/" .. folder
  ---@diagnostic disable-next-line: undefined-field
  local handle = vim.uv.fs_scandir(path)
  if not handle then
    return false
  end
  for _ in
    function()
      ---@diagnostic disable-next-line: undefined-field
      return vim.uv.fs_scandir_next(handle)
    end
  do
    return true -- found at least one file
  end
  return false
end

function M.get_specs()
  -- Base plugin specs
  local plugin_specs = {
    { import = "plugins" },
    { import = "plugins.utilities" },
    { import = "plugins.git" },
    { import = "plugins.editing" },
    { import = "plugins.navigation" },
    { import = "plugins.devtools" },
    { import = "plugins.syntax" },
    { import = "plugins.ui" },
    { import = "plugins.colorschemes" },
    { import = "plugins.lsp" },
  }

  -- Conditionally import _testing_ground if it has files
  if plugin_folder_has_files "_testing_ground" then
    table.insert(plugin_specs, 2, { import = "plugins._testing_ground" })
  end

  return plugin_specs
end

function M.get_opts()
  return {
    spec = M.get_specs(),
    ui = {
      border = "rounded",
    },
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  }
end

return M
