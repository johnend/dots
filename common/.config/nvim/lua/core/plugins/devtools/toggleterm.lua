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
      open_mapping = [[<c-/>]], -- Default key to open main terminal
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

    -- Helper to get the current window's buffer size
    local function get_buf_size()
      local bufinfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
      if not bufinfo then
        return { width = -1, height = -1 }
      end
      return { width = bufinfo.width, height = bufinfo.height }
    end

    -- Calculate terminal size dynamically based on window dimensions
    local function get_dynamic_size(direction, size)
      if direction ~= "float" and type(size) == "number" and size <= 1.0 then
        local buf = get_buf_size()
        local dim = direction == "horizontal" and buf.height or buf.width
        return math.floor(dim * size)
      end
      return size
    end

    -- Create and toggle a terminal instance
    local function exec_toggle(opts)
      local Terminal = require("toggleterm.terminal").Terminal
      local term = Terminal:new {
        cmd = opts.cmd,
        count = opts.count,
        direction = opts.direction,
      }
      -- 💥 FIX: call opts.size() here so it's a number
      term:toggle(opts.size(), opts.direction)
    end

    -- Define different terminal types with their keybindings
    local terminals = {
      { nil, "<C-;>", "Horizontal Terminal", "horizontal", 0.3 }, -- Horizontal at 30% height
      { nil, "<C-.>", "Vertical Terminal", "vertical", 0.4 }, -- Vertical at 40% width
      { nil, "<C-/>", "Float Terminal", "float", nil }, -- Floating, default size
    }

    -- Create keybindings for each terminal type
    for i, term in ipairs(terminals) do
      local opts = {
        cmd = term[1] or vim.o.shell, -- Default to shell if no command
        keymap = term[2],
        label = term[3],
        direction = term[4],
        size = function()
          return get_dynamic_size(term[4], term[5])
        end,
        count = i + 100, -- Ensure unique counts
      }

      vim.keymap.set({ "n", "t" }, opts.keymap, function()
        exec_toggle(opts)
      end, { desc = opts.label, noremap = true, silent = true })
    end

    -- Set terminal keymaps automatically when a terminal opens
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function()
        vim.cmd "startinsert!"
      end,
    })
  end,

  -- 🔥 Expose LazyGit toggle properly via the module
  lazygit_toggle = M.lazygit_toggle,
  gh_dash_toggle = M.gh_dash_toggle,
}
