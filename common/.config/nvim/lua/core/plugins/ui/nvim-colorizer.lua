return {
  "catgoose/nvim-colorizer.lua",
  event = "BufEnter",
  config = function()
    local status_ok, colorizer = pcall(require, "colorizer")
    if not status_ok then
      return
    end
    colorizer.setup {
      filetypes = { "*" },
      user_default_options = {
        css = true,
        mode = "virtualtext",
        virtualtext = "■",
        always_update = true,
      },
      -- customise these filetypes
      css = { css = true },
      html = { css = true },
      javascript = { css = true },
    }

    -- disallow these filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "neo-tree", "TelescopePrompt", "oil", "alpha", "lazy", "mason" },
      callback = function()
        require("colorizer").detach_from_buffer()
      end,
    })
  end,
}
