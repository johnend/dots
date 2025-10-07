# Dotfiles

Hey there 👋

Welcome to my dotfiles! These are set up to fit my workflow across both Mac and Linux. Feel free to explore, steal bits, and make them your own.

---

### Linux (Sway)

![image](https://github.com/user-attachments/assets/0b36b509-ab04-44a4-a9ed-5149191dc0f5)

### MacOS

![image](https://github.com/user-attachments/assets/fcfe09b8-98c5-4e51-960d-3121b8d752d4)

---

I split configurations between macOS and Linux so everything works seamlessly on both machines. Below are some tools and notes to help you get started:

#### Tools You’ll Probably Want

- **GNU Stow**  
  A lifesaver for managing dotfiles. If you spend any time in the terminal, you’ll appreciate how it keeps everything tidy. If you’re not already using Stow, give it a try!

- **Zsh + Oh My Zsh**  
  I’m a big fan of Zsh and Oh My Zsh, and you’ll find some of my favorite plugins and Powerlevel10k themes in here. If you want to grab my setup, there’s a script at `common/omz-install.sh` that installs everything for you. If you’d rather pick and choose, treat it like a reference.

- **Sway (Linux)**  
  My Linux machine runs Sway. I switched from Hyprland because my old Mac struggled with it (thanks, Nvidia GPU 🙄), but honestly, I prefer Sway for day-to-day use. If your rig can handle Hyprland, you’ll find my old Hyprland configs in the `linux/` directory.

- **NeoVim**  
  All my NeoVim goodies live in `common/.config/nvim`. If you’re looking for the ASCII art on my Alpha dashboard, that’s in there too.

---

#### How This Is Organized

Some app configs (like Alacritty and Kitty) are split between `common/` and the OS-specific folder, using imports in the OS’s config file. This way, I can tweak things like font sizes (Hyprland scaling vs. macOS Retina) without duplicating everything.

Dive in, mix and match, and see what works for you!
