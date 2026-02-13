-- Custom colorscheme picker with filtering
-- Based on telescope.builtin.colorscheme but with exclusion list from qvim config

local M = {}

-- Exclusion list matching ~/.config/qvim/lua/config/snacks/picker.lua
M.excluded = {
  "blue",
  "catppuccin-frappe",
  "catppuccin-latte",
  "catppuccin-macchiato",
  "catppuccin-mocha",
  "crimson_moonlight",
  "darkblue",
  "dawnfox",
  "dayfox",
  "delek",
  "desert",
  "elflord",
  "evening",
  "forestbones",
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
  "habamax",
  "industry",
  "kanagawa-lotus",
  "kanagawa-wave",
  "kanagawabones",
  "koehler",
  "lunaperche",
  "modus_operandi",
  "modus_vivendi",
  "morning",
  "murphy",
  "neobones",
  "neomodern-day",
  "neomodern-light",
  "nordbones",
  "nordfox",
  "pablo",
  "peachpuff",
  "quiet",
  "randombones",
  "randombones_dark",
  "randombones_light",
  "retrobox",
  "ron",
  "rose-pine",
  "rose-pine-dawn",
  "rose-pine-moon",
  "rosebones",
  "seoulbones",
  "sequoia-main",
  "shine",
  "slate",
  "sorbet",
  "tokyobones",
  "tokyonight",
  "tokyonight-day",
  "tokyonight-moon",
  "tokyonight-storm",
  "torte",
  "unokai",
  "vim",
  "vimbones",
  "wildcharm",
  "zaibatsu",
  "zellner",
  "zenbones",
  "zenburned",
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
