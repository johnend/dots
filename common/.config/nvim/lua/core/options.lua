--[[
--
--  ██╗   ██╗██╗███╗   ███╗     ██████╗ ██████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
--  ██║   ██║██║████╗ ████║    ██╔═══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
--  ██║   ██║██║██╔████╔██║    ██║   ██║██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║███████╗
--  ╚██╗ ██╔╝██║██║╚██╔╝██║    ██║   ██║██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║╚════██║
--   ╚████╔╝ ██║██║ ╚═╝ ██║    ╚██████╔╝██║        ██║   ██║╚██████╔╝██║ ╚████║███████║
--    ╚═══╝  ╚═╝╚═╝     ╚═╝     ╚═════╝ ╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
--
--]]

-- sets nice looking fold text when lines are folded e.g. this function folded looks like:
-- ─┤ 󰆧 Fold_text = function () ├─────┤ 19 lines ├───────────────────────────────────────────────────────────────────
Fold_Text = function()
  local fold_start = table.concat(vim.fn.getbufline(vim.api.nvim_get_current_buf(), vim.v.foldstart))
  local icon = fold_start:match 'Icon:%s*"([^"]+)"' or " 󰆧 "
  local line_text = vim.fn.substitute(fold_start, '^"{+', "", "g")
  local pre = "─┤"
  local post = "├─"
  local folded_line_num = vim.v.foldend - vim.v.foldstart
  return "󰐕 "
    .. pre
    .. icon
    .. line_text
    .. " "
    .. post
    .. "───"
    .. pre
    .. " "
    .. folded_line_num
    .. " lines "
    .. post
end

-- fills the rest of the folded text line with a character
vim.opt.fillchars:append { fold = "─" }

local options = {
  -- :help options
  background = "dark",

  -- creates a backup file
  backup = false,

  -- enable break indent (wrapped lines continue visually indented)
  breakindent = true,

  -- allows neovim to access the system clipboard
  clipboard = "unnamedplus",

  -- more space in the neovim command line for displaying message
  cmdheight = 2,

  -- mostly just for cmp
  completeopt = { "menuone", "noselect" },

  -- so that `` is visible in markdown files
  conceallevel = 0,

  colorcolumn = "120",
  -- highlight the current line
  cursorline = true,

  -- convert tabs to spaces
  expandtab = true,

  -- fold settings
  foldmethod = "expr",
  foldexpr = "v:lua.vim.treesitter.foldexpr()",
  foldtext = "v:lua.Fold_Text()",
  foldlevel = 99,
  foldnestmax = 4,
  foldcolumn = "1",
  -- sets cursor display to be different for visual (horizontal line) and insert (vertical line) modes
  guicursor = "v:hor20,i:ver30,n-v-c-i:blinkon500-blinkoff500",
  -- the font used in NON-TERMINAL neovim applications
  guifont = "monospace:h17",

  -- highlight all matches on previous search pattern
  hlsearch = true,
  incsearch = true,

  -- ignore case in search patterns
  ignorecase = true,
  -- smart case
  smartcase = true,

  -- preview substitutions live
  inccommand = "split",

  laststatus = 3,

  -- sets how neovim will display certain whitespace characters
  list = true,
  listchars = { tab = "» ", trail = "·", nbsp = "␣" },

  -- allow the mouse to be used in neovim
  mouse = "a",

  -- set numbered lines
  nu = true,

  -- set number column width to 2 {default 4}
  numberwidth = 4,

  -- pop up menu height
  pumheight = 10,

  -- set relative numbered lines
  relativenumber = true,

  -- scrolling space
  scrolloff = 8,

  -- the number of spaces inserted for each indentation
  shiftwidth = 2,

  -- we don't need to see things like -- INSERT -- anymore
  showmode = false,

  -- never show tabs
  showtabline = 0,

  -- always show the sign column, otherwise it would shift the text each time
  signcolumn = "yes",

  -- make indenting smarter again
  smartindent = true,

  -- determines how new splits should be opened
  splitbelow = true,
  splitright = true,

  -- creates a swapfile
  swapfile = false,

  -- insert 2 spaces for a tab
  tabstop = 2,
  softtabstop = 2,

  -- set term gui colors (most terminals support this)
  termguicolors = true,

  -- time to wait for a mapped sequence to complete (in milliseconds)
  timeoutlen = 210,

  -- enable persistent undo
  undodir = os.getenv "HOME" .. "/vim/undodir",
  undofile = true,

  -- faster completion (4000ms default)
  updatetime = 250,

  -- display lines as one long line
  wrap = true,
  linebreak = true,

  -- if a file is being edited by another program (or was written to file while editing with another program),
  -- it is not allowed to be edited
  writebackup = false,
}

vim.opt.shortmess:append "c"

for k, v in pairs(options) do
  vim.opt[k] = v
end
