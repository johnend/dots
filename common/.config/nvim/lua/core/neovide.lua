---------------------------------------
-- Neovide overrides
---------------------------------------
vim.opt.guicursor = "v:hor20-Cursor,i:ver30-Cursor,n-v-c-i:blinkon500-blinkoff500-Cursor"
vim.api.nvim_set_hl(0, "Cursor", { fg = "NONE", bg = "#FF00AF" })

if vim.fn.has "linux" == 1 then
  vim.g.neovide_scale_factor = 0.7
end

-- Neovide config options
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_left = 0
vim.g.neovide_padding_right = 0

vim.g.neovide_cursor_animation_length = 0.210
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_opacity = 0.9
vim.g.neovide_normal_opacity = 0.9

vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5
-- vim.g.neovide_window_blurred = true

vim.g.neovide_floating_blur_amount_x = 7.0
vim.g.neovide_floating_blur_amount_y = 7.0

vim.g.neovide_position_animaton_length = 0.13
vim.g.neovide_scroll_animaton_length = 0.21
