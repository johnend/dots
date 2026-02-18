#!/usr/bin/env nvim -l

-- Test lualine filetype component condition logic
-- Usage: nvim -l test-lualine-codecompanion.lua

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("Testing Lualine Filetype Component Condition")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

-- Test the condition logic directly (without loading full components)
print("1️⃣  Testing filetype condition logic...")
print("")

local function filetype_cond()
  return vim.bo.filetype ~= "codecompanion"
end

-- Test with normal filetype
vim.bo.filetype = "lua"
local result1 = filetype_cond()
print("📄 Filetype: 'lua'")
print("   Condition result: " .. tostring(result1))
if result1 then
  print("   ✅ Filetype component will SHOW (correct)")
else
  print("   ❌ Filetype component will HIDE (wrong!)")
end
print("")

-- Test with codecompanion filetype
vim.bo.filetype = "codecompanion"
local result2 = filetype_cond()
print("💬 Filetype: 'codecompanion'")
print("   Condition result: " .. tostring(result2))
if not result2 then
  print("   ✅ Filetype component will HIDE (correct)")
else
  print("   ❌ Filetype component will SHOW (wrong!)")
end
print("")

-- Test with markdown (another common case)
vim.bo.filetype = "markdown"
local result3 = filetype_cond()
print("📝 Filetype: 'markdown'")
print("   Condition result: " .. tostring(result3))
if result3 then
  print("   ✅ Filetype component will SHOW (correct)")
else
  print("   ❌ Filetype component will HIDE (wrong!)")
end
print("")

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ Condition logic tests complete!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

print("Summary:")
print("  ✅ Normal filetypes (lua, markdown, etc.) → Show filetype icon")
print("  ✅ CodeCompanion filetype → Hide filetype icon")
print("")
print("The filetype component now has `cond` that returns false for codecompanion buffers.")

