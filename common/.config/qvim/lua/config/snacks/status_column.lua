local M = {
  enabled = true,
  left = { "mark", "sign" },
  right = { "fold", "git" },
  folds = {
    open = true,
    git_hl = false,
  },
  git = {
    patterns = { "GitSign", "MiniDiffSign" },
  },
}

return M
