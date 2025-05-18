![image](https://github.com/user-attachments/assets/6369533f-381e-4ab6-8f4c-cd4376d01a47)

<a href="https://dotfyle.com/johnend/dots-common-config-nvim"><img src="https://dotfyle.com/johnend/dots-common-config-nvim/badges/plugins?style=for-the-badge" /></a>
<a href="https://dotfyle.com/johnend/dots-common-config-nvim"><img src="https://dotfyle.com/johnend/dots-common-config-nvim/badges/leaderkey?style=for-the-badge" /></a>
<a href="https://dotfyle.com/johnend/dots-common-config-nvim"><img src="https://dotfyle.com/johnend/dots-common-config-nvim/badges/plugin-manager?style=for-the-badge" /></a>

This is my NeoVim config. There are many like it, but this one is mine.

### Context for this config

I mostly work on the FrontEnd writing TypeScript (in React), and CSS. This
config is optimised for my use cases, so you mileage **_will_** vary 🛻.

Feel free to leave a comment if you're browsing and find an issue, or something
t# dots/common/.config/nvim

#### Keymaps

Almost all the keymaps can be found within `lua/core/config/wkmaps` the only
one's that aren't are LSP specific keymaps and the Blink overrides.

## Install Instructions

> Install requires Neovim 0.9+ (but 0.11+ is preferred). Always review the code
> before installing a configuration.

My NeoVim config is a in a subdirectory under `common/.config/nvim`. I use GNU
Stow to manage my dotfiles across Mac and Linux, you're more than welcome to
clone the whole repo, but there's a lot more in there than you probably want.
See the full dots for more.

However if you just want to try my config out you can clone the full repo:

```sh
git clone git@github.com:johnend/dots ~/.config/johnend/dots
```

Open Neovim with my config:

```sh
NVIM_APPNAME=johnend/dots/common/.config/nvim nvim
```

## Plugins

Some of these plugins aren't used in my config, but my settings for them can be
found in `lua/core/extra`. Those that are unused are highlighted in the list
below.

### bars-and-lines

- [Bekaboo/dropbar.nvim](https://dotfyle.com/plugins/Bekaboo/dropbar.nvim)
- [Bekaboo/deadcolumn.nvim](https://dotfyle.com/plugins/Bekaboo/deadcolumn.nvim)
- [SmiteshP/nvim-navic](https://dotfyle.com/plugins/SmiteshP/nvim-navic) -
  unused in favour of dropbar

### color

- [xzbdmw/colorful-menu.nvim](https://dotfyle.com/plugins/xzbdmw/colorful-menu.nvim)
- [NvChad/nvim-colorizer.lua](https://dotfyle.com/plugins/NvChad/nvim-colorizer.lua)
- [folke/twilight.nvim](https://dotfyle.com/plugins/folke/twilight.nvim)

### colorscheme

- [rebelot/kanagawa.nvim](https://dotfyle.com/plugins/rebelot/kanagawa.nvim)
- [cdmill/neomodern.nvim](https://github.com/cdmill/neomodern.nvim)
- [EdenEast/nightfox.nvim](https://dotfyle.com/plugins/EdenEast/nightfox.nvim)
- [catppuccin/nvim](https://dotfyle.com/plugins/catppuccin/nvim)
- [rose-pine/neovim](https://dotfyle.com/plugins/rose-pine/neovim)
- [folke/tokyonight.nvim](https://dotfyle.com/plugins/folke/tokyonight.nvim)

### comment

- [JoosepAlviste/nvim-ts-context-commentstring](https://dotfyle.com/plugins/JoosepAlviste/nvim-ts-context-commentstring)
- [folke/todo-comments.nvim](https://dotfyle.com/plugins/folke/todo-comments.nvim)
- [numToStr/Comment.nvim](https://dotfyle.com/plugins/numToStr/Comment.nvim)

### completion

- [saghen/blink.cmp](https://dotfyle.com/plugins/Saghen/blink.cmp)
- [zbirenbaum/copilot.lua](https://dotfyle.com/plugins/zbirenbaum/copilot.lua) -
  unused actually not 100% sure if this is the best AI plugin to use anymore.
  Regardless I prefer using the app directly rather than having AI tools
  embedded in my editor.

### cursorline

- [RRethy/vim-illuminate](https://dotfyle.com/plugins/RRethy/vim-illuminate)

### debugging

- [mfussenegger/nvim-dap](https://dotfyle.com/plugins/mfussenegger/nvim-dap) -
  unused
- [miroshQa/debugmaster.nvim](https://dotfyle.com/plugins/miroshQa/debugmaster.nvim) -
  unused

### diagnostics

- [folke/trouble.nvim](https://dotfyle.com/plugins/folke/trouble.nvim)

### editing-support

- [windwp/nvim-ts-autotag](https://dotfyle.com/plugins/windwp/nvim-ts-autotag)
- [HiPhish/rainbow-delimiters.nvim](https://dotfyle.com/plugins/HiPhish/rainbow-delimiters.nvim)
- [debugloop/telescope-undo.nvim](https://dotfyle.com/plugins/debugloop/telescope-undo.nvim)
- [nvim-treesitter/nvim-treesitter-context](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter-context)
- [folke/snacks.nvim](https://dotfyle.com/plugins/folke/snacks.nvim)
- [windwp/nvim-autopairs](https://dotfyle.com/plugins/windwp/nvim-autopairs)

### file-explorer

- [stevearc/oil.nvim](https://dotfyle.com/plugins/stevearc/oil.nvim)
- [nvim-neo-tree/neo-tree.nvim](https://dotfyle.com/plugins/nvim-neo-tree/neo-tree.nvim)

### formatting

- [stevearc/conform.nvim](https://dotfyle.com/plugins/stevearc/conform.nvim)

### fuzzy-finder

- [nvim-telescope/telescope.nvim](https://dotfyle.com/plugins/nvim-telescope/telescope.nvim)

### git

- [sindrets/diffview.nvim](https://dotfyle.com/plugins/sindrets/diffview.nvim)
- [lewis6991/gitsigns.nvim](https://dotfyle.com/plugins/lewis6991/gitsigns.nvim)
- I primarily use LazyGit in a Toggleterm

### icon

- [nvim-tree/nvim-web-devicons](https://dotfyle.com/plugins/nvim-tree/nvim-web-devicons)

### indent

- [lukas-reineke/indent-blankline.nvim](https://dotfyle.com/plugins/lukas-reineke/indent-blankline.nvim)

### keybinding

- [folke/which-key.nvim](https://dotfyle.com/plugins/folke/which-key.nvim)

### lsp

- [neovim/nvim-lspconfig](https://dotfyle.com/plugins/neovim/nvim-lspconfig)
- [aznhe21/actions-preview.nvim](https://dotfyle.com/plugins/aznhe21/actions-preview.nvim)
- [kosayoda/nvim-lightbulb](https://dotfyle.com/plugins/kosayoda/nvim-lightbulb)
- [SmiteshP/nvim-navbuddy](https://dotfyle.com/plugins/SmiteshP/nvim-navbuddy) -
  unused in favour of Dropbar and Trouble.
- [onsails/lspkind.nvim](https://dotfyle.com/plugins/onsails/lspkind.nvim)
- [mrcjkb/rustaceanvim](https://dotfyle.com/plugins/mrcjkb/rustaceanvim)

### markdown-and-latex

- [OXY2DEV/markview.nvim](https://dotfyle.com/plugins/OXY2DEV/markview.nvim)
- [toppair/peek.nvim](https://dotfyle.com/plugins/toppair/peek.nvim)

### marks

- [cbochs/grapple.nvim](https://dotfyle.com/plugins/cbochs/grapple.nvim)
- [ThePrimeagen/harpoon](https://dotfyle.com/plugins/ThePrimeagen/harpoon) -
  unused in favour of the above

### motion

- [tris203/precognition.nvim](https://dotfyle.com/plugins/tris203/precognition.nvim)
- [folke/flash.nvim](https://dotfyle.com/plugins/folke/flash.nvim)

### nvim-dev

- [MunifTanjim/nui.nvim](https://dotfyle.com/plugins/MunifTanjim/nui.nvim)
- [nvim-lua/plenary.nvim](https://dotfyle.com/plugins/nvim-lua/plenary.nvim)
- [folke/lazydev.nvim](https://dotfyle.com/plugins/folke/lazydev.nvim)
- [nvim-lua/popup.nvim](https://dotfyle.com/plugins/nvim-lua/popup.nvim)

### plugin-manager

- [folke/lazy.nvim](https://dotfyle.com/plugins/folke/lazy.nvim)

### programming-languages-support

- [dmmulroy/tsc.nvim](https://dotfyle.com/plugins/dmmulroy/tsc.nvim)

### project

- [nvim-telescope/telescope-project.nvim](https://dotfyle.com/plugins/nvim-telescope/telescope-project.nvim)

### search

- [MagicDuck/grug-far.nvim](https://dotfyle.com/plugins/MagicDuck/grug-far.nvim)

### session

- [stevearc/resession.nvim](https://dotfyle.com/plugins/stevearc/resession.nvim)
  - unused, but an optional depedency for cokeline (uncomment to install)

### snippet

- [rafamadriz/friendly-snippets](https://dotfyle.com/plugins/rafamadriz/friendly-snippets)
- [L3MON4D3/LuaSnip](https://dotfyle.com/plugins/L3MON4D3/LuaSnip)

### startup

- [goolord/alpha-nvim](https://dotfyle.com/plugins/goolord/alpha-nvim)

### statusline

- [nvim-lualine/lualine.nvim](https://dotfyle.com/plugins/nvim-lualine/lualine.nvim)

### syntax

- [nvim-treesitter/nvim-treesitter](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter)
- [nvim-treesitter/nvim-treesitter-textobjects](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter-textobjects)

### tabline

- [willothy/nvim-cokeline](https://dotfyle.com/plugins/willothy/nvim-cokeline)

### terminal-integration

- [akinsho/toggleterm.nvim](https://dotfyle.com/plugins/akinsho/toggleterm.nvim)

### test

- [nvim-neotest/neotest](https://dotfyle.com/plugins/nvim-neotest/neotest)
- [andythigpen/nvim-coverage](https://dotfyle.com/plugins/andythigpen/nvim-coverage)

### utility

- [folke/noice.nvim](https://dotfyle.com/plugins/folke/noice.nvim)

## Language Servers

- graphql
- html
- lua_ls
- sorbet
- svelte
- vtsls

This readme was generated by [Dotfyle](https://dotfyle.com)hat could be improved
😁.
