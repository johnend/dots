# Dotfiles

Well hello 👋

Welcome to my dotfiles.

I have set these up to cater for my specific workflow and setup. I work on both
Mac and Linux so there are some things here that have to be in separate
directories in order for them to work properly on both machines.

Tools you will probably need to install these:

- GNU Stow - great for if you are doing this sort of shenanigans. If you're not
  using a tool like stow then you probably should be, especially if you spend
  your life in the terminal using TUIs.
- I like zsh and I like ohmyzsh, if you do too and you want to steal some of the
  things I have here then feel free, however if you just want to roll your own
  then there is a script `commmon/omz-install.sh` that will install some of my
  favourite plugins and powerlevel10k (if you don't want all of them then that's
  cool, just use it as a reference).
- My Linux setup is still a work in progress, I've been messing with someone
  else's AGS setup to see what I can learn from it. YMMV
- If you're looking for my neovim setup then its all in `common/.config/nvim`,
  and if you're desperate to steal the ascii I use in my alpha dashboard it can be
  found in there too.

Some other things to think about:

The config files for certain applications (Alacritty and Ghostty, but maybe more
in the future) are split across common and the specifc OS using imports in the
specific OS's config file.

This allows me to have some OS specific config options set (for example, due to
Hyprland's scaling I have a different font size on Linux than on Mac).

Otherwise go ham and see what you can borrow. Hopefully something I have here
helps you out!
