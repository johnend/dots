-- config/codecompanion/init.lua
-- Main CodeCompanion configuration orchestrator

local slash_commands = require("config.codecompanion.slash_commands")
local prompt_library = require("config.codecompanion.prompt_library")
local display = require("config.codecompanion.display")

return {
  -- Adapter configuration
  adapters = {
    copilot = function()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            default = "claude-sonnet-4.5",
          },
        },
      })
    end,
  },

  -- Strategy configuration
  strategies = {
    -- Chat strategy (main interaction mode)
    chat = {
      adapter = "copilot",
      roles = {
        llm = "Artificer", -- Default agent
        user = "User",
      },
      slash_commands = slash_commands,
      opts = {
        -- System prompt function that uses current agent
        ---@param ctx CodeCompanion.SystemPrompt.Context
        ---@return string
        system_prompt = function(ctx)
          -- Get current agent from global variable (set by switch_agent())
          local current_agent = vim.g.current_agent or "Artificer"
          
          -- Get agent-specific prompt function from prompt_library
          local agent_prompt_fn = prompt_library.get_agent_prompt(current_agent)
          
          if agent_prompt_fn then
            -- Agent found, use its custom prompt
            return agent_prompt_fn(ctx)
          else
            -- Fallback to default if agent not found
            return ctx.default_system_prompt
          end
        end,
      },
    },

    -- Inline editing strategy
    inline = {
      adapter = "copilot",
    },

    -- Agent strategy
    agent = {
      adapter = "copilot",
    },
  },

  -- Prompt library (12 agents)
  prompt_library = prompt_library.setup(),

  -- Display settings
  display = display,

  -- Options
  opts = {
    log_level = "ERROR",
    send_code = true,
    use_default_actions = true,
    use_default_prompt_library = false, -- We use our custom prompt library
  },
}
