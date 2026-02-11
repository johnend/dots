-- config/keymaps/ai.lua
-- All CodeCompanion AI keybindings under <leader>c

local hooks = require("config.codecompanion.hooks")
local Icons = require("config.icons")

-- Agent to model mapping (from OpenCode agents)
local AGENT_MODELS = {
  Artificer = "claude-sonnet-4.5",
  Mentor = "claude-sonnet-4.5",
  Scribe = "claude-sonnet-4.5",
  Chronicler = "claude-sonnet-4.5",
  Seer = "gpt-5.2",
  Sentinel = "claude-haiku-4.5",
  Investigator = "gpt-5.2-codex",
  Bard = "gemini-3-pro",
  Pathfinder = "gemini-3-flash",
  Coach = "gemini-3-pro",
  Steward = "gemini-3-flash",
  Visionary = "gemini-3-pro",
}

-- Helper function to switch agents using prompt library
local function switch_agent(agent_name)
  -- Capitalize agent name (e.g., "artificer" -> "Artificer")
  local capitalized = agent_name:sub(1,1):upper() .. agent_name:sub(2)
  
  -- Set global for both lualine display AND init.lua system_prompt function
  vim.g.current_agent = capitalized
  
  -- Get model for this agent
  local model = AGENT_MODELS[capitalized] or "claude-sonnet-4.5"
  
  -- Open CodeCompanion chat with specific model
  vim.cmd("CodeCompanionChat adapter=copilot model=github-copilot/" .. model)
  
  vim.notify("Opened " .. capitalized .. " chat (" .. model .. ")", vim.log.levels.INFO)
end

