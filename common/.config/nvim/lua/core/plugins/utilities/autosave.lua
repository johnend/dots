-- lua/config/autosave.lua

vim.g.autosave_enabled = true

local group = vim.api.nvim_create_augroup("autosave", { clear = true })

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "VimLeavePre" }, {
  group = group,
  callback = function(event)
    if not vim.g.autosave_enabled then
      return
    end

    local bufnr = event.buf

    -- Skip special, scratch, or unnamed buffers
    if vim.bo[bufnr].buftype ~= "" or vim.api.nvim_buf_get_name(bufnr) == "" then
      return
    end

    -- Optional: skip specific filetypes
    local excluded_filetypes = { "alpha", "neo-tree", "help", "oil", "water" }
    if vim.tbl_contains(excluded_filetypes, vim.bo[bufnr].filetype) then
      return
    end

    if not vim.bo[bufnr].modified then
      return
    end

    -- Format before write (via conform.nvim)
    local ok, conform = pcall(require, "conform")
    if ok then
      conform.format { bufnr = bufnr, lsp_fallback = true, timeout_ms = 500 }
    end

    -- Silent write inside buffer context
    vim.schedule(function()
      if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].modifiable then
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd "silent! write"
        end)
      end
    end)
  end,
})

return {}
