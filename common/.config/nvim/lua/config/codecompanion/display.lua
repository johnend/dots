-- config/codecompanion/display.lua
-- Display and UI configuration for CodeCompanion

return {
  action_palette = {
    width = 95,
    height = 10,
    prompt = "Prompt ",
    provider = "telescope",
  },

  chat = {
    window = {
      layout = "vertical", -- vertical|horizontal|float|buffer
      width = 0.45,
      height = 0.8,
      relative = "editor",
      border = "rounded",
      zindex = 45,
    },
    intro_message = "Welcome! Type `/` to see available commands. Switch agents with `:Agent <name>` or use keybindings.",
  },
}
