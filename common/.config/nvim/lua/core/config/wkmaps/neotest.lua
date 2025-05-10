return {

  { "<leader>T", "", desc = "+Test", icon = icons.misc.Testtube },
  {
    "<leader>Ta",
    function()
      require("neotest").run.run(vim.uv.cwd())
    end,
    desc = "Run All Test Files",
  },
  {
    "<leader>Tf",
    function()
      require("neotest").run.run(vim.fn.expand "%")
    end,
    desc = "Run File",
  },
  {
    "<leader>Tk",
    function()
      require("neotest").run.stop()
    end,
    desc = "Kill",
  },
  {
    "<leader>Tl",
    function()
      require("neotest").run.run_last()
    end,
    desc = "Run Last",
  },
  {
    "<leader>Tn",
    function()
      require("neotest").run.run()
    end,
    desc = "Run Nearest",
  },
  {
    "<leader>To",
    function()
      require("neotest").output.open { enter = true, auto_close = true }
    end,
    desc = "Show Output",
  },
  {
    "<leader>Tp",
    function()
      require("neotest").output_panel.toggle()
    end,
    desc = "Toggle Output Panel",
  },
  {
    "<leader>Ts",
    function()
      require("neotest").summary.toggle()
    end,
    desc = "Toggle Summary",
  },
  {
    "<leader>Tw",
    function()
      require("neotest").watch.toggle(vim.fn.expand "%")
    end,
    desc = "Toggle Watch",
  },
}
