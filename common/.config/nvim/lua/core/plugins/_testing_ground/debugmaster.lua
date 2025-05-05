return {
  "miroshQa/debugmaster.nvim",
  config = function()
    local status_ok, dm = pcall(require, "debugmaster")

    vim.keymap.set({ "n", "v" }, "<leader>i", dm.mode.toggle, { nowait = true })
  end,
}
