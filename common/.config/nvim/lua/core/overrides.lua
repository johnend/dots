-- Check if any colorscheme is loaded
local current_colorscheme = vim.g.colors_name
local status = function()
  vim.cmd "highlight StatusLine guibg=#222222 guifg=#eeeeee"
end -- replace with your preferred colors
local status_nc = function()
  vim.cmd "highlight StatusLineNC guibg=#222222 guifg=#eeeeee"
end -- optional: inactive windows

if not current_colorscheme or current_colorscheme == "default" then
  -- Set statusline background and foreground
  status()
  status_nc()
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    if not vim.g.colors_name or vim.g.colors_name == "" or vim.g.colors_name == "default" then
      status()
      status_nc()
    end
  end,
})
