# Dotfiles

Well hello 👋

Welcome to my dotfiles.

{Linux Image Placeholder}

{MacOS Image Placeholder}

I have set these up to cater for my specific workflow and setups. I work on both
Mac and Linux so there are some things here that have to be in separate
directories in order for them to work properly on both machines.

Tools you will probably need to install these:

- GNU Stow - great for if you are doing this sort of shenanigans. If you're not
  using a tool like stow then you probably should be, especially if you spend
  your life in the terminal using TUIs.
- I like `zsh` and I like `ohmyzsh`, if you do too and you want to steal some of the
  things I have here then feel free, however if you just want to roll your own
  then there is a script `commmon/omz-install.sh` that will install some of my
  favourite plugins and powerlevel10k (if you don't want all of them then that's
  cool, just use it as a reference).
- My Linux machine uses Sway. I moved from Hyprland mostly due to my old Mac not
  liking it (probably due to it having an old Nvidia GPU), but honestly I prefer
  it for day to day work. However I would, move back to Hyprland if my machine
  could dealt with it (some of my previous Hyprland config files can stil be
  found in the Linux directory for that reason).
- If you're looking for my NeoVim setup then its all in `common/.config/nvim`,
  and if you're desperate to steal the ascii I use in my Alpha dashboard it can be
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

To disable them you can either use Karabiner elements (though this can have other
unintentional side effects), or _create_ a file under `~/Library/KeyBindings/`
called `DefaultKeyBinding.dict` and then insert the following:

```jsonc
{
  "\u0001" = noop; // Ctrl+A – move to beginning of paragraph
  "\u0002" = noop; // Ctrl+B – move backward one character
  "\u0003" = noop; // Ctrl+C – insert line break
  "\u0004" = noop; // Ctrl+D – delete forward one character
  "\u0005" = noop; // Ctrl+E – move to end of paragraph
  "\u0006" = noop; // Ctrl+F – move forward one character
  "\u0007" = noop; // Ctrl+G – ring bell
  "\u0008" = noop; // Ctrl+H – delete backward one character
  "\u0009" = noop; // Ctrl+I – insert tab
  "\u000A" = noop; // Ctrl+J – insert newline
  "\u000B" = noop; // Ctrl+K – delete to end of paragraph
  "\u000C" = noop; // Ctrl+L – center selection in visible area
  "\u000D" = noop; // Ctrl+M – insert line break
  "\u000E" = noop; // Ctrl+N – move to next line
  "\u000F" = noop; // Ctrl+O – open line (insert newline and move cursor backward)
  "\u0010" = noop; // Ctrl+P – move to previous line
  "\u0011" = noop; // Ctrl+Q – no default action
  "\u0012" = noop; // Ctrl+R – no default action
  "\u0013" = noop; // Ctrl+S – no default action
  "\u0014" = noop; // Ctrl+T – transpose characters
  "\u0015" = noop; // Ctrl+U – no default action
  "\u0016" = noop; // Ctrl+V – page down
  "\u0017" = noop; // Ctrl+W – delete to mark
  "\u0018" = noop; // Ctrl+X – prefix for other Emacs commands
  "\u0019" = noop; // Ctrl+Y – yank (paste)
  "\u001A" = noop; // Ctrl+Z – no default action
}
```

I have them all disabled, but you might only want to disable a few.
