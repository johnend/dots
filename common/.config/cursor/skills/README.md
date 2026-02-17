# Skills (Cursor Agent Skills)

**User-level** Cursor Agent Skills live here. Each skill is a **directory** containing at least `SKILL.md`.

## Layout

```
~/.config/cursor/skills/
├── README.md             # This file
├── _template.SKILL.md    # Template for new skills (copy into a new directory as SKILL.md)
└── your-skill-name/      # One directory per skill
    ├── SKILL.md          # Required – frontmatter + instructions (copy from _template.SKILL.md)
    ├── reference.md      # Optional
    ├── examples.md       # Optional
    └── scripts/          # Optional – utility scripts
```

To create a new skill: create a directory (e.g. `my-skill/`), then copy the template in as `SKILL.md`:  
`cp _template.SKILL.md my-skill/SKILL.md` (or copy the file into the new folder and rename).

## SKILL.md format

- **Frontmatter:** `name` (lowercase, hyphens), `description` (what it does and when to use it; agent uses this to decide when to apply).
- **Body:** Markdown instructions and examples. Keep it concise; the agent shares context with the rest of the session.

Do **not** create skills in `~/.cursor/skills-cursor/` — that is reserved for Cursor’s built-in skills.

## Making Cursor see these skills

Cursor reads **user-level** skills from `~/.cursor/skills/`. Symlink this folder so your config is the source of truth:

```bash
mkdir -p ~/.cursor
ln -snf ~/.config/cursor/skills ~/.cursor/skills
```

## Scope

| Type            | Path                                             | Scope             |
| --------------- | ------------------------------------------------ | ----------------- |
| Personal (here) | `~/.config/cursor/skills/` → `~/.cursor/skills/` | All your projects |
| Project         | `.cursor/skills/` in a repo                      | That repository   |
