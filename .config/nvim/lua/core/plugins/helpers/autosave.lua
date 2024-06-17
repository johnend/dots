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
    }
  end,
}
