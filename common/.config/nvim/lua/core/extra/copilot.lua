return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    local status_ok, copilot = pcall(require, "copilot")
    if not status_ok then
      return
    end
    copilot.setup {
      panel = {
        layout = {
          position = "right",
          ratio = 0.3,
        },
        keymap = {
          open = "<M-p>",
        },
      },
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<M-Return>",
        },
      },
    }
  end,
}
