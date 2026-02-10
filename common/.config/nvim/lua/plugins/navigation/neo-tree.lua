---@diagnostic disable-next-line: undefined-field
local sysname = vim.uv.os_uname().sysname
local is_mac = sysname == "Darwin"
local is_linux = sysname == "Linux"

local function get_project_relative_path(absolute_path)
  -- Common root markers in order of preference
  local root_markers = {
    ".git",
    "stylua.toml",
    ".stylua.toml",
    "tsconfig.json",
    "package.json",
    "Cargo.toml",
    "pyproject.toml",
    "go.mod",
    ".root",
  }

  local current_dir = vim.fn.fnamemodify(absolute_path, ":h")
  
  -- Walk up the directory tree looking for root markers
  while current_dir ~= "/" and current_dir ~= "." do
    for _, marker in ipairs(root_markers) do
      if vim.fn.filereadable(current_dir .. "/" .. marker) == 1 or vim.fn.isdirectory(current_dir .. "/" .. marker) == 1 then
        -- Found root, return relative path
        local relative = vim.fn.fnamemodify(absolute_path, ":s?" .. current_dir .. "/??")
        return relative
      end
    end
    -- Move up one directory
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end
  
  -- No project root found, return absolute path
  return absolute_path
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  config = function()
    local status_ok, neotree = pcall(require, "neo-tree")
    if not status_ok then
      return
    end

    neotree.setup {
      close_if_last_window = true,
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf" },
      filesystem = {
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ["o"] = "system_open",
            ["Y"] = "copy_path_to_clipboard",
          },
        },
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
      commands = {
        system_open = function()
          local state = require("neo-tree.sources.manager").get_state "filesystem"
          local node = state.tree:get_node()
          local path = node:get_id()

          if is_mac then
            vim.fn.jobstart({ "open", path }, { detach = true })
          elseif is_linux == "Linux" then
            vim.fn.jobstart({ "xdg-open", path }, { detach = true })
          else
            local dir = vim.fn.fnamemodify(path, ":h")
            vim.fn.jobstart({ "explorer, dir" }, { detach = true })
          end
        end,
        copy_path_to_clipboard = function(state)
          local node = state.tree:get_node()
          local absolute_path = node:get_id()
          local path = get_project_relative_path(absolute_path)
          vim.fn.setreg("+", path)
          
          -- Show if it's relative or absolute in notification
          local path_type = path == absolute_path and "(absolute)" or "(relative)"
          vim.notify('Copied ' .. path_type .. ': ' .. path, vim.log.levels.INFO)
        end,
      },
      popup_border_style = "single",
      sources = {
        "filesystem",
        "git_status",
        -- "document_symbols", -- maybe add this back in at some point?
      },
      source_selector = {
        winbar = true,
        truncation_character = Icons.ui.Ellipsis,
      },
      default_component_configs = {
        icon = {
          default = Icons.ui.File,
          folder_closed = Icons.ui.Folder,
          folder_open = Icons.ui.FolderOpen,
          folder_empty = Icons.ui.EmptyFolder,
          folder_empty_open = Icons.ui.EmptyFolderOpen,
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
            added = Icons.git.LineAdded, -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = Icons.git.LineModified, -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = Icons.git.FileDeleted, -- this can only be used in the git_status source
            renamed = Icons.git.FileRenamed, -- this can only be used in the git_status source
            -- Status type
            untracked = Icons.git.FileUntracked,
            ignored = Icons.git.FileIgnored,
            unstaged = Icons.git.FileUnstaged,
            staged = Icons.git.FileStaged,
            conflict = "",
          },
        },
      },
    }
  end,
}
