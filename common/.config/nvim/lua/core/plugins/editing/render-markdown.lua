return {
  "MeanderingProgrammer/render-markdown.nvim",
  config = function()
    local status_ok, markdown = pcall(require, "render-markdown")
    if not status_ok then
      return
    end

    markdown.setup {
      latex = { enabled = false },
      file_types = { "markdown", "copilot-chat" },
      completions = { blink = { enabled = true } },
      callout = {
        copilot = {
          raw = "[!COPILOT]",
          rendered = icons.git.Octoface .. " CoPilot",
          highlight = "RenderMarkdownSuccess",
          category = "github",
        },
      },
    }
  end,
}
