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

### Other things to note

I have disabled the Emacs text based shortcuts due to them causing issues when
typing and using a mod-tap with CTRL and Space on the same key. If you don't
know what this means then don't worry about it, but if you do, then you might
want to do the same.

To do so, you can either use Karabiner elements (though this can have other
unintentional side effects), or _create_ a file under `~/Library/KeyBindings/`
called `DefaultKeyBinding.dict` and then insert the following:

```
{
    "^a" = noop; // Disable Ctrl+A
    "^b" = noop; // Disable Ctrl+B
    "^d" = noop; // Disable Ctrl+D
    "^e" = noop; // Disable Ctrl+E
    "^f" = noop; // Disable Ctrl+F
    "^h" = noop; // Disable Ctrl+H
    "^k" = noop; // Disable Ctrl+K
    "^n" = noop; // Disable Ctrl+N
    "^p" = noop; // Disable Ctrl+P
    "^t" = noop; // Disable Ctrl+T
    "^v" = noop; // Disable Ctrl+V
    "^w" = noop; // Disable Ctrl+W
    "^y" = noop; // Disable Ctrl+Y
}
```

I have them all disabled, but you might only want to disable a few.
