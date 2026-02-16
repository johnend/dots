--- Custom Telescope colorscheme picker with configurable exclusion list.
---
--- Why this exists:
---   Telescope's builtin colorscheme picker has no way to exclude themes. This
---   module builds the same list (getcompletion + lazy unloaded plugins), filters
---   it by M.excluded, then runs a picker with that list. No global overrides;
---   both loaded and lazy-discovered colorschemes are filtered.
---
--- Usage:
---   Keymap: require("config.telescope-colorscheme").colorscheme()
---   With overrides: .colorscheme { enable_preview = false, preview_file = "/path" }
---
--- Configuration (edit this file):
---   • M.excluded   — list of colorscheme names to hide from the picker
---   • M.layout     — layout/size/sorting (matches your other Telescope pickers)
---   • M.defaults   — default opts (enable_preview, preview_file); keymap can override
---
--- @module config.telescope-colorscheme

local api = vim.api
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local conf = require("telescope.config").values
local utils = require "telescope.utils"

local M = {}

-- -----------------------------------------------------------------------------
-- Exclusion list
-- -----------------------------------------------------------------------------
-- Colorscheme names in this table are removed from the picker. Add variants you
-- don't want (e.g. light versions, duplicate pack names) or vim builtins you
-- never use. Names must match exactly as returned by getcompletion("", "color")
-- or by the lazy glob (e.g. "catppuccin-mocha", "tokyonight-storm").

M.excluded = {
  "catppuccin-frappe",
  "catppuccin-latte",
  "catppuccin-macchiato",
  "catppuccin-mocha",
  "crimson_moonlight",
  "cyberdream-light",
  "dawnfox",
  "dayfox",
  "nordfox",
  "kanagawa-lotus",
  "kanagawa-wave",
  "modus_operandi",
  "modus_vivendi",
  "neomodern-day",
  "neomodern-light",
  "rose-pine",
  "rose-pine-dawn",
  "rose-pine-moon",
  "sequoia",
  "tokyonight",
  "tokyonight-day",
  "tokyonight-moon",
  "tokyonight-storm",
  "github_dark",
  "github_dark_colorblind",
  "github_dark_dimmed",
  "github_dark_high_contrast",
  "github_dark_tritanopia",
  "github_light",
  "github_light_colorblind",
  "github_light_default",
  "github_light_high_contrast",
  "github_light_tritanopia",
  "forestbones",
  "nordbones",
  "randombones",
  "randombones_dark",
  "randombones_light",
  "seoulbones",
  "vimbones",
  "zenbones",
  "rosebones",
  "tokyobones",
  "neobones",
  "kanagawabones",
  "blue",
  "darkblue",
  "delek",
  "desert",
  "elflord",
  "evening",
  "habamax",
  "industry",
  "koehler",
  "morning",
  "pablo",
  "peachpuff",
  "ron",
  "shine",
  "slate",
  "sorbet",
  "torte",
  "unokai",
  "vim",
  "zaibatsu",
  "zellner",
  "zenburned",
  "retrobox",
  "murphy",
  "wildcharm",
  "lunaperche",
  "quiet",
}

-- -----------------------------------------------------------------------------
-- Layout and default options
-- -----------------------------------------------------------------------------
-- These are merged into every picker call. Keymap/caller opts override (tbl_deep_extend "keep").

-- Layout: matches telescope.setup pickers.colorscheme (center_config) in
-- lua/plugins/navigation/telescope.lua so this picker looks like your others.
M.layout = {
  layout_strategy = "horizontal",
  layout_config = {
    prompt_position = "top",
    height = 0.5,
    width = 0.6,
    preview_width = 0.5,
  },
  sorting_strategy = "ascending",
}

-- Default opts. Set here; keymap can pass overrides when invoking .colorscheme({ ... }).
-- preview_file: path to a file to show in the preview window (default: current buffer).
M.defaults = {
  enable_preview = true,
  -- preview_file = nil,  -- e.g. vim.fn.stdpath("config") .. "/lua/config/ui.lua"
}

-- -----------------------------------------------------------------------------
-- Building the filtered colors list
-- -----------------------------------------------------------------------------
-- Same logic as telescope.builtin.colorscheme (see telescope.nvim builtin/__internal.lua):
-- 1) Start from current colorscheme (and optional opts.colors)
-- 2) Extend with vim.fn.getcompletion("", "color") — loaded colorschemes
-- 3) Extend with lazy's unloaded rtp: glob "colors/*" for plugin colorschemes
-- 4) Optionally strip vim builtins if opts.ignore_builtins
-- 5) Strip M.excluded
-- We do this ourselves so we can filter both getcompletion and lazy sources.

