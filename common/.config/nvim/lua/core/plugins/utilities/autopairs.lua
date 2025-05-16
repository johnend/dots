return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local status_ok, autopairs = pcall(require, "nvim-autopairs")
    if not status_ok then
      return
    end
    autopairs.setup {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      fast_wrap = {
        map = "<M-f>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopasdfghjklzxcvbnm",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    }
  end,
}
