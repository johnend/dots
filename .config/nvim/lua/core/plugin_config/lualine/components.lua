local mode = {
  function()
    return " " .. icons.ui.Target .. " "
  end,
  padding = { left = 0, right = 0 },
}

local function diff_source()
  local gitsigns = { "b: gitsigns_status_dict" }
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.modified,
      removed = gitsigns.removed,
    }
  end
end

local diff = {
  "diff",
  symbols = {
    added = icons.git.LineAdded .. " ",
    modified = icons.git.LineModified .. " ",
    removed = icons.git.LineRemoved .. " ",
  },
  padding = { left = 2, right = 1 },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.yellow },
    removed = { fg = colors.red },
  },
  source = diff_source(),
  cond = nil,
}

local branch = {
  "b:gitsigns_head",
  icon = icons.git.Branch,
  color = { gui = "bold" },
}

local filename = {
  "filename",
  icon = icons.ui.File,
  color = {},
  cond = nil,
}

local filetype = {
  "filetype",
  colored = true,
  icon_only = true,
  padding = { left = 2, right = 1 },
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = {
    error = icons.diagnostics.BoldError .. " ",
    warn = icons.diagnostics.BoldWarning .. " ",
    info = icons.diagnostics.BoldInformation .. " ",
    hint = icons.diagnostics.BoldHint .. " ",
  },
}

local spaces = {
  function()
    local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
    return icons.ui.Tab .. " " .. shiftwidth
  end,
  padding = 1,
}

local location = { "location" }

local progress = {
  "progress",
  fmt = function()
    return "%P/%L"
  end,
  padding = 1,
}

local searchcount = {
  "searchcount",
  icon = icons.ui.Search,
  color = {},
  cond = nil,
}

return {
  mode = mode,
  branch = branch,
  diff = diff,
  diagnostics = diagnostics,
  filename = filename,
  encoding = {},
  fileformat = {},
  filetype = filetype,
  progress = progress,
  location = location,
  searchcount = searchcount,
  spaces = spaces,
}
