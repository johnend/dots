return {
  "nvim-lualine/lualine.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {},
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

    local components = require "config.lualine.components"
    local ts_context = require "treesitter-context"

    lualine.setup {
      options = {
        theme = "auto",
        -- rounded section separators one one side only
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        -- enable icons
        icons_enabled = true,
        -- disabled filetypes
        disabled_filetypes = {
          statusline = { "alpha" }, -- disable in dashboard only
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        -- don't render multiple status lines (only show active buffer's)
        globalstatus = true,
        refresh = {
          statusline = 300,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { components.mode, macro_recording },
        lualine_b = { components.branch },
        lualine_c = { components.diff, components.searchcount },
        lualine_x = {
          components.diagnostics,
          components.lsp,
          components.filename,
          components.filetype,
          components.codecompanion,
          components.spaces,
        },
        lualine_y = { components.location },
        lualine_z = { components.progress },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = { components.diagnostics, components.spaces, components.filename, components.filetype },
        lualine_y = { components.location },
        lualine_z = { components.progress },
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }

    -- Ensure statusline always shows, even in CodeCompanion buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "codecompanion",
      callback = function()
        vim.opt.laststatus = 3
        vim.wo.statusline = "" -- Clear window-local statusline (use global)
      end,
    })

    -- Also ensure when entering codecompanion windows
    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
      pattern = "*",
      callback = function()
        if vim.bo.filetype == "codecompanion" then
          vim.opt.laststatus = 3
          vim.wo.statusline = ""
        end
      end,
    })
  end,
}
