-- config/codecompanion/agents/shared.lua
-- Shared context for all agents (working_style + code_style)

local M = {}

-- Load a file and return its contents
local function load_file(path)
  local expanded_path = vim.fn.expand(path)
  local file = io.open(expanded_path, "r")
  if not file then
    -- Safely handle notification (may not be in Neovim context)
    if vim and vim.notify then
      vim.notify("Could not load file: " .. expanded_path, vim.log.levels.WARN)
    else
      print("Warning: Could not load file: " .. expanded_path)
    end
    return ""
  end
  local content = file:read("*all")
  file:close()
  return content
end

-- Build shared context from working_style and code_style
function M.build_context()
  local working_style = load_file("~/.config/opencode/context/general/ai-working-style.md")
  local code_style = load_file("~/.config/opencode/context/general/code-style.md")

  return string.format([[# Your Working Style

%s

# Code Style Conventions

%s
]], working_style, code_style)
end

return M
