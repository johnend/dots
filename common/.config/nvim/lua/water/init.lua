-- lua/water/init.lua

-- 1) Wire up all Water autocmds
require("water.autocmds").setup()

-- 2) Plugin modules
local config = require "water.config"
local ui = require "water.ui.water"
local highlights = require "water.highlights"
local help = require "water.ui.help"
local state = require "water.state"

local M = {}
local has_setup_run = false

-- 3) Setup function: define commands, keymaps, and initialize state
function M.setup(opts)
  if has_setup_run then
    return
  end
  has_setup_run = true

  -- Merge user opts with defaults
  M.options = config.merge(opts or {})

  -- Define highlights and help
  highlights.define()
  help.setup(M.options)

  -- User commands
  vim.api.nvim_create_user_command("Water", function()
    ui.toggle(M.options)
  end, { desc = "Toggle Water UI" })

  vim.api.nvim_create_user_command("WaterRefresh", function()
    ui.refresh()
  end, { desc = "Refresh Water UI" })

  -- Keymaps
  vim.keymap.set("n", M.options.keymaps.toggle, function()
    ui.toggle(M.options)
  end, {
    desc = "Toggle Water UI",
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
