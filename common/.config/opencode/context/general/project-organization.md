# Project Organization

## Directory Structure

```
~/Developer/
├── work/           # Work projects
└── personal/       # Personal projects
    └── dots/       # Dotfiles (GNU Stow)
        ├── common/ # Cross-platform (nvim, zsh, git, tmux, starship, mise, AI tools)
        ├── linux/  # Sway, KDE, Linux-specific
        ├── macos/  # AeroSpace, macOS overrides
        └── lib/    # Install scripts
```

## Stow Usage

```bash
stow common -t ~    # Symlink shared configs
stow linux -t ~     # Linux-specific
stow macos -t ~     # macOS-specific
stow -D common -t ~ # Remove symlinks
```

## OpenCode Context System

```
~/.config/opencode/context/
├── general/           # Always available (user prefs, code style, git, tools)
├── work/              # Work-specific (gitignored)
│   ├── conventions.md
│   ├── core/          # Testing, state, API, RN, Nx patterns
│   ├── ui/            # React, Fela, styling patterns
│   └── projects/      # Per-project context
└── personal/          # Personal projects
    └── projects/      # Per-project context
```

GloomStalker loads context hierarchically: always-load → keyword-matched → project-specific.

## AI Agent Files

- `AGENTS.md` in project root — project-specific AI instructions
- `.ai/` directory — custom AI commands and workflows
- `~/.config/opencode/` — OpenCode config, agents, commands, hooks
