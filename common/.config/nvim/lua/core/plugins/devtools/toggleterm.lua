local M = {}

function M.lazygit_toggle()
  local Terminal = require("toggleterm.terminal").Terminal
  if not M._lazygit then
    M._lazygit = Terminal:new {
      cmd = "lazygit",
      hidden = true,
      direction = "float",
      on_open = function()
        vim.cmd "startinsert"
      end,
      on_close = function()
        vim.cmd "stopinsert"
      end,
      count = 99,
      float_opts = {
        border = "rounded",
      },
    }
  end
  M._lazygit:toggle()
end

function M.gh_dash_toggle()
  local Terminal = require("toggleterm.terminal").Terminal
  if not M._gh_dash then
    M._gh_dash = Terminal:new {
      cmd = "gh dash",
      hidden = true,
      direction = "float",
      on_open = function()
        vim.cmd "startinsert"
      end,
      on_close = function()
        vim.cmd "stopinsert"
      end,
      count = 100,
      float_opts = {
        border = "rounded",
      },
    }
  end
  M._gh_dash:toggle()
end

local uname = vim.loop.os_uname().sysname
local open_mapping

if uname == "Darwin" then
  open_mapping = [[<c-_>]]
else
  open_mapping = [[<c-/>]]
end

return {
  "akinsho/toggleterm.nvim",
  version = "*", -- Always grab the latest stable version
  event = "VeryLazy", -- Load lazily after startup
  cmd = {
    "ToggleTerm",
    "TermExec",
    "ToggleTermToggleAll",
    "ToggleTermSendCurrentLine",
    "ToggleTermSendVisualLines",
    "ToggleTermSendVisualSelection",
  },
  config = function()
    local ok, toggleterm = pcall(require, "toggleterm")
    if not ok then
      vim.notify("[toggleterm] failed to load", vim.log.levels.ERROR)
      return
    end

    toggleterm.setup {
      size = 20, -- Default size for terminals
      open_mapping = open_mapping, -- Default key to open main terminal
      hide_numbers = true, -- Hide number column in terminals
      shade_filetypes = {}, -- No extra shading for specific filetypes
      shade_terminals = true,
      shading_factor = 2, -- How dark terminals appear
      start_in_insert = true, -- Start terminals in insert mode
      insert_mappings = true, -- Allow open mapping during insert mode
      persist_size = false, -- Don't save terminal sizes across sessions
      direction = "float", -- Default terminal type
      close_on_exit = true, -- Close terminal when process exits
      shell = vim.o.shell, -- Use user's shell
      float_opts = {
        border = "rounded", -- Rounded border for floating terminals
      },
      winbar = {
        enabled = true,
        name_formatter = function(term)
          return tostring(term.count)
        end,
      },
    }
  end,

  lazygit_toggle = M.lazygit_toggle,
  gh_dash_toggle = M.gh_dash_toggle,
}
