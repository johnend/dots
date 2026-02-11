local M = {}

-- Helper function to get buffer name
local function get_buffer_name(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return "[No Name]"
  end
  return vim.fn.fnamemodify(name, ":t") -- just filename
end

-- Helper function to check if buffer is modified
local function is_modified(bufnr)
  return vim.api.nvim_get_option_value("modified", { buf = bufnr })
end

-- Buffers component (left side)
M.buffers = {
  "buffers",
  mode = 2, -- 0: shows buffer name
            -- 1: buffer index
            -- 2: buffer name + buffer index
            -- 3: buffer number
            -- 4: buffer name + buffer number
  max_length = function()
    return vim.o.columns * 2 / 3 -- Use 2/3 of screen for buffers
  end,
  filetype_names = {
    TelescopePrompt = "Telescope",
    dashboard = "Dashboard",
    lazy = "Lazy",
    alpha = "Alpha",
    codecompanion = "CodeCompanion",
  },
  buffers_color = {
    active = "lualine_a_normal",
    inactive = "lualine_c_inactive",
  },
  symbols = {
    modified = " " .. Icons.git.LineModified,
    alternate_file = "",
    directory = "",
  },
  use_mode_colors = false,
  show_filename_only = true,
  show_modified_status = true,
}

-- Tabs component (right side)
M.tabs = {
  "tabs",
  mode = 1, -- 0: Shows tab_nr
            -- 1: Shows tab_name
            -- 2: Shows tab_nr + tab_name
  tabs_color = {
    active = "lualine_a_normal",
    inactive = "lualine_c_inactive",
  },
  cond = function()
    -- Only show tabs component if there's more than 1 tab
    return vim.fn.tabpagenr("$") > 1
  end,
}

return M
