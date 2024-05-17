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

local options = {
  -- :help options

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

  -- highlight the current line
  cursorline = true,

  -- convert tabs to spaces
  expandtab = true,

  -- the default encoding written to a file
  fileencoding = "utf-8",

  -- fold settings
  foldmethod = "expr",
  foldexpr = "v:lua.vim.treesitter.foldexpr()",
  foldtext = "",
  foldlevel = 99,
  foldnestmax = 4,
  -- sets cursor display to be different for visual (horizontal line) and insert (vertical line) modes
  guicursor = "v:hor20,i:ver30",

  -- the font used in NON-TERMINAL neovim applications
  guifont = "monospace:h17",

  -- highlight all matches on previous search pattern
  hlsearch = true,
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
  number = true,

  -- set number column width to 2 {default 4}
  numberwidth = 4,

  -- pop up menu height
  pumheight = 10,

  -- set relative numbered lines
  relativenumber = false,

  -- scrolling space
  scrolloff = 32,

  -- the number of spaces inserted for each indentation
  shiftwidth = 2,

  -- we don't need to see things like -- INSERT -- anymore
  showmode = false,

  -- always show tabs
  showtabline = 2,

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

  -- set term gui colors (most terminals support this)
  termguicolors = true,

  -- time to wait for a mapped sequence to complete (in milliseconds)
  timeoutlen = 300,

  -- enable persistent undo
  undofile = true,

  -- faster completion (4000ms default)
  updatetime = 250,

  -- display lines as one long line
  wrap = true,

  -- if a file is being edited by another program (or was written to file while editing with another program),
  -- it is not allowed to be edited
  writebackup = false,
}

vim.opt.shortmess:append "c"

for k, v in pairs(options) do
  vim.opt[k] = v
end
