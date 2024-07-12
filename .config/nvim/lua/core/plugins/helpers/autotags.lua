return {
  "windwp/nvim-ts-autotag",
  event = "InsertEnter",
  module = "nvim-ts-autotag",
  config = function()
    local status_ok, ts_autotag = pcall(require, "nvim-ts-autotag")
    if not status_ok then
      return
    end
    ts_autotag.setup {
      filetypes = { "html", "xml", "javascriptreact", "typescriptreact", },
    }
  end,
}
