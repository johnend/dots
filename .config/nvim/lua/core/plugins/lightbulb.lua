return {
  "kosayoda/nvim-lightbulb",
  event = "BufRead",
  config = function()
    require("nvim-lightbulb").update_lightbulb {
      sign = {
        enabled = false,
      },
      virtual_text = {
        enabled = true,
      },
      status_text = {
        enabled = true,
      },
    }
  end,
}
