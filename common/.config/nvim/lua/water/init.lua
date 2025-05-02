-- lua/water/init.lua
---@class water

-- 1) Wire up all Water autocmds
require("water.autocmds").setup()

-- 2) Plugin modules
local config = require "water.config"
local ui = require "water.ui.water"
local highlights = require "water.highlights"
local help = require "water.ui.help"
local state = require "water.state"

local M = {}
---@type boolean
local has_setup_run = false

---Setup Water plugin: merge options, define highlights, commands, and keymaps.
---@param opts table? User-provided configuration options.
function M.setup(opts)
  if has_setup_run then
    return
  end
  has_setup_run = true

  -- Merge user opts with defaults and save to state
  M.options = config.merge(opts or {})
  state.options = M.options

  -- Define highlight groups and setup help docs
  highlights.define()
  help.setup(M.options)

  -- Create user commands for toggling and refreshing the UI
  vim.api.nvim_create_user_command("Water", function()
    ui.toggle(M.options)
  end, { desc = "Toggle Water UI" })

  vim.api.nvim_create_user_command("WaterRefresh", function()
    ui.refresh()
  end, { desc = "Refresh Water UI" })

  -- Define keymap for toggling UI
  vim.keymap.set("n", M.options.keymaps.toggle, function()
    ui.toggle(M.options)
  end, {
    desc = "Toggle Water UI",
    nowait = true,
    noremap = true,
    silent = true,
  })
end

-- 4) Run setup immediately with default options
M.setup {}

-- 5) Expose public API for programmatic use
return {
  open = ui.open,
  render = ui.render,
  refresh = ui.refresh,
  toggle = ui.toggle,
  setup = M.setup,
}
