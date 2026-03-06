return {
  "willothy/nvim-cokeline",
  event = { "BufRead", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    -- "stevearc/resession.nvim", -- for persistent sessions (optional)
  },
  config = function()
    local status_ok, cokeline = pcall(require, "cokeline")
    if not status_ok then
      return
    end

    local get_hex = require("cokeline.hlgroups").get_hl_attr

    cokeline.setup {
      show_if_buffers_are_at_least = 2,
      mappings = {
        cycle_prev_next = true,
      },
      sidebar = {
        filetype = { "neo-tree" },
        components = {
          {
            text = function(buf)
              return buf.filetype
            end,
            bg = function()
              return get_hex("NeoTreeNormal", "bg")
            end,
          },
        },
      },
      components = {
        {
          text = function(buffer)
            local status = ""
            if buffer.is_readonly then
              status = Icons.ui.Lock
            elseif buffer.is_modified then
              status = Icons.git.LineModified
            end
            return status
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
              errors = ""
            elseif errors <= 9 then
              errors = ""
            else
              errors = "󱄲"
            end
            return " " .. errors .. " "
          end,
        },
        {
          text = " ",
          delete_buffer_on_left_click = true,
        },
      },
    }
  end,
}
