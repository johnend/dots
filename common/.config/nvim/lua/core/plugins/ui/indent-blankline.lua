return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufRead",
  config = function()
    local status_ok, ibl = pcall(require, "ibl")
    if not status_ok then
      return
    end

    local highlight = {
      "RainbowCyan",
      "RainbowViolet",
      "RainbowGreen",
      "RainbowBlue",
      "RainbowRed",
      "RainbowYellow",
      "RainbowOrange",
    }

    ibl.setup {
      enabled = false,
      indent = { highlight = highlight, char = "" },
      whitespace = { highlight = highlight, remove_blankline_trail = false },
      scope = { enabled = false },
    }

    vim.keymap.set("n", "<leader>ti", ":IBLToggle<CR>", { desc = "Indent line" })
  end,
}
