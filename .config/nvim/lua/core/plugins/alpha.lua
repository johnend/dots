return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local status_ok, alpha = pcall(require, "alpha")
    if not status_ok then
      return
    end

    local dashboard = require "alpha.themes.dashboard"
    local icons = require "core.ui.icons"

    local function button(sc, txt, keybind)
      local b = dashboard.button(sc, txt, keybind)
      b.opts.hl_shortcut = "Include"
      return b
    end

    local headers = require "core.ui.dashboard.headers"

    dashboard.section.header.val = headers.king
    dashboard.section.buttons.val = {
      button("f", icons.ui.Files .. "  Find file", ":Telescope find_files <CR>"),
      button("n", icons.ui.NewFile .. "  New file", ":ene <BAR> start insert <CR>"),
      button("p", icons.git.Repo .. "  Find project",
        ":Telescope project project theme=dropdown layout_config={width=0.3, height=0.4}<CR>"),
      button("r", icons.ui.History .. "  Recent files", ":Telescope oldfiles <CR>"),
      button("t", icons.ui.Text .. "  Find text", ":Telescope live_grep <CR>"),
      button("c", icons.ui.Gear .. "  Config", ":e ~/.config/nvim/init.lua <CR>"),
      button("q", icons.ui.SignOut .. "  Quit", ":qa<CR>"),
    }

    local function footer()
      return "johnenderby.com"
    end

    dashboard.section.footer.val = footer()

    dashboard.section.header.opts.hl = "Keyword"
    dashboard.section.buttons.opts.hl = "Include"
    dashboard.section.buttons.opts.hl = "Type"

    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "Loaded " .. stats.count .. " plugins in " .. ms .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = { "AlphaReady" },
      callback = function()
        vim.cmd [[
    set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]]
      end,
    })
  end,
}
