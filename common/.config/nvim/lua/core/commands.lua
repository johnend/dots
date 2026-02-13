vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]

local autocommand = vim.api.nvim_create_autocmd
autocommand({ "CursorMoved", "CursorMovedI", "WinLeave", "BufLeave", "BufWinLeave" }, {
  callback = function()
    local win = vim.diagnostic.get_open_float and vim.diagnostic.get_open_float()
    if win then
      vim.diagnostic.close_float()
    end
  end,
})

-- Open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
})

-- Show cursor line only in active window
local ignore = { alpha = true, toggleterm = true }

local group = vim.api.nvim_create_augroup("active_cursorline", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = group,
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ignore[ft] then
      vim.opt_local.cursorline = false
      return
    end
    vim.opt_local.cursorline = true
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = group,
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ignore[ft] then
      return
    end
    vim.opt_local.cursorline = false
  end,
})

-- Highlight when yanking text
autocommand("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.hl.on_yank { timeout = 200, visual = true }
  end,
})

-- Disable syntax highlighting for long files
autocommand("BufEnter", {
  pattern = "*",
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count > 5000 then
      vim.cmd "syntax off"
    end
  end,
})

-- Disable syntax highlighting in large files
autocommand("BufReadPre", {
  pattern = "*",
  callback = function()
    local max_filesize = 100 * 1024 -- 100kb
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > max_filesize then
      vim.cmd "syntax off"
    end
  end,
})

-- Reload automatically if changed outside
autocommand("FocusGained", {
  pattern = "*",
  command = "checktime",
})

-- Dynamically resize splits when terminal window is resized
autocommand("VimResized", {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

-- Disable completion in markdown and text
-- autocommand("FileType", {
--   pattern = { "markdown", "text" },
--   callback = function()
--     vim.cmd "LspStop"
--   end,
-- })

-- Refresh NeoTree when leaving LazyGit terminal
autocommand("BufLeave", {
  pattern = { "*lazygit*" },
  group = vim.api.nvim_create_augroup("git_refresh_neotree", { clear = true }),
  callback = function()
    local manager = require "neo-tree.sources.manager"
    local state = manager.get_state "filesystem"
    if state and type(state.window) == "number" and vim.api.nvim_win_is_valid(state.window) then
      require("neo-tree.sources.filesystem.commands").refresh(state)
    end
  end,
})

-- Override highlight groups globally
autocommand({ "VimEnter", "ColorScheme" }, {
  pattern = "*",
  callback = function()
    -- Link NeoTree background to floating window style for lighter background
    vim.cmd "highlight link NeoTreeNormal NormalFloat"
    vim.cmd "highlight link NeoTreeNormalNC NormalFloat"

    -- Link 'NeoTreeWinSeparator' to 'FloatBorder'
    if
      vim.g.colors_name == "roseprime"
      or vim.g.colors_name == "iceclimber"
      or vim.g.colors_name == "gyokuro"
      or vim.g.colors_name == "hojicha"
    then
      vim.cmd "highlight NeoTreeWinSeparator guibg=none"
    else
      vim.cmd "highlight link NeoTreeWinSeparator FloatBorder"
    end

    -- Set 'FlashMatch' and 'FlashLabel' colors explicitly
    vim.cmd "highlight FlashLabel guifg=#00fa9a guibg=#000000 gui=bold"
  end,
})

-- Open Alpha after Lazy installs plugins
autocommand("VimEnter", {
  callback = function()
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.cmd "Alpha"
    end
  end,
})

-- Custom command to list attached LSPs
vim.api.nvim_create_user_command("LspNames", function(opts)
  local target = opts.args
  local clients = vim.lsp.get_clients { bufnr = 0 }
  local icon = ""
  local output = {}

  if vim.tbl_isempty(clients) then
    vim.notify("󰍴  No LSP clients attached to this buffer", vim.log.levels.INFO, { title = "LSP Info" })
    return
  end

  for _, client in pairs(clients) do
    if target == "" or client.name:lower():match(target:lower()) then
      local root_dir = client.config.root_dir or "?"
      local capabilities = {}
      local caps = client.server_capabilities or {}

      if caps.hoverProvider then
        table.insert(capabilities, "hover")
      end
      if caps.definitionProvider then
        table.insert(capabilities, "definition")
      end
      if caps.referencesProvider then
        table.insert(capabilities, "references")
      end
      if caps.documentFormattingProvider then
        table.insert(capabilities, "formatting")
      end
      if caps.renameProvider then
        table.insert(capabilities, "rename")
      end
      if caps.completionProvider then
        table.insert(capabilities, "completion")
      end

      table.insert(
        output,
        string.format(
          "%s  %s\n    root: %s\n    capabilities: %s",
          icon,
          client.name,
          root_dir,
          next(capabilities) and table.concat(capabilities, ", ") or "none"
        )
      )
    end
  end

  vim.notify(table.concat(output, "\n\n"), vim.log.levels.INFO, { title = "LSP Info", timeout = 5000 })
end, {
  nargs = "?",
})

-- Save colorscheme when it changes (preserves transparency in theme.json)
-- and re-apply transparency in the same event to avoid a flash of opaque theme
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("SaveColorscheme", { clear = true }),
  callback = function(args)
    local theme = args.match
    local colorscheme = require("core.colorscheme")
    colorscheme.save_state({ colorscheme = theme })
    colorscheme.reapply_transparency_if_enabled()
  end,
})

