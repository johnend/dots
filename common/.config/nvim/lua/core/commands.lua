-- Normal commands
vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]

local autocommand = vim.api.nvim_create_autocmd

-- Auto-commands
-- Highlight when yanking text
autocommand("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("quantum-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
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
    -- Link 'NeoTreeWinSeparator' to 'FloatBorder'
    if vim.g.colors_name == "roseprime" or "iceclimber" or "gyokuro" or "hojicha" then
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
