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

  config.adjust_window_size_when_changing_font_size = false
  config.tab_max_width = 25
  config.switch_to_last_active_tab_when_closing_tab = true
  config.scrollback_lines = 5000

  config.initial_rows = 48
  config.initial_cols = 140

  config.front_end = "OpenGL"
end

return behaviour
