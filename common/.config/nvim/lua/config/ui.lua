local M = {
  -- ============================================================================
  -- BORDER STYLES
  -- ============================================================================
  -- Available border options: "none", "single", "double", "rounded", "solid", "shadow"
  -- or an array like { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }
  
  borders = {
    -- Default border for most UI elements
    default = "rounded",
    
    -- Specific overrides for different contexts
    float = "rounded",           -- Floating windows (LSP hover, diagnostics, etc.)
    window = "rounded",          -- Regular windows
    popup = "rounded",           -- Popup windows
    
    -- Plugin-specific borders (for granular control)
    completion = "rounded",      -- Blink.cmp completion menu
    documentation = "rounded",   -- Blink.cmp documentation window
    signature = "rounded",       -- LSP signature help
    hover = "rounded",           -- LSP hover docs
    diagnostic = "rounded",      -- Diagnostic float windows
    
    -- Special cases
    terminal = "rounded",        -- Toggleterm, Snacks terminal
    trouble_main = "single",     -- Trouble main window (currently differs)
    trouble_preview = "rounded", -- Trouble preview window
    neo_tree = "single",         -- Neo-tree popup borders
    which_key = "rounded",       -- Which-key popup
    lazy = "rounded",            -- Lazy.nvim UI
    mason = "rounded",           -- Mason UI
    noice_cmdline = "rounded",   -- Noice command palette
    gitsigns_preview = "rounded", -- Git signs preview window
  },
  
  -- Backward compatibility alias (for current usage: UI.border)
  border = "rounded",
  
  -- ============================================================================
  -- WINDOW TRANSPARENCY
  -- ============================================================================
  transparency = {
    float = 0,      -- Floating windows (0 = opaque, 100 = fully transparent)
    popup = 0,      -- Popup windows
    sidebar = 0,    -- Sidebar windows (Neo-tree, etc.)
    cmdline = 0,    -- Command line (Noice)
  },
  
  -- ============================================================================
  -- TELESCOPE CONFIGURATION
  -- ============================================================================
  telescope = {
    -- Theme options: "cursor", "dropdown", "ivy", "center"
    default_theme = "dropdown",
    
    -- Layout configurations for different picker types
    layouts = {
      dropdown = {
        theme = "dropdown",
        layout_config = {
          width = 0.8,
          height = 0.3,
        },
      },
      
      -- You could add more preset layouts here
      wide_preview = {
        theme = "center",
        layout_config = {
          width = 0.9,
          height = 0.8,
          preview_width = 0.6,
        },
      },
      
      compact = {
        theme = "dropdown",
        layout_config = {
          width = 0.5,
          height = 0.4,
        },
      },
      
      -- Project picker layout
      project = {
        theme = "dropdown",
        layout_config = {
          width = 0.5,
          height = 0.4,
        },
      },
      
      -- Todo comments layout
      todo = {
        theme = "dropdown",
        previewer = false,
        layout_config = {
          width = 0.5,
          height = 0.3,
        },
      },
    },
    
    -- Telescope UI elements
    prompt_prefix = " 󰭎  ",  -- Using your Icons.ui.Telescope
    selection_caret = "  ",   -- Using your Icons.ui.Forward
  },
  
  -- ============================================================================
  -- COMPLETION (Blink.cmp)
  -- ============================================================================
  completion = {
    border = "rounded",
    
    menu = {
      border = "rounded",
      -- Controls how items are rendered
      draw = {
        align_to = "label",
        padding = 1,
        gap = 1,
        treesitter = { "lsp", "buffers" },
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "source_name" },
        },
      },
    },
    
    documentation = {
      border = "rounded",
      auto_show = false,
    },
    
    signature = {
      border = "rounded",
    },
  },
  
  -- ============================================================================
  -- TROUBLE WINDOW CONFIGURATION
  -- ============================================================================
  trouble = {
    main_window = {
      border = "single",
    },
    preview_window = {
      border = "rounded",
      type = "float",
      size = { width = 0.5, height = 0.5 },
      position = { 0.3, 0.5 },
    },
    symbols_window = {
      position = "right",
      size = 40,
    },
  },
  
  -- ============================================================================
  -- TERMINAL CONFIGURATION
  -- ============================================================================
  terminal = {
    border = "rounded",
    
    -- Toggleterm specific
    toggleterm = {
      direction = "float",
      float_opts = {
        border = "rounded",
      },
    },
    
    -- Snacks terminal
    snacks = {
      position = "float",
      border = "rounded",
    },
  },
  
  -- ============================================================================
  -- TREE/EXPLORER WINDOWS
  -- ============================================================================
  tree = {
    neo_tree = {
      popup_border_style = "single",
    },
  },
  
  -- ============================================================================
  -- NOTIFICATION STYLES
  -- ============================================================================
  notifications = {
    -- Snacks notifier
    snacks = {
      timeout = 2000,
      style = "minimal",
      top_down = false,
    },
  },
  
  -- ============================================================================
  -- NOICE UI CONFIGURATION
  -- ============================================================================
  noice = {
    cmdline = {
      border = "rounded",
      position = {
        row = 10,
        col = "50%",
      },
      size = {
        min_width = 75,
        width = "auto",
        height = "auto",
      },
    },
    
    popupmenu = {
      border = "rounded",
      position = {
        row = 13,
        col = "50%",
      },
      size = {
        width = 75,
        height = "auto",
        max_height = 16,
      },
    },
    
    hover = {
      border = "rounded",
      max_width_ratio = 0.5, -- 50% of screen width
    },
    
    mini = {
      winblend = 0,
    },
  },
  
  -- ============================================================================
  -- WHICH-KEY CONFIGURATION
  -- ============================================================================
  which_key = {
    border = "rounded",
    padding = { 1, 1 },
    winblend = 0,
  },
  
  -- ============================================================================
  -- GIT SIGNS PREVIEW
  -- ============================================================================
  gitsigns = {
    preview = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  },
  
  -- ============================================================================
  -- ACTIONS PREVIEW
  -- ============================================================================
  actions_preview = {
    telescope = {
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
      layout_config = {
        width = 0.8,
        height = 0.7,
        preview_cutoff = 20,
      },
    },
  },
  
  -- ============================================================================
  -- INDENT GUIDES
  -- ============================================================================
  indent = {
    enabled = false, -- Currently using Snacks.indent
    only_scope = true,
    only_current = true,
  },
  
  -- ============================================================================
  -- ZEN MODE / DIM
  -- ============================================================================
  zen = {
    backdrop = {
      transparent = true,
      blend = 21,
    },
  },
  
  dim = {
    animate = {
      duration = {
        step = 7,
        total = 210,
      },
    },
  },
  
  -- ============================================================================
  -- ANIMATION SETTINGS
  -- ============================================================================
  animation = {
    enabled = true,
    duration = 7,
    easing = "inOutQuad",
    fps = 120,
  },
  
  -- ============================================================================
  -- PADDING & SPACING
  -- ============================================================================
  padding = {
    float = { 1, 1 },       -- { vertical, horizontal }
    popup = { 1, 1 },
    cmdline = { 0, 1 },
  },
  
  spacing = {
    which_key_layout = 2,
  },
  
  -- ============================================================================
  -- SIZE PRESETS (for consistent window sizing)
  -- ============================================================================
  sizes = {
    small = { width = 0.3, height = 0.3 },
    medium = { width = 0.5, height = 0.5 },
    large = { width = 0.8, height = 0.8 },
    wide = { width = 0.9, height = 0.6 },
    tall = { width = 0.6, height = 0.9 },
  },
}

return M
