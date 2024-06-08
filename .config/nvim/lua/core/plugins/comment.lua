return {
  "numToStr/Comment.nvim",
  event = {"BufRead", "BufNewFile"},
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
  config = function()
    local status_ok, Comment = pcall(require, "Comment")
    if not status_ok then
      return
    end
    Comment.setup {
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    }
  end,
}
