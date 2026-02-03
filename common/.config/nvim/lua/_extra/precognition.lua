return {
  "tris203/precognition.nvim",
  event = "BufRead",
  config = function()
    local status_ok, precognition = pcall(require, "precognition")
    if not status_ok then
      return
    end
    precognition.setup {
      highlightColor = {
        link = "Comment",
      },
    }
  end,
}
