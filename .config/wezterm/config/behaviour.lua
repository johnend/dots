local wezterm = require "wezterm"

local behaviour = {}

function behaviour.apply_to_config(config)
  -- set config options here
  -- config.config_option = config_option_value
  config.window_close_confirmation = "NeverPrompt"

  config.skip_close_confirmation_for_processes_named = {
    "bash",
    "sh",
    "zsh",
    "fish",
    "tmux",
    "nu",
    "cmd.exe",
    "pwsh.exe",
    "powershell.exe",
  }
end

return behaviour
