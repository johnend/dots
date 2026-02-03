return {
  "saecki/crates.nvim",
  tag = "stable",
  event = { "BufRead Cargo.toml" },

  config = function()
    local status_ok, crates = pcall(require, "crates")
    if not status_ok then
      return
    end

    crates.setup {
      completion = {
        crates = { enabled = true, max_results = 8, min_chars = 3 },
        cmp = { enabled = true },
      },
      popup = {
        border = "rounded",
      },
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
    }
  end,
}
