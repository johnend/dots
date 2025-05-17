return {
  "kosayoda/nvim-lightbulb",
  event = "BufRead",
  config = function()
    local status_ok, lightbulb = pcall(require, "nvim-lightbulb")
    if not status_ok then
      return
    end

    lightbulb.setup {
      autocmd = { enabled = true },
      sign = {
        enabled = false,
      },
      virtual_text = {
        enabled = true,
        text = icons.ui.Lightbulb,
      },
      status_text = {
        enabled = true,
      },
      filter = function(client_name, action)
        local title = (action.title or ""):lower()
        if title == "move to a new file" then
          return false
        end
        return true
      end,
    }
  end,
}
