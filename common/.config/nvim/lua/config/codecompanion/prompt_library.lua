-- Prompt Library Configuration
-- Registers all 12 agents as prompt library entries

local M = {}

---@return table Prompt library configuration
function M.setup()
  -- Helper to build system prompt for an agent
  local function build_agent_prompt(agent_name)
    return function(ctx)
      local shared = require("config.codecompanion.agents.shared")
      local agent = require("config.codecompanion.agents." .. agent_name:lower())
      
      -- Build full context: shared context + agent role
      local context = shared.build_context()
      local role = agent.get_role(ctx)
      
      return context .. "\n\n" .. role
    end
  end

  return {
    -- Main Builder Agent (Default)
    ["Artificer"] = {
      strategy = "chat",
      description = "Main builder - Full autonomy and orchestration",
      opts = {
        index = 1, -- First in list
        default = true, -- Default agent
        system_prompt = build_agent_prompt("artificer"),
      },
      prompts = {}, -- Empty = just opens chat, no visible prompt
    },

    -- Code Review and Teaching
    ["Mentor"] = {
      strategy = "chat",
      description = "Code review and teaching specialist",
      opts = {
        index = 2,
        system_prompt = build_agent_prompt("mentor"),
      },
      prompts = {},
    },

    -- Documentation Specialist
    ["Scribe"] = {
      strategy = "chat",
      description = "Documentation and natural writing",
      opts = {
        index = 3,
        system_prompt = build_agent_prompt("scribe"),
      },
      prompts = {},
    },

    -- Requirements Clarification
    ["Seer"] = {
      strategy = "chat",
      description = "Clarifies ambiguous requests and provides strategic advice",
      opts = {
        index = 4,
        system_prompt = build_agent_prompt("seer"),
      },
      prompts = {},
    },

    -- Fast Executor
    ["Sentinel"] = {
      strategy = "chat",
      description = "Fast execution of simple tasks (<5 min)",
      opts = {
        index = 5,
        system_prompt = build_agent_prompt("sentinel"),
      },
      prompts = {},
    },

    -- Research Specialist
    ["Chronicler"] = {
      strategy = "chat",
      description = "Research docs, PRs, and external sources",
      opts = {
        index = 6,
        system_prompt = build_agent_prompt("chronicler"),
      },
      prompts = {},
    },

    -- Complex Debugging
    ["Investigator"] = {
      strategy = "chat",
      description = "Complex debugging and root cause analysis",
      opts = {
        index = 7,
        system_prompt = build_agent_prompt("investigator"),
      },
      prompts = {},
    },

    -- UI/Frontend Specialist
    ["Bard"] = {
      strategy = "chat",
      description = "UI and frontend specialist (React, Fela, accessibility)",
      opts = {
        index = 8,
        system_prompt = build_agent_prompt("bard"),
      },
      prompts = {},
    },

    -- Codebase Explorer
    ["Pathfinder"] = {
      strategy = "chat",
      description = "Fast codebase exploration and file discovery",
      opts = {
        index = 9,
        system_prompt = build_agent_prompt("pathfinder"),
      },
      prompts = {},
    },

    -- Fitness Guide
    ["Coach"] = {
      strategy = "chat",
      description = "Fitness, health, and performance specialist",
      opts = {
        index = 10,
        system_prompt = build_agent_prompt("coach"),
      },
      prompts = {},
    },

    -- Home Optimizer
    ["Steward"] = {
      strategy = "chat",
      description = "Home optimization and routines",
      opts = {
        index = 11,
        system_prompt = build_agent_prompt("steward"),
      },
      prompts = {},
    },

    -- Innovation Specialist
    ["Visionary"] = {
      strategy = "chat",
      description = "Innovation, ideas, and side projects",
      opts = {
        index = 12,
        system_prompt = build_agent_prompt("visionary"),
      },
      prompts = {},
    },
  }
end

-- Get agent system prompt
---@param agent_name string Agent name (e.g., "Artificer", "Mentor")
---@return function System prompt function
function M.get_agent_prompt(agent_name)
  local prompts = M.setup()
  local agent = prompts[agent_name]
  
  if agent and agent.opts and agent.opts.system_prompt then
    return agent.opts.system_prompt
  end
  
  -- Fallback to Artificer if agent not found
  return prompts["Artificer"].opts.system_prompt
end

-- List all available agents
---@return table List of agent names with descriptions
function M.list_agents()
  local prompts = M.setup()
  local agents = {}
  
  for name, config in pairs(prompts) do
    table.insert(agents, {
      name = name,
      description = config.description,
      index = config.opts.index or 99,
    })
  end
  
  -- Sort by index
  table.sort(agents, function(a, b)
    return a.index < b.index
  end)
  
  return agents
end

return M
