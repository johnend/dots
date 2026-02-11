-- config/codecompanion/hooks.lua
-- Hook utilities for GloomStalker, Risk Assessor, Todo Enforcer, etc.

local M = {}

-- Helper to show results in floating window
function M.show_in_float(content, title, opts)
  opts = opts or {}
  local lines = vim.split(content, "\n")
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  if opts.filetype then
    vim.bo[buf].filetype = opts.filetype
  end

  local width = opts.width or math.min(100, vim.o.columns - 4)
  local height = opts.height or math.min(30, vim.o.lines - 4)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = (vim.o.lines - height) / 2,
    col = (vim.o.columns - width) / 2,
    style = "minimal",
    border = "rounded",
    title = " " .. (title or "Result") .. " ",
    title_pos = "center",
  })
end

-- GloomStalker: Load relevant context for task
function M.run_gloomstalker(task)
  if not task or task == "" then
    return "Error: No task provided"
  end

  local cmd = string.format(
    'node %s "%s"',
    vim.fn.expand "~/.config/opencode/hooks/gloomstalker/cli.js",
    task:gsub('"', '\\"')
  )

  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return "Error running GloomStalker: " .. output
  end

  return output
end

-- Risk Assessor: Assess operation risk
function M.run_risk_assessor(operation)
  if not operation or operation == "" then
    return "Error: No operation provided"
  end

  local cmd = string.format(
    'node %s "%s"',
    vim.fn.expand "~/.config/opencode/hooks/risk-assessor/cli.js",
    operation:gsub('"', '\\"')
  )

  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return "Error running Risk Assessor: " .. output
  end

  return output
end

-- Todo Enforcer: Check if task is multi-step
function M.run_todo_enforcer(task)
  if not task or task == "" then
    return "Error: No task provided"
  end

  local cmd = string.format(
    'node %s "%s"',
    vim.fn.expand "~/.config/opencode/hooks/todo-enforcer/cli.js",
    task:gsub('"', '\\"')
  )

  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return "Error running Todo Enforcer: " .. output
  end

  return output
end

-- Git Status Checker: Enhanced git status
function M.run_git_status_checker()
  local cmd = "node " .. vim.fn.expand "~/.config/opencode/hooks/git-status-checker/dist/cli.js"
  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    return "Error running Git Status Checker: " .. output
  end

  return output
end

-- Chronicle: Document to Obsidian vault
function M.run_chronicle(topic, cwd)
  if not topic or topic == "" then
    return "Error: No topic provided"
  end

  cwd = cwd or vim.fn.getcwd()

  local cmd = string.format(
    'node %s "%s" "%s"',
    vim.fn.expand "~/.config/opencode/hooks/scribe-chronicle.js",
    topic:gsub('"', '\\"'),
    cwd:gsub('"', '\\"')
  )

  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return "Error running Chronicle: " .. output
  end

  return "Chronicle initiated: " .. output
end

-- Parse JSON output (for risk assessor, todo enforcer)
function M.parse_json(output)
  local ok, data = pcall(vim.json.decode, output)
  if ok then
    return data
  end
  return nil
end

return M
