return {
  "folke/flash.nvim",
  event = "VeryLazy",

  config = function()
    local status_ok, flash = pcall(require, "flash")
    if not status_ok then
      return
    end

    flash.setup {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = {
        multi_window = true,
        forward = true,
        wrap = true,
        ---@type Flash.Pattern.Mode
        mode = "exact",
        incremental = false,
        ---@type (string|fun(win:window))[]
        exclude = {
          "notify",
          "cmp_menu",
          "noice",
          "flash_prompt",
          function(win)
            return not vim.api.nvim_win_get_config(win).focusable
          end,
        },
        trigger = ".",
        max_length = false, ---@type number|false
      },
      jump = {
        jumplist = true,
        pos = "start", ---@type "start" | "end" | "range"
        history = false,
        register = false,
        nohlsearch = false,
        autojump = false,
        inclusive = nil, ---@type boolean?
        offset = nil, ---@type number
      },
      label = {
        uppercase = true,
        exclude = "",
        current = true,
        after = true, ---@type boolean|number[]
        before = false, ---@type boolean|number[]
        style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
        reuse = "lowercase", ---@type "lowercase" | "all" | "none"
        distance = true,
        min_pattern_length = 0,
        -- Enable this to use rainbow colors to highlight labels
        -- Can be useful for visualizing Treesitter ranges.
        rainbow = {
          enabled = false,
          -- number between 1 and 9
          shade = 5,
        },
        ---@type fun(opts:Flash.Format): string[][]
        format = function(opts)
          return { { opts.match.label, opts.hl_group } }
        end,
      },
      highlight = {
        backdrop = true,
        matches = true,
        priority = 5000,
        groups = {
          match = "FlashMatch",
          current = "FlashCurrent",
          backdrop = "FlashBackdrop",
          label = "FlashLabel",
        },
      },
      ---@type fun(match:Flash.Match, state:Flash.State)|nil
      action = nil,
      pattern = "",
      continue = false,
      config = nil, ---@type fun(opts:Flash.Config)|nil
      ---@type table<string, Flash.Config>
      modes = {
        search = {
          enabled = true,
          highlight = { backdrop = true },
          jump = { history = true, register = true, nohlsearch = true },
          search = {
            -- `forward` will be automatically set to the search direction
            -- `mode` is always set to `search`
            -- `incremental` is set to `true` when `incsearch` is enabled
          },
        },
        char = {
          enabled = true,
          autohide = false,
          jump_labels = false,
          multi_line = true,
          label = { exclude = "hjkliardc" },
          keys = { "f", "F", "t", "T", ";", "," },
          ---@alias Flash.CharActions table<string, "next" | "prev" | "right" | "left">
          char_actions = function(motion)
            return {
              [";"] = "next", -- set to `right` to always go right
              [","] = "prev", -- set to `left` to always go left
              -- clever-f style
              [motion:lower()] = "next",
              [motion:upper()] = "prev",
            }
          end,
          search = { wrap = false },
          highlight = { backdrop = true },
          jump = {
            register = false,
            autojump = false,
          },
        },
      },
    }
  end,
}
