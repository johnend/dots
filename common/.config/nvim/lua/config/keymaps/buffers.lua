local function get_project_relative_path(absolute_path)
  -- Common root markers in order of preference
  local root_markers = {
    ".git",
    "stylua.toml",
    ".stylua.toml",
    "tsconfig.json",
    "package.json",
    "Cargo.toml",
    "pyproject.toml",
    "go.mod",
    ".root",
  }

  local current_dir = vim.fn.fnamemodify(absolute_path, ":h")
  
  -- Walk up the directory tree looking for root markers
  while current_dir ~= "/" and current_dir ~= "." do
    for _, marker in ipairs(root_markers) do
      if vim.fn.filereadable(current_dir .. "/" .. marker) == 1 or vim.fn.isdirectory(current_dir .. "/" .. marker) == 1 then
        -- Found root, return relative path
        local relative = vim.fn.fnamemodify(absolute_path, ":s?" .. current_dir .. "/??")
        return relative
      end
    end
    -- Move up one directory
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end
  
  -- No project root found, return absolute path
  return absolute_path
end

return {
  { "<leader>b", group = "Buffer" },
  { "<leader>bn", ":bnext<cr>", desc = "Next" },
  { "<leader>bb", ":bprevious<cr>", desc = "Previous" },
  { "<leader>bd", ":bd<cr>", desc = "Delete" },
  { "<leader>bx", ":%bd|e#|bd#<cr>", desc = "Delete all except current" },
  {
    "<leader>by",
    function()
      local absolute_path = vim.fn.expand "%:p"
      local path = get_project_relative_path(absolute_path)
      vim.fn.setreg("+", path)
      
      -- Show if it's relative or absolute in notification
      local path_type = path == absolute_path and "(absolute)" or "(relative)"
      vim.notify('Copied ' .. path_type .. ': ' .. path, vim.log.levels.INFO)
    end,
    desc = "Copy file path",
  },
}
