return {
  "Bekaboo/dropbar.nvim",
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  config = function()
    local status_ok, dropbar = pcall(require, "dropbar")
    if not status_ok then
      return
    end

    dropbar.setup {
      bar = {
        enable = function(buf, win, _)
          if not vim.g.dropbar_enabled then
            return false
          end

          if
            not vim.api.nvim_buf_is_valid(buf)
            or not vim.api.nvim_win_is_valid(win)
            or vim.fn.win_gettype(win) ~= ""
            or vim.wo[win].winbar ~= ""
            or vim.bo[buf].ft == "help"
          then
            return false
          end

          local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
          if stat and stat.size > 1024 * 1024 then
            return false
          end

          return vim.bo[buf].ft == "markdown"
            or pcall(vim.treesitter.get_parser, buf)
            or not vim.tbl_isempty(vim.lsp.get_clients {
              bufnr = buf,
              method = "textDocument/documentSymbol",
            })
        end,
      },
    }
    vim.g.dropbar_enabled = false
  end,
}
