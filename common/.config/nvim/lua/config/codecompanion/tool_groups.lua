-- Tool Groups Configuration
-- Defines custom tool groups for specialized agents

local M = {}

---@return table Tool groups configuration
function M.setup()
  return {
    -- Artificer tool group - Full autonomy (OpenCode-level capabilities)
    artificer = {
      -- File operations
      "read_file",           -- Read any file
      "create_file",         -- Create new files
      "delete_file",         -- Remove files
      "insert_edit_into_file", -- Edit existing files
      
      -- Search and navigation
      "file_search",         -- Find files by pattern (fd-based)
      "grep_search",         -- Search file contents (ripgrep-based)
      "list_code_usages",    -- Track where code is used (LSP-based)
      
      -- Execution
      "cmd_runner",          -- Run shell commands
      
      -- Git operations
      "get_changed_files",   -- See git changes
      
      -- Knowledge management
      "memory",              -- Persistent memory across sessions
    },

    -- Mentor tool group - Review and analysis focused
    mentor = {
      "read_file",
      "grep_search",
      "file_search",
      "list_code_usages",
      "memory",
    },

    -- Scribe tool group - Documentation focused
    scribe = {
      "read_file",
      "file_search",
      "grep_search",
      "create_file",
      "insert_edit_into_file",
      "memory",
    },

    -- Investigator tool group - Debugging focused
    investigator = {
      "read_file",
      "file_search",
      "grep_search",
      "list_code_usages",
      "cmd_runner",
      "get_changed_files",
      "memory",
    },

    -- Pathfinder tool group - Search optimized
    pathfinder = {
      "file_search",         -- Primary tool (fast file finding)
      "grep_search",         -- Primary tool (fast content search)
      "list_code_usages",    -- Track references
      "read_file",           -- Quick verification
      "memory",
    },

    -- Sentinel tool group - Fast execution
    sentinel = {
      "read_file",
      "create_file",
      "insert_edit_into_file",
      "delete_file",
      "file_search",
      "grep_search",
      "cmd_runner",
    },

    -- Chronicler tool group - Research focused
    chronicler = {
      "read_file",
      "file_search",
      "grep_search",
      "cmd_runner",          -- For gh CLI usage
      "memory",
    },

    -- Bard tool group - UI development
    bard = {
      "read_file",
      "file_search",
      "grep_search",
      "create_file",
      "insert_edit_into_file",
      "memory",
    },

    -- Minimal tool group for non-technical agents
    minimal = {
      "create_file",
      "read_file",
      "memory",
    },
  }
end

-- Get tools for a specific agent
---@param agent_name string Agent name (e.g., "artificer", "mentor")
---@return table|nil List of tools or nil if agent not found
function M.get_tools_for_agent(agent_name)
  local tool_groups = M.setup()
  local normalized_name = agent_name:lower()
  
  -- Map agent names to tool groups
  local agent_to_group = {
    artificer = "artificer",
    mentor = "mentor",
    scribe = "scribe",
    seer = "mentor",           -- Seer uses mentor tools (read + search)
    sentinel = "sentinel",
    chronicler = "chronicler",
    investigator = "investigator",
    bard = "bard",
    pathfinder = "pathfinder",
    coach = "minimal",         -- Coach doesn't need many tools
    steward = "minimal",       -- Steward doesn't need many tools
    visionary = "minimal",     -- Visionary doesn't need many tools
  }
  
  local group_name = agent_to_group[normalized_name]
  if group_name then
    return tool_groups[group_name]
  end
  
  -- Default: Return artificer tools (most capable)
  return tool_groups.artificer
end

-- Check if an agent has access to a specific tool
---@param agent_name string Agent name
---@param tool_name string Tool to check
---@return boolean True if agent has access to tool
function M.agent_has_tool(agent_name, tool_name)
  local tools = M.get_tools_for_agent(agent_name)
  if not tools then return false end
  
  for _, tool in ipairs(tools) do
    if tool == tool_name then
      return true
    end
  end
  
  return false
end

return M
