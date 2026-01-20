return {
  "catgoose/nvim-colorizer.lua",
  event = "BufEnter",
  config = function()
    local status_ok, colorizer = pcall(require, "colorizer")
    if not status_ok then
      return
    end
    colorizer.setup {
      "*",
      "!lazy",
      "!mason",
      user_default_options = {
        css = true,
        mode = "virtualtext",
        virtualtext = "■",
        always_update = true,
        names = false,
      },
      -- customise these filetypes
      css = { css = true },
      html = { css = true },
      javascript = { css = true },
    }
  end,
}
