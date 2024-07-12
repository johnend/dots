return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
  cmd = { "Neotree show", "Neotree close", "Neotree toggle", "Neotree focus" },
  config = function()
    local status_ok, neotree = pcall(require, "neo-tree")
    if not status_ok then
      return
    end

    neotree.setup {
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git/",
            ".DS_Store",
            "thumbs.db",
            "node_modules/",
          },
          never_show = {},
        },
      },
      popup_border_style = "single",
      sources = {
        "filesystem",
        "git_status",
        -- "document_symbols", -- maybe add this back in at some point?
      },
      source_selector = {
        winbar = true,
      },
      default_component_configs = {
        icon = {
          folder_closed = icons.ui.Folder,
          folder_open = icons.ui.FolderOpen,
          folder_empty = icons.ui.EmptyFolder,
          folder_empty_open = icons.ui.EmptyFolderOpen,
        },
        modified = {
          symbol = "",
        },
        name = {
          use_git_status_colors = false,
        },
        git_status = {
          symbols = {
            -- Change type
            added = icons.git.LineAdded, -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = icons.git.LineModified, -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = icons.git.FileRemoved, -- this can only be used in the git_status source
            renamed = icons.git.FileRenamed, -- this can only be used in the git_status source
            -- Status type
            untracked = icons.git.FileUntracked,
            ignored = icons.git.FileIgnored,
            unstaged = icons.git.FileUnstaged,
            staged = icons.git.FileStaged,
            conflict = "",
          },
        },
      },
    }
  end,
}
