---@param global_flag string The name of the global toggle variable (without _G.)
---@param toggle_action string|function Command to run
---@param label string The thing you're toggling
---@param invert_notify boolean? If true, reverses logic for on/off messages
local function toggle_notify(global_flag, toggle_action, label, invert_notify)
  local flag_name = "_" .. global_flag
  _G[flag_name] = not _G[flag_name]

  if type(toggle_action) == "string" then
    vim.cmd(toggle_action)
  elseif type(toggle_action) == "function" then
    toggle_action()
  end

  local state = _G[flag_name] and "enabled" or "disabled"
  if invert_notify then
    state = _G[flag_name] and "disabled" or "enabled"
  end

  vim.notify(label .. " " .. state)
end

return {
  { "<leader>t", group = "Toggle" },
  {
    "<leader>ta",
    function()
      vim.g.autosave_enabled = not vim.g.autosave_enabled
      vim.notify("AutoSave " .. (vim.g.autosave_enabled and "enabled" or "disabled"))
    end,
    desc = "AutoSave",
  },
  {
    "<leader>tc",
    function()
      toggle_notify("colorizer_enabled", "ColorizerToggle", "Colorizer", true)
    end,
    desc = "Toggle colorizer",
  },
  {
    "<leader>td",
    function()
      toggle_notify("diagnostics_virtual_text_enabled", function()
        vim.diagnostic.config {
          virtual_text = _G._diagnostics_virtual_text_enabled and {
            spacing = 2,
            prefix = "●",
            source = "if_many",
          } or false,
        }
      end, "LSP Virtual Text")
    end,
    desc = "Diagnostics Virtual Text",
  },
  {
    "<leader>tf",
    "<cmd>FormatToggle<cr>",
    desc = "Format on save",
  },
  {
    "<leader>th",
    function()
      toggle_notify("inlay_hints_enabled", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local enabled = _G._inlay_hints_enabled
        vim.lsp.inlay_hint.enable(enabled, { bufnr = bufnr })
      end, "Inlay Hints")
    end,
    desc = "LSP Inlay Hints",
  },
  {
    "<leader>ti",
    function()
      -- Initialize from Snacks state if not set
      if vim.g.indent_enabled == nil then
        vim.g.indent_enabled = Snacks.indent.enabled
      end

      vim.g.indent_enabled = not vim.g.indent_enabled

      if vim.g.indent_enabled then
        Snacks.indent.enable()
        vim.notify "Indent enabled"
      else
        Snacks.indent.disable()
        vim.notify "Indent disabled"
      end
    end,
    desc = "Indent line",
  },
  {
    "<leader>to",
    function()
      toggle_notify("tscontext_enabled", "TSContext toggle", "Treesitter context")
    end,
    desc = "Treesitter context",
  },
  {
    "<leader>tm",
    function()
      toggle_notify("flash_search_enabled", require("flash").toggle, "Flash search", true)
    end,
    desc = "Flash search",
  },
  {
    "<leader>ts",
    function()
      toggle_notify("scrolloff_max", function()
        -- Toggle scrolloff between 0 and 999
        vim.wo.scrolloff = vim.wo.scrolloff == 999 and 8 or 999
      end, "Scroll Off")
    end,
    desc = "Scrolloff values",
  },
  {
    "<leader>tt",
    function()
      -- Initialize from Snacks state if not set
      if vim.g.twilight_enabled == nil then
        vim.g.twilight_enabled = Snacks.dim.enabled
      end

      vim.g.twilight_enabled = not vim.g.twilight_enabled

      if vim.g.twilight_enabled then
        Snacks.dim.enable()
        vim.notify "Twilight enabled"
      else
        Snacks.dim.disable()
        vim.notify "Twilight disabled"
      end
    end,
    desc = "Twilight",
  },
  {
    "<leader>tv",
    function()
      Snacks.image.hover()
    end,
    desc = "Preview image",
  },
  {
    "<leader>tz",
    function()
      toggle_notify("zen_mode_enabled", function()
        Snacks.zen()
      end, "Zen")
    end,
    desc = "Zen",
  },
}
