return {
  "willothy/nvim-cokeline",
  event = { "BufRead", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "stevearc/resession.nvim",
  },
  keys = {
    {
      "<leader>tc",
      function()
        vim.o.showtabline = vim.o.showtabline == 2 and 0 or 2
        if vim.o.showtabline == 2 then
          local status_ok, cokeline = pcall(require, "cokeline")
          if not status_ok then
            vim.notify("Cokeline is not available!", vim.log.levels.ERROR)
            vim.o.showtabline = 0
            return
          end

          local active_bg_color = colors.surface0
          local inactive_bg_color = colors.mantle
          local active_text_color = colors.mauve
          local inactive_text_color = colors.subtext1
          local bg_color = colors.crust

          cokeline.setup {
            show_if_buffers_are_at_least = 1,
            mappings = {
              cycle_prev_next = true,
            },
            default_hl = {
              bg = function(buffer)
                if buffer.is_focused then
                  return active_bg_color
                else
                  return inactive_bg_color
                end
              end,
            },
            components = {
              {
                text = function()
                  return " "
                end,
                fg = function(buffer)
                  if buffer.is_focused then
                    return active_bg_color
                  else
                    return inactive_bg_color
                  end
                end,
                bg = function()
                  return bg_color
                end,
              },
              {
                text = function(buffer)
                  local status = ""
                  if buffer.is_readonly then
                    status = icons.ui.Lock
                  elseif buffer.is_modified then
                    status = icons.git.LineModified
                  end
                  return status
                end,
                fg = function(buffer)
                  if buffer.is_modified then
                    return colors.yellow
                  elseif buffer.is_readonly then
                    return colors.red
                  end
                end,
              },
              {
                text = function(buffer)
                  return " " .. buffer.devicon.icon .. " "
                end,
                fg = function(buffer)
                  if buffer.is_focused then
                    return buffer.devicon.color
                  end
                end,
              },
              {
                text = function(buffer)
                  return buffer.unique_prefix .. buffer.filename
                end,
                fg = function(buffer)
                  if buffer.is_focused then
                    return active_text_color
                  else
                    return inactive_text_color
                  end
                end,
                bold = true,
                underline = function(buffer)
                  if buffer.diagnostics.errors > 0 then
                    return true
                  end
                end,
              },
              {
                text = function(buffer)
                  local errors = buffer.diagnostics.errors
                  if errors <= 9 then
                    errors = ""
                  else
                    errors = "󱄲"
                  end
                  return " " .. errors .. " "
                end,
                fg = function(buffer)
                  if buffer.diagnostics.errors == 0 then
                    return colors.green
                  elseif buffer.diagnostics.errors <= 9 then
                    return colors.red
                  end
                end,
              },
              {
                text = " ",
                fg = function(buffer)
                  if buffer.is_focused then
                    return colors.text
                  else
                    return colors.subtext0
                  end
                end,
                delete_buffer_on_left_click = true,
              },
              {
                text = function()
                  return ""
                end,
                fg = function(buffer)
                  if buffer.is_focused then
                    return active_bg_color
                  else
                    return inactive_bg_color
                  end
                end,
                bg = function()
                  return bg_color
                end,
              },
            },
          } -- Dynamically initialize Cokeline
        end
      end,
      desc = "Toggle Cokeline Tabline",
    },
  },
}
