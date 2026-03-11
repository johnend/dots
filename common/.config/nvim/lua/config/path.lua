local M = {}

local ROOT_MARKERS = {
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

function M.get_project_relative_path(absolute_path)
  local current_dir = vim.fn.fnamemodify(absolute_path, ":h")

  while current_dir ~= "/" and current_dir ~= "." do
    for _, marker in ipairs(ROOT_MARKERS) do
      if
        vim.fn.filereadable(current_dir .. "/" .. marker) == 1
        or vim.fn.isdirectory(current_dir .. "/" .. marker) == 1
      then
        return vim.fn.fnamemodify(absolute_path, ":s?" .. current_dir .. "/??")
      end
    end

    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  return absolute_path
end

function M.copy_path_to_clipboard(path, label)
  if not path or path == "" then
    vim.notify("No file path available", vim.log.levels.WARN)
    return
  end

  vim.fn.setreg("+", path)
  vim.notify("Copied " .. label .. ": " .. path, vim.log.levels.INFO)
end

function M.copy_current_buffer_absolute_path()
  M.copy_path_to_clipboard(vim.fn.expand "%:p", "absolute path")
end

function M.copy_current_buffer_relative_path()
  local absolute_path = vim.fn.expand "%:p"
  M.copy_path_to_clipboard(M.get_project_relative_path(absolute_path), "relative path")
end

return M
