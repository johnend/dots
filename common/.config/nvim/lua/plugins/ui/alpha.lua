return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local status_ok, alpha = pcall(require, "alpha")
    if not status_ok then
      return
    end

    local dashboard = require "alpha.themes.dashboard"

    local function button(sc, txt, keybind)
      local b = dashboard.button(sc, txt, keybind)
      b.opts.hl_shortcut = "Include"
      return b
    end

    local headers = require "config.dashboard.headers"

    dashboard.section.header.val = headers.king
    dashboard.section.buttons.val = {
      button("f", Icons.ui.Files .. "  Find file", ":Telescope find_files<cr>"),
      button("r", Icons.ui.History .. "  Recent files", ":Telescope oldfiles<cr>"),
      button("g", Icons.ui.Text .. "  Grep text", ":Telescope live_grep<cr>"),
      button("c", Icons.ui.Gear .. "  Config", ":cd ~/.config/nvim | e init.lua<cr>"),
      button("l", Icons.misc.Plug .. "  Plugins", ":Lazy<cr>"),
      button("m", Icons.misc.Mason .. "  Mason", ":Mason<cr>"),
      button("q", Icons.ui.SignOut .. "  Quit", ":qa<cr>"),
    }

    local function footer()
      return "johnenderby.com"
    end

    if vim.g.neovide then
      table.insert(
        dashboard.section.buttons.val,
        3,
        button("p", Icons.git.Repo .. "  Find Project", "<cmd>ProjectExplorer<cr>")
      )
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
