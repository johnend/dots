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

-- Save colorscheme when it changes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("SaveColorscheme", { clear = true }),
  callback = function(args)
    local theme = args.match
    if theme == "default" then
      return
    end
    local path = vim.fn.stdpath "config" .. "/theme.json"
    local ok, f = pcall(io.open, path, "w")
    if ok and f then
      f:write(vim.json.encode { colorscheme = theme })
      f:close()
    end
  end,
})

-- Autosave functionality
vim.g.autosave_enabled = true
local autosave_group = vim.api.nvim_create_augroup("autosave", { clear = true })

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "VimLeavePre" }, {
  group = autosave_group,
  callback = function(event)
    if not vim.g.autosave_enabled then
      return
    end

    local bufnr = event.buf

    -- don't try to save unlisted buffers
    if not vim.bo[bufnr].buflisted then
      return
    end

    -- don't try to save special, scratch, or unnamed buffers
    local excluded_filetypes = { "" }
    if vim.tbl_contains(excluded_filetypes, vim.bo[bufnr].filetype) then
      return
    end

    local ok, conform = pcall(require, "conform")
    if ok then
      conform.format { bufnr = bufnr, lsp_fallback = true, timeout_ms = 500 }
    end

    vim.schedule(function()
      if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].modifiable then
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd "silent! write"
        end)
      end
    end)
  end,
})
