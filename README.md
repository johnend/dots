# Dotfiles

Hey there 👋

Welcome to my dotfiles! These are set up to fit my workflow across both Mac and Linux. Feel free to explore, steal bits, and make them your own.

---

### Linux (Sway, Hyprland, KDE)

![image](https://github.com/user-attachments/assets/0b36b509-ab04-44a4-a9ed-5149191dc0f5)

My Linux machines run Sway and KDE, and the `linux/` tree keeps shared and environment-specific configs under the same roof. Any common assets are stored in `linux/common/.config`, while the Sway, Hyprland, and KDE setups live in `linux/sway`, `linux/hyprland`, and `linux/kde`, respectively. After cloning, run `stow -t ~ common` and then stow the desktop folder that matches your session (e.g., `stow -t ~ linux/sway`). I switched from Hyprland because my old Mac struggled with it, but the hyprland folder is still there if you want to revisit that layout, and `linux/kde` keeps Plasma configs ready for future use.

### MacOS

![image](https://github.com/user-attachments/assets/fcfe09b8-98c5-4e51-960d-3121b8d752d4)

---

I split configurations between macOS and Linux so everything works seamlessly on both machines. Below are some tools and notes to help you get started:

#### Tools You’ll Probably Want

- **GNU Stow**  
  My preferred tool for managing dotfiles. There are others, but Stow fits how my brain works the best.

- **Zsh + Oh My Zsh**  
  I’m a big fan of Zsh and Oh My Zsh, and you’ll find some of my favorite plugins and Powerlevel10k themes in here. If you want to grab my setup, there’s a script at `common/omz-install.sh` that installs everything for you. If you’d rather pick and choose, treat it like a reference.

- **Sway (Linux)**  
  My laptop runs Sway. I switched from Hyprland because my 2013 Macbook Pro struggled with it (thanks, Nvidia GPU 🙄). I like Sway for day-to-day use though as it's pretty clean and easy. The shared configs live in `linux/common`, while the Sway-specific files sit in `linux/sway`, and the older Hyprland bits remain in `linux/hyprland` if you want to revisit that layout.

- **KDE (Linux)**
  My desktop which is a bit more recent runs KDE. Mostly because I use it for other things (gaming, KiCad, more... mouse driven stuff). There's some stuff in `linux/kde` for configs but I haven't spent a lot of time tweaking this yet.

- **NeoVim**  
  All my NeoVim goodies live in `common/.config/nvim`. If you’re looking for the ASCII art on my Alpha dashboard, that’s in there too.

---

#### How This Is Organized

Some app configs (like Ghostty and Kitty) are split between `common/` and the OS-specific folder, using imports in the OS’s config file. This way, I can tweak things like font sizes (Linux DE/WM scaling vs. macOS Retina) without duplicating everything.
