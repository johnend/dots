-- Custom colorscheme picker with filtering
-- Based on telescope.builtin.colorscheme but with exclusion list from qvim config

local M = {}

-- Exclusion list matching ~/.config/qvim/lua/config/snacks/picker.lua
M.excluded = {
  "catppuccin-frappe",
  "catppuccin-latte",
  "catppuccin-macchiato",
  "catppuccin-mocha",
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
  "sequoia-main",
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
  "duckbones",
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

M.colorscheme = function(opts)
  opts = opts or {}

  -- Use telescope's builtin but override getcompletion temporarily
  local original_getcompletion = vim.fn.getcompletion

  vim.fn.getcompletion = function(pat, type)
    local result = original_getcompletion(pat, type)
    if type == "color" then
      -- Filter excluded colorschemes
      return vim.tbl_filter(function(color)
        return not vim.tbl_contains(M.excluded, color)
      end, result)
    end
    return result
  end

  -- Call telescope builtin
  require("telescope.builtin").colorscheme(opts)

  -- Restore immediately (not waiting for picker to close)
  -- This is safe because telescope captures the list at picker creation time
  vim.fn.getcompletion = original_getcompletion
end

return M
