local M = {
  enabled = true,
  sources = {
    explorer = {
      hidden = true,
      ignored = true,
    },
    -- Filter light colorscheme variants from picker
    -- (plugins stay installed, just hidden from selection)
    colorschemes = (function()
      local excluded = {
        -- Light theme variants
        "catppuccin%-frappe",
        "catppuccin%-latte",
        "catppuccin%-macchiato",
        "catppuccin%-mocha",
        "dawnfox",
        "dayfox",
        "kanagawa%-lotus",
        "kanagawa%-wave",
        "modus%_operandi",
        "modus%_vivendi",
        "neomodern%-day",
        "neomodern%-light",
        "nordfox",
        "rose%-pine",
        "rose%-pine%-dawn",
        "rose%-pine%-moon",
        "sequoia%-main",
        "tokyonight",
        "tokyonight%-day",
        "tokyonight%-moon",
        "tokyonight%-storm",
        -- GitHub
        "github%_dark",
        "github%_dark%_colorblind",
        "github%_dark%_dimmed",
        "github%_dark%_high%_contrast",
        "github%_dark%_tritanopia",
        "github%_light",
        "github%_light%_colorblind",
        "github%_light%_default",
        "github%_light%_high%_contrast",
        "github%_light%_tritanopia",
        -- Zenbones light variants
        "forestbones",
        "nordbones",
        "randombones",
        "randombones_dark",
        "randombones_light",
        "seoulbones",
        "vimbones",
        "zenbones",
        -- Built-in Neovim light themes
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
        -- Other light themes
        "lunaperche",
        "quiet",
      }

      return {
        transform = function(item, ctx)
          -- Filter out excluded colorschemes by name
          for _, pattern in ipairs(excluded) do
            -- Try exact match first (for simple names like "morning")
            if item.text == pattern then
              return false -- Exclude this colorscheme
            end
            -- Then try pattern match (for names with special chars)
            if item.text:match("^" .. pattern .. "$") then
              return false -- Exclude this colorscheme
            end
          end
          return item -- Keep this colorscheme
        end,
      }
    end)(),
  },
}

return M
