return {
  "okuuva/auto-save.nvim",
  cmd = "ASToggle",
  event = { "InsertLeave", "TextChanged" },
  config = function()
    local status_ok, save = pcall(require, "auto-save")
    if not status_ok then
      return
    end

    save.setup {
      enabled = true,
      execution_message = {
        enabled = true,
        message = function()
          return (icons.misc.CircuitBoard .. " Saved: " .. vim.fn.expand "%:t")
        end,
        dim = 0.18,
        cleaning_interval = 500,
      },
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        -- uncomment the following lines to turn off saving after buffer changes
        defer_save = {},
        cancel_defered_save = {},
      },
      debounce_delay = 1500,
      conditon = function(buf)
        local fn = vim.fn
        local utils = require "auto-save.utils.data"
        if fn.getbutvar(buf, "&buftype") ~= "" then
          return false
        end

        if
          utils.not_in(fn.getbufvar(buf, "&filetype"), {
            "dirvish",
            "fugitive",
            "alpha",
            "neo-tree",
            "lazy",
            "Trouble",
            "Outline",
            "spectre_panel",
            "toggleterm",
            "TelescopePrompt",
            "WhichKey",
          })
        then
          return false
        end

        return true
      end,
    }
  end,
}
