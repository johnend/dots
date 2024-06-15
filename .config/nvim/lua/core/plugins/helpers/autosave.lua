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
        cleaning_interval = 700,
      },
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
      },
    }
  end,
}
