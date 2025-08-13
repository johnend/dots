-- ---------------------------------------
-- -- Colorscheme overrides
-- ---------------------------------------
-- local neovide_bgs = {
--   catppuccin = "#11111b",
--   ["rose-pine"] = "#11111b",
--   roseprime = "#11111b",
-- }
--
-- local function set_neovide_background()
--   local name = vim.g.colors_name
--   local bg = neovide_bgs[name]
--   if not bg then
--     return
--   end
--
--   for _, grp in ipairs {
--     "Normal",
--     "NormalNC",
--     "SignColumn",
--     "VertSplit",
--     "EndOfBuffer",
--   } do
--     vim.cmd(string.format("highlight %s guibg=%s", grp, bg))
--   end
-- end
--
-- -- Apply immediately if the theme’s already loaded
-- set_neovide_background()
--
-- -- Re-apply after *any* colorscheme change
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   callback = set_neovide_background,
--   desc = "Reapply Neovide bg override for selected themes",
-- })

---------------------------------------
-- Neovide overrides
---------------------------------------
vim.opt.guicursor = "v:hor20-Cursor,i:ver30-Cursor,n-v-c-i:blinkon500-blinkoff500-Cursor"
vim.api.nvim_set_hl(0, "Cursor", { fg = "NONE", bg = "#FF00AF" })

if vim.fn.has "linux" == 1 then
  vim.g.neovide_scale_factor = 0.7
end

-- Neovide config options
vim.g.neovide_cursor_animation_length = 0.210
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_opacity = 0.95
vim.g.neovide_normal_opacity = 0.8
--
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5

vim.g.neovide_floating_blur_amount_x = 5.0
vim.g.neovide_floating_blur_amount_y = 5.0
