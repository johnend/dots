return {
  "nvim-lualine/lualine.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local status_ok, lualine = pcall(require, "lualine")
    if not status_ok then
      return
    end

    local function macro_recording()
      local recording_register = vim.fn.reg_recording()
      if recording_register == "" then
        return ""
      else
        return "Recording @" .. recording_register
      end
    end

    local components = require "core.config.lualine.components"
    local catppuccin = require "core.config.lualine.lualine-theme"

    lualine.setup {
      options = {
        -- custom theme imported above
        theme = catppuccin,
        -- rounded section separators one one side only
        section_separators = { left = "", right = "" },
        -- enable icons
        icons_enabled = true,
        -- disabled filetypes
        disabled_filetypes = {
          statusline = { "alpha" }, -- disable in dashboard
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        -- don't render multiple status lines (only show active buffer's)
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { components.mode, macro_recording },
        lualine_b = { components.branch },
        lualine_c = { components.diff, components.searchcount },
        lualine_x = { components.diagnostics, components.spaces, components.filetype },
        lualine_y = { components.location },
        lualine_z = { components.progress },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = { components.diagnostics, components.spaces, components.filetype },
        lualine_y = { components.location },
        lualine_z = { components.progress },
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
}
