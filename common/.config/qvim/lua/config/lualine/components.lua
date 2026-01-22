local M = {}

-- Spinner stuff
local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_index = 1

local active_progress = false

-- Timer for animation
---@diagnostic disable-next-line: undefined-field
local timer = vim.uv.new_timer()

if not timer or type(timer.start) ~= "function" then
  vim.notify("Failed to created uv timer", vim.log.levels.ERROR)
  return
end

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
  -- hide LSP status in certain filetypes
  local skip_filetypes = {
    ["neo-tree"] = true,
    ["alpha"] = true,
    ["water"] = true,
    -- add any others you’d like to skip
  }

  local ft = vim.bo.filetype
  if skip_filetypes[ft] then
    return ""
  end

  -- get all attached clients for this buffer
  local clients = vim.lsp.get_clients { vim.api.nvim_get_current_buf() }
  if #clients == 0 then
    return "No LSP"
  end

  -- filetype-specific priority lists
  local filetype_prio = {
    typescript = { "vtsls", "tsserver", "eslint" },
    typescriptreact = { "vtsls", "tsserver", "eslint" },
    javascript = { "tsserver", "eslint" },
    javascriptreact = { "tsserver", "eslint" },
    css = { "cssls", "css_variables", "cssmodules_ls" },
    json = { "jsonls" },
    -- add more overrides here as needed
  }

  -- global fallback priority
  local global_prio = {
    "bashls",
    "cssls",
    "css_variables",
    "cssmodules_ls",
    "emmet_language_server",
    "eslint",
    "graphql",
    "helm_ls",
    "html",
    "jsonls",
    "lua_ls",
    "pyright",
    "somesass_ls",
    "terraformls",
    "tflint",
    "vtsls",
    "yamlls",
  }

  -- pick the right master list
  local ft = vim.bo.filetype
  local prio = filetype_prio[ft] or global_prio

  -- find the first attached client matching our priority
  local chosen
  for _, name in ipairs(prio) do
    for _, c in ipairs(clients) do
      if c.name == name then
        chosen = name
        break
      end
    end
    if chosen then
      break
    end
  end

  -- fallback to the very first client
  if not chosen then
    chosen = clients[1].name
  end

  -- nerdfont icons per LSP
  local icons = {
    bashls = "",
    cssls = "",
    css_variables = "",
    cssmodules_ls = "",
    emmet_language_server = "󰅴",
    eslint = "",
    graphql = "",
    helm_ls = "",
    html = "",
    jsonls = "",
    lua_ls = "",
    pyright = "",
    somesass_ls = "󰟬",
    terraformls = "",
    tflint = "",
    vtsls = "",
    yamlls = "",
  }

  local icon = Icons[chosen] or ""
  return icon .. " " .. chosen
end

local function lsp_color()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    return { fg = Colors.red }
  elseif active_progress then
    return { fg = Colors.yellow }
  else
    return { fg = Colors.green }
  end
end

M.lsp = {
  lsp_status,
  color = lsp_color,
  padding = { left = 1, right = 1 },
}

M.mode = {
  function()
    return " " .. Icons.ui.Target .. " "
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

M.diff = {
  "diff",
  symbols = {
    added = Icons.git.LineAdded .. " ",
    modified = Icons.git.LineModified .. " ",
    removed = Icons.git.LineRemoved .. " ",
  },
  padding = { left = 2, right = 1 },
  diff_color = {
    added = { fg = Colors.green },
    modified = { fg = Colors.yellow },
    removed = { fg = Colors.red },
  },
  source = diff_source(),
  cond = nil,
}

M.repo = {
  function()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns and gitsigns.root then
      return vim.fn.fnamemodify(gitsigns.root, ":t")
    end
    return ""
  end,
  icon = Icons.git.Repo,
  color = { gui = "bold" },
}

M.branch = {
  "b:gitsigns_head",
  icon = Icons.git.Branch,
  color = { gui = "bold" },
}

M.filename = {
  "filename",
  path = 4,
  separator = { left = "" },
  symbols = { modified = Icons.git.LineModified, readonly = Icons.ui.Lock },
  color = {},
  cond = nil,
  fmt = function(str)
    if vim.bo.filetype == "codecompanion" then
      return "CodeCompanion" .. " " .. Icons.misc.Brain
    end

    return str
  end,
}

M.filetype = {
  "filetype",
  colored = true,
  icon_only = true,
  separator = { left = "", right = "" },
}

M.diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = {
    error = Icons.diagnostics.BoldError .. " ",
    warn = Icons.diagnostics.BoldWarning .. " ",
    info = Icons.diagnostics.BoldInformation .. " ",
    hint = Icons.diagnostics.BoldHint .. " ",
  },
}

M.spaces = {
  function()
    local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
    return Icons.ui.Tab .. " " .. shiftwidth
  end,
  padding = 1,
}

M.location = {
  "location",
  padding = { left = 0, right = 1 },
}

M.progress = {
  "progress",
  fmt = function()
    return "%P/%L"
  end,
  padding = 1,
}

M.searchcount = {
  "searchcount",
  icon = Icons.ui.Search,
  color = {},
  cond = nil,
}

return M
