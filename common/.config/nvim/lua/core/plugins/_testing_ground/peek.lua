return {
  "toppair/peek.nvim",
  event = "VeryLazy",
  build = "deno task --quiet build:fast",
  config = function()
    local status_ok, peek = pcall(require, "peek")
    if not status_ok then
      return
    end

    vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
    vim.api.nvim_create_user_command("PeekClose", peek.close, {})

    peek.setup {
      app = "browser",
    }
  end,
}