---@param opts table options (colors, ignore_builtins)
---@return string[] list of colorscheme names to show
local function build_filtered_colors(opts)
  local before_color = api.nvim_exec2("colorscheme", { output = true }).output
  local colors = opts.colors or { before_color }
  if not vim.tbl_contains(colors, before_color) then
    table.insert(colors, 1, before_color)
  end

  -- Add all colorschemes known to vim (loaded)
  colors = vim.list_extend(
    colors,
    vim.tbl_filter(function(c)
      return not vim.tbl_contains(colors, c)
    end, vim.fn.getcompletion("", "color"))
  )

  -- Add colorschemes from lazy-loaded plugins (not yet loaded; from colors/*.lua)
  local lazy = package.loaded["lazy.core.util"]
  if lazy and lazy.get_unloaded_rtp then
    local paths = lazy.get_unloaded_rtp ""
    local all_files = vim.fn.globpath(table.concat(paths, ","), "colors/*", 1, 1)
    for _, f in ipairs(all_files) do
      local color = vim.fn.fnamemodify(f, ":t:r")
      if not vim.tbl_contains(colors, color) then
        table.insert(colors, color)
      end
    end
  end

  -- Optional: remove vim's builtin themes (overlaps with M.excluded for some)
  if opts.ignore_builtins then
    local builtins = {
      "blue",
      "darkblue",
      "default",
      "delek",
      "desert",
      "elflord",
      "evening",
      "habamax",
      "industry",
      "koehler",
      "lunaperche",
      "morning",
      "murphy",
      "pablo",
      "peachpuff",
      "quiet",
      "retrobox",
      "ron",
      "shine",
      "slate",
      "sorbet",
      "torte",
      "unokai",
      "vim",
      "wildcharm",
      "zaibatsu",
      "zellner",
    }
    colors = vim.tbl_filter(function(c)
      return not vim.tbl_contains(builtins, c)
    end, colors)
  end

  -- Apply our exclusion list
  colors = vim.tbl_filter(function(c)
    return not vim.tbl_contains(M.excluded, c)
  end, colors)

  return colors
end

-- -----------------------------------------------------------------------------
-- Picker entry point
-- -----------------------------------------------------------------------------

--- Run the colorscheme picker with optional overrides.
--- Opts are merged: keymap/caller opts override M.defaults override M.layout.
---
--- @param opts table|nil optional overrides
--- @field enable_preview boolean show preview window and live colorscheme on move (default from M.defaults)
--- @field preview_file string path to file to show in preview (default: current buffer path)
--- @field preview_path string alias for preview_file
--- @field ignore_builtins boolean exclude vim builtin themes (default: false)
--- @field colors string[] extra colorscheme names to include (rare)
M.colorscheme = function(opts)
  opts = vim.tbl_deep_extend("keep", opts or {}, M.defaults, M.layout)

  local before_background = vim.o.background
  local before_color = api.nvim_exec2("colorscheme", { output = true }).output
  local need_restore = not not opts.enable_preview
  local colors = build_filtered_colors(opts)

  -- Preview window: shows a file or the current buffer; highlights update as you move.
  local previewer
  if opts.enable_preview then
    local preview_path = opts.preview_file or opts.preview_path or api.nvim_buf_get_name(api.nvim_get_current_buf())
    local bufnr = api.nvim_get_current_buf()
    previewer = previewers.new_buffer_previewer {
      get_buffer_by_name = function()
        return preview_path
      end,
      define_preview = function(self)
        if vim.uv.fs_stat(preview_path) then
          conf.buffer_previewer_maker(preview_path, self.state.bufnr, { bufname = self.state.bufname })
        else
          -- Unnamed buffer or preview_file path missing: use current buffer lines
          local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
          api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        end
      end,
    }
  end

  local picker = pickers.new(opts, {
    prompt_title = "Change Colorscheme",
    finder = finders.new_table { results = colors },
    sorter = conf.generic_sorter(opts),
    previewer = previewer,
    attach_mappings = function(prompt_bufnr)
      -- On <CR>: apply selected colorscheme and close (no restore)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.colorscheme"
          return
        end
        need_restore = false
        actions.close(prompt_bufnr)
        vim.cmd.colorscheme(selection.value)
      end)
      return true
    end,
    on_complete = {
      -- On every completion (e.g. after typing): if preview enabled, apply selection live
      function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          return
        end
        if opts.enable_preview then
          vim.cmd.colorscheme(selection.value)
        end
      end,
    },
  })

  -- When preview is enabled: restore previous colorscheme on close (unless they selected one)
  if opts.enable_preview then
    local close_windows = picker.close_windows
    picker.close_windows = function(status)
      close_windows(status)
      if need_restore then
        vim.o.background = before_background
        vim.cmd.colorscheme(before_color)
      end
    end

    -- When moving selection (C-n/C-p etc.): apply that colorscheme live
    local set_selection = picker.set_selection
    picker.set_selection = function(self, row)
      set_selection(self, row)
      local selection = action_state.get_selected_entry()
      if selection == nil then
        return
      end
      if opts.enable_preview then
        vim.cmd.colorscheme(selection.value)
      end
    end
  end

  picker:find()
end

return M
