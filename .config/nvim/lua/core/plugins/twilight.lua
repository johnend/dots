return {
  "folke/twilight.nvim",
  event = {"BufRead", "BufNewFile"},
  config = function()
    local status_ok, twilight = pcall(require, "twilight")
    if not status_ok then
      return
    end
    twilight.setup {}
    vim.keymap.set("n", "<leader>tt", ":Twilight<CR>", { desc = "Twilight" })
  end,
}
