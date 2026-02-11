#!/usr/bin/env nvim -l

-- Test script to validate CodeCompanion agent system prompt configuration
-- Usage: nvim -l test-codecompanion-agent.lua [agent_name]

local agent_name = arg[1] or "Artificer"

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

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("Testing CodeCompanion Agent: " .. agent_name)
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

-- Set up minimal runtime path
vim.opt.runtimepath:prepend(vim.fn.expand("~/.config/nvim"))

-- Test 1: Load prompt_library
print("1️⃣  Loading prompt_library...")
local ok, prompt_lib = pcall(require, "config.codecompanion.prompt_library")
if not ok then
  print("❌ FAILED to load prompt_library")
  print("   Error: " .. tostring(prompt_lib))
  os.exit(1)
end
print("✅ prompt_library loaded\n")

-- Test 2: Get agent prompt function
print("2️⃣  Getting prompt function for " .. agent_name .. "...")
local prompt_fn = prompt_lib.get_agent_prompt(agent_name)
if not prompt_fn then
  print("❌ FAILED: Agent '" .. agent_name .. "' not found")
  print("   Available agents:")
  for name, _ in pairs(prompt_lib.setup()) do
    print("   - " .. name)
  end
  os.exit(1)
end
print("✅ Agent prompt function retrieved\n")

-- Test 3: Build system prompt
print("3️⃣  Building system prompt with mock context...")
local mock_ctx = {
  language = "English",
  date = os.date("%Y-%m-%d"),
  nvim_version = "0.10.0",
  os = "macOS",
  cwd = "/Users/john.enderby/test-project",
  project_root = "/Users/john.enderby/test-project",
  default_system_prompt = "[Default CodeCompanion prompt would be here]"
}

local system_prompt = prompt_fn(mock_ctx)
print("✅ System prompt generated\n")

-- Test 4: Analyze prompt content
print("4️⃣  Analyzing prompt content...")
print("   Length: " .. #system_prompt .. " characters")

local checks = {
  { pattern = agent_name, label = "Has agent name (" .. agent_name .. ")" },
  { pattern = "working[_%-]?style", label = "Has working_style reference", case_insensitive = true },
  { pattern = "code[_%-]?style", label = "Has code_style reference", case_insensitive = true },
  { pattern = "git", label = "Has git safety protocols", case_insensitive = true },
  { pattern = "AGENTS%.md", label = "Has AGENTS.md reference" },
}

print("")
for _, check in ipairs(checks) do
  local pattern = check.case_insensitive and check.pattern:lower() or check.pattern
  local content = check.case_insensitive and system_prompt:lower() or system_prompt
  if content:find(pattern, 1, true) then
    print("   ✅ " .. check.label)
  else
    print("   ❌ " .. check.label .. " - NOT FOUND")
  end
end

-- Test 5: Show preview
print("\n5️⃣  System prompt preview (first 500 chars):")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print(system_prompt:sub(1, 500) .. "...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

-- Test 6: Load init.lua config
print("6️⃣  Loading CodeCompanion init.lua config...")
local ok_init, config = pcall(require, "config.codecompanion.init")
if not ok_init then
  print("❌ FAILED to load init.lua")
  print("   Error: " .. tostring(config))
  os.exit(1)
end
print("✅ Config loaded\n")

-- Test 7: Check if system_prompt is configured in strategies.chat
print("7️⃣  Checking strategies.chat.opts.system_prompt configuration...")
if config.strategies and config.strategies.chat and config.strategies.chat.opts then
  if config.strategies.chat.opts.system_prompt then
    local sp_type = type(config.strategies.chat.opts.system_prompt)
    print("✅ system_prompt is configured (type: " .. sp_type .. ")")
    
    if sp_type == "function" then
      -- Set global variable to simulate switch_agent() behavior
      vim.g.current_agent = agent_name
      
      print("   Testing function with mock context (agent: " .. agent_name .. ")...")
      local test_result = config.strategies.chat.opts.system_prompt(mock_ctx)
      print("   Function returned: " .. #test_result .. " characters")
      
      if test_result:find(agent_name, 1, true) then
        print("   ✅ Function includes current agent name (" .. agent_name .. ")")
      else
        print("   ❌ Function does NOT include agent name - this is a problem!")
      end
    end
  else
    print("❌ system_prompt is NOT configured in strategies.chat.opts")
    print("   This means CodeCompanion will use default system prompt!")
  end
else
  print("❌ strategies.chat.opts structure not found in config")
end

print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ All tests complete!")
print("")
print("📊 Agent Configuration Summary:")
print("   Agent: " .. agent_name)
print("   Model: github-copilot/" .. (AGENT_MODELS[agent_name] or "claude-sonnet-4.5"))
print("   System Prompt: " .. #system_prompt .. " characters")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
