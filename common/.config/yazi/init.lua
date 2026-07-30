-- Git status markers in the file list (added/modified/untracked/deleted).
require("git"):setup({ order = 1500 })

-- Rounded full-width border around the panes.
require("full-border"):setup({ type = ui.Border.ROUNDED })
