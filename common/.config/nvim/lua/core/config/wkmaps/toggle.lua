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
      toggle_notify("autosave_enabled", "ASToggle", "AutoSave", true)
    end,
    desc = "AutoSave",
  },
  {
    "<leader>tb",
    function()
      toggle_notify("barbecue_enabled", require("barbecue.ui").toggle, "Barbecue")
    end,
    desc = "Barbecue",
  },

  {
    "<leader>tc",
    function()
      toggle_notify("colorizer_enabled", "ColorizerToggle", "Colorizer", true)
    end,
    desc = "Toggle colorizer",
  },
  {
    "<leader>ti",
    function()
      toggle_notify("ibl_enabled", "IBLToggle", "Indent blank line")
    end,
    desc = "Indent line",
  },
  {
    "<leader>tl",
    function()
      toggle_notify("cokeline_enabled", function()
        ---@diagnostic disable-next-line: undefined-field
        vim.o.showtabline = _G._cokeline_enabled and 2 or 0
      end, "Cokeline Tabline")
    end,
    desc = "Cokeline Tabline",
  },
  {
    "<leader>to",
    function()
      toggle_notify("tscontext_enabled", "TSContextToggle", "Treesitter context")
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
    "<leader>tp",
    function()
      toggle_notify("precognition_enabled", require("precognition").toggle, "Precognition", true)
    end,
    desc = "Precognition",
  },
  {
    "<leader>tt",
    function()
      toggle_notify("twilight_enabled", "Twilight", "Twilight")
    end,
    desc = "Twilight",
  },
}