return {
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- CODECOMPANION MAIN GROUP
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  { "<leader>c", group = "CodeCompanion", icon = Icons.misc.Robot },

  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- CORE CODECOMPANION ACTIONS (top level)
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  { "<leader>cc", "<cmd>CodeCompanionChat<cr>", desc = "Open Chat", icon = Icons.ui.Comment },
  { "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle Chat", icon = Icons.ui.ToggleOff },
  {
    "<leader>cn",
    "<cmd>CodeCompanionActions<cr>",
    desc = "Actions Menu",
    icon = Icons.ui.Fire,
    mode = { "n", "v" },
  },

  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- AGENTS SUBMENU (<leader>ca)
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  { "<leader>ca", group = "Agents", icon = Icons.ui.Stacks },
  {
    "<leader>caa",
    function()
      switch_agent "artificer"
    end,
    desc = "Artificer (main builder)",
    icon = Icons.ai.Artificer,
  },
  {
    "<leader>cam",
    function()
      switch_agent "mentor"
    end,
    desc = "Mentor (teach/review)",
    icon = Icons.ai.Mentor,
  },
  {
    "<leader>cas",
    function()
      switch_agent "scribe"
    end,
    desc = "Scribe (documentation)",
    icon = Icons.ai.Scribe,
  },
  {
    "<leader>cav",
    function()
      switch_agent "seer"
    end,
    desc = "Seer (clarify)",
    icon = Icons.ai.Seer,
  },
  {
    "<leader>caf",
    function()
      switch_agent "sentinel"
    end,
    desc = "Sentinel (fast <5min)",
    icon = Icons.ai.Sentinel,
  },
  {
    "<leader>cah",
    function()
      switch_agent "chronicler"
    end,
    desc = "Chronicler (research)",
    icon = Icons.ai.Chronicler,
  },
  {
    "<leader>cai",
    function()
      switch_agent "investigator"
    end,
    desc = "Investigator (debug)",
    icon = Icons.ai.Investigator,
  },
  {
    "<leader>cab",
    function()
      switch_agent "bard"
    end,
    desc = "Bard (UI specialist)",
    icon = Icons.ai.Bard,
  },
  {
    "<leader>cap",
    function()
      switch_agent "pathfinder"
    end,
    desc = "Pathfinder (explore)",
    icon = Icons.ai.Pathfinder,
  },
  {
    "<leader>cao",
    function()
      switch_agent "coach"
    end,
    desc = "Coach (fitness)",
    icon = Icons.ai.Coach,
  },
  {
    "<leader>caw",
    function()
      switch_agent "steward"
    end,
    desc = "Steward (home)",
    icon = Icons.ai.Steward,
  },
  {
    "<leader>cay",
    function()
      switch_agent "visionary"
    end,
    desc = "Visionary (ideas)",
    icon = Icons.ai.Visionary,
  },

  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- HOOKS SUBMENU (<leader>ch)
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  { "<leader>ch", group = "Hooks", icon = Icons.misc.Hook },
  {
    "<leader>chg",
    function()
      local task = vim.fn.input "Task for GloomStalker: "
      if task == "" then
        return
      end

      local result = hooks.run_gloomstalker(task)
      hooks.show_in_float(result, "GloomStalker Context", { height = 25 })
    end,
    desc = "GloomStalker (load context)",
    icon = Icons.misc.Spotlight,
  },

  {
    "<leader>chr",
    function()
      local operation = vim.fn.input "Operation to assess: "
      if operation == "" then
        return
      end

      local result = hooks.run_risk_assessor(operation)
      local data = hooks.parse_json(result)

      if data and data.riskLevel then
        local icon_str
        if data.riskLevel == "critical" then
          icon_str = Icons.diagnostics.BoldError
        elseif data.riskLevel == "high" then
          icon_str = Icons.diagnostics.BoldWarning
        elseif data.riskLevel == "medium" then
          icon_str = Icons.ui.Fire
        else
          icon_str = Icons.diagnostics.BoldInformation
        end

        vim.notify(icon_str .. " Risk Level: " .. data.riskLevel, vim.log.levels.INFO)
      end

      hooks.show_in_float(result, "Risk Assessment", { height = 20 })
    end,
    desc = "Risk Assessor (check safety)",
    icon = Icons.diagnostics.BoldWarning,
  },

  {
    "<leader>chd",
    function()
      -- Switch to Scribe first
      switch_agent "scribe"

      vim.defer_fn(function()
        local topic = vim.fn.input "Document what: "
        if topic == "" then
          return
        end

        local cwd = vim.fn.getcwd()
        local result = hooks.run_chronicle(topic, cwd)
        vim.notify(Icons.ui.Note .. " " .. result, vim.log.levels.INFO)
      end, 100)
    end,
    desc = "Chronicle (document to Obsidian)",
    icon = Icons.ui.Note,
  },

  {
    "<leader>cht",
    function()
      local task = vim.fn.input "Task description: "
      if task == "" then
        return
      end

      local result = hooks.run_todo_enforcer(task)
      local data = hooks.parse_json(result)

      if data and data.isMultiStep then
        vim.notify(Icons.ui.List .. " Multi-step task detected!", vim.log.levels.INFO)

        if data.suggestedTodos then
          -- Show suggested todos
          local todos = { "Suggested Todos:", "" }
          for i, todo in ipairs(data.suggestedTodos) do
            table.insert(todos, string.format("%d. %s", i, todo.content))
          end
          hooks.show_in_float(table.concat(todos, "\n"), "Todo Breakdown", { height = 15 })
        end
      else
        vim.notify(Icons.ui.Check .. " Single-step task - no todos needed", vim.log.levels.INFO)
      end
    end,
    desc = "Todo Enforcer (check complexity)",
    icon = Icons.ui.List,
  },

  {
    "<leader>chz",
    function()
      local result = hooks.run_git_status_checker()
      hooks.show_in_float(result, "Enhanced Git Status", { filetype = "markdown", height = 30 })
    end,
    desc = "Git Status (enhanced)",
    icon = Icons.git.Diff,
  },

  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  -- VISUAL MODE ACTIONS (on selection)
  -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  {
    mode = { "v" },
    { "<leader>ce", "<cmd>CodeCompanion explain<cr>", desc = "Explain selection", icon = Icons.ui.Lightbulb },
    { "<leader>cF", "<cmd>CodeCompanion fix<cr>", desc = "Fix selection", icon = Icons.ui.Gear },
    { "<leader>cO", "<cmd>CodeCompanion optimize<cr>", desc = "Optimize selection", icon = Icons.ui.Fire },
    { "<leader>cR", "<cmd>CodeCompanion refactor<cr>", desc = "Refactor selection", icon = Icons.ui.Code },
  },
}
