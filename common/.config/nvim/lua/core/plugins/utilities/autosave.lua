return {
  "okuuva/auto-save.nvim",
  cmd = "ASToggle",
  event = { "BufLeave", "BufWinLeave", "FocusLost", "QuitPre", "VimLeavePre", "VimSuspend", "WinLeave" },
  config = function()
    local status_ok, save = pcall(require, "auto-save")
    if not status_ok then
      return
    end

    local excluded_filetypes = { "alpha", "oil", "water", "neo-tree", "help" }

    save.setup {
      enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
      trigger_events = { -- See :h events
        immediate_save = { "BufLeave", "BufWinLeave", "FocusLost", "QuitPre", "VimLeavePre", "VimSuspend", "WinLeave" }, -- vim events that trigger an immediate save
        defer_save = {}, -- vim events that trigger a deferred save (saves after `debounce_delay`)
        cancel_deferred_save = {}, -- vim events that cancel a pending deferred save
      },
      -- function that takes the buffer handle and determines whether to save the current buffer or not
      -- return true: if buffer is ok to be saved
      -- return false: if it's not ok to be saved
      -- if set to `nil` then no specific condition is applied
      condition = function(bufnr)
        -- skip any namesless buffer
        --
        if vim.fn.expand("%", bufnr) == "" then
          return false
        end

        -- skip non-normal buffers (terminals, etc)
        if vim.bo[bufnr].buftype ~= "" then
          return false
        end

        -- skip excluded filetypes
        local ft = vim.bo[bufnr].ft or ""
        if vim.tbl_contains(excluded_filetypes, ft) then
          return false
        end

        return true
      end,
      write_all_buffers = true, -- write all buffers when the current one meets `condition`
      noautocmd = false, -- do not execute autocmds when saving
      lockmarks = false, -- lock marks when saving, see `:h lockmarks` for more details
      debounce_delay = 1000, -- delay after which a pending save is executed
      -- log debug messages to 'auto-save.log' file in neovim cache directory, set to `true` to enable
      debug = false,
    }

    local group = vim.api.nvim_create_augroup("autosave", {})

    vim.api.nvim_create_autocmd("User", {
      pattern = "AutoSaveWritePost",
      group = group,
      callback = function(opts)
        if opts.data.saved_buffer ~= nil then
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(opts.data.saved_buffer), ":t")
          vim.notify("AutoSave: saved " .. filename, vim.log.levels.INFO, { timeout = 1000 })
        end
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "AutoSaveEnable",
      group = group,
      callback = function(opts)
        vim.notify("AutoSave enabled", vim.log.levels.INFO)
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "AutoSaveDisable",
      group = group,
      callback = function(opts)
        vim.notify("AutoSave disabled", vim.log.levels.INFO)
      end,
    })
  end,
}