-- CodeCompanion progress using snacks
local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", { clear = true })
local icons = require "config.icons"

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanion*",
  group = group,
  callback = function(request)
    if vim.endswith(request.match, "ContextChanged") then
      return
    end
    if request.match == "CodeCompanionChatSubmitted" then
      return
    end

    local function camel_to_sentence(str)
      local s = str:gsub("(%u)", " %1"):gsub("^%s+", "")
      return (s:sub(1, 1):upper() .. s:sub(2):lower())
    end

    local event_name = request.match:gsub("CodeCompanion", "")
    local msg = "[CodeCompanion] " .. camel_to_sentence(event_name)
    -- Icon mapping for CodeCompanion events
    local event_icons = {
      Started = Icons.ui.BoldArrowRight,
      Finished = Icons.ui.Check,
      Error = Icons.diagnostics.Error,
      Warning = Icons.diagnostics.Warning,
      Information = Icons.diagnostics.Information,
      Hint = Icons.diagnostics.Hint,
      Opened = Icons.ui.FolderOpen,
      Closed = Icons.ui.Folder,
      Cleared = Icons.ui.Broom or Icons.ui.BoldClose,
      Created = Icons.ui.NewFile,
      ContextChanged = Icons.ui.History,
      Hidden = Icons.ui.Ellipsis,
      Visible = Icons.ui.Eye or Icons.ui.Circle,
      Progress = Icons.ui.Telescope,
      Cancelled = Icons.diagnostics.BoldError,
      Timeout = Icons.diagnostics.Warning,
      Success = Icons.ui.Check,
      Failure = Icons.diagnostics.Error,
      TestCovered = Icons.ui.TestCovered,
      TestUncovered = Icons.ui.TestUncovered,
      RequestStreaming = Icons.ui.Telescope,
    }

    vim.notify(msg, 2, {
      timeout = 1000,
      keep = function()
        return not vim
          .iter({ "Finished", "Done", "Opened", "Hidden", "Closed", "Cleared", "Created", "ContextChanged" })
          :fold(false, function(acc, cond)
            return acc or vim.endswith(request.match, cond)
          end)
      end,
      id = "code_companion_status",
      title = "Code Companion Status",
      opts = function(notif)
        local icon = ""
        for event, event_icon in pairs(event_icons) do
          if vim.endswith(request.match, event) then
            icon = event_icon or ""
            break
          end
        end
        if vim.endswith(request.match, "Started") then
          ---@diagnostic disable-next-line: undefined-field
          icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end
        notif.icon = icon
      end,
    })
  end,
})

-- CodeCompanion Markview Setup
local codecompanion_group = vim.api.nvim_create_augroup("CodeCompanionMarkview", { clear = true })

autocommand("FileType", {
  group = codecompanion_group,
  pattern = "codecompanion",
  callback = function()
    -- Set conceallevel for markview to work
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = ""
  end,
})

-- Alternative approach - also handle by buffer name if filetype detection isn't working
autocommand("BufEnter", {
  group = codecompanion_group,
  pattern = "*",
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname:match "codecompanion" or vim.bo.filetype == "codecompanion" then
      vim.opt_local.conceallevel = 2
      vim.opt_local.concealcursor = ""
    end
  end,
})
