local M = {}

-- Spinner stuff
local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_index = 1

local active_progress = false

-- Timer for animation
---@diagnostic disable-next-line: undefined-field
local timer = vim.uv.new_timer()
timer:start(
  0,
  120,
  vim.schedule_wrap(function()
    spinner_index = (spinner_index % #spinner_frames) + 1
  end)
)

-- Listen to $/progress messages
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function()
    active_progress = true
    vim.defer_fn(function()
      active_progress = false
    end, 1000)
  end,
})

local function lsp_status()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    return "No LSP"
  end

  local names = {}
  for _, client in ipairs(clients) do
    if client.name ~= "" then
      table.insert(names, client.name)
    end
  end

  local status = icons.ui.Gear .. " " .. table.concat(names, ", ")
  if active_progress then
    status = spinner_frames[spinner_index] .. " " .. status
  end

  return status
end

local function lsp_color()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    return { fg = colors.red }
  elseif active_progress then
    return { fg = colors.yellow }
  else
    return { fg = colors.green }
  end
end

M.lsp = {
  lsp_status,
  color = lsp_color,
  padding = { left = 1, right = 1 },
}

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
  icon_only = false,
  padding = { left = 0, right = 0 },
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
    local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
    return icons.ui.Tab .. " " .. shiftwidth
  end,
  padding = 1,
}

local location = {
  "location",
  padding = { left = 0, right = 1 },
}

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
  lsp = M.lsp,
}
