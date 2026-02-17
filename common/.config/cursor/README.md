# Cursor user-level configuration

This directory holds **user-level** Cursor configuration: rules, commands, subagents, and Agent Skills you want available across all projects.

## Where Cursor actually looks

Cursor does not read this directory by default. It uses:

| Config type   | Project-level (per repo) | User-level (global)                               |
| ------------- | ------------------------ | ------------------------------------------------- |
| **Rules**     | `.cursor/rules/`         | Cursor Settings → Rules (UI; path not documented) |
| **Commands**  | `.cursor/commands/`      | `~/.cursor/commands/`                             |
| **Subagents** | `.cursor/agents/`        | `~/.cursor/agents/`                               |
| **Skills**    | `.cursor/skills/`        | `~/.cursor/skills/`                               |

So this folder is a **source of truth** for your personal config. To use it:

1. **Symlink** into `~/.cursor/` so Cursor picks it up:
   ```bash
   mkdir -p ~/.cursor
   ln -snf ~/.config/cursor/rules   ~/.cursor/rules    # if Cursor ever supports user rules on disk
   ln -snf ~/.config/cursor/commands ~/.cursor/commands
   ln -snf ~/.config/cursor/agents   ~/.cursor/agents
   ln -snf ~/.config/cursor/skills   ~/.cursor/skills
   ```
2. **User rules**: Copy or paste from `rules/` into **Cursor Settings → Rules** (User Rules). Cursor does not document a file path for global rules.
3. **Version control**: You can keep this repo (or a copy) in dotfiles and link it as above.

## Layout

```
~/.config/cursor/
├── README.md           # This file
├── rules/              # User rules (templates + any you add)
│   ├── _template.mdc   # Template for new rules
│   └── ...
├── commands/           # Slash-commands (e.g. /code-review)
│   ├── _template.md    # Template for new commands
│   └── ...
├── agents/             # Subagents (e.g. code-reviewer, debugger)
│   ├── _template.md    # Template for new subagents
│   └── ...
└── skills/             # Agent Skills (one directory per skill, each with SKILL.md)
    ├── README.md       # Skills layout and symlink
    ├── _template.SKILL.md   # Template – copy into a new skill dir as SKILL.md
    └── ...
```

## Rules (`.cursor/rules/` or Settings → Rules)

- **Project**: `.cursor/rules/*.mdc` or `.md` — version-controlled, team-shared.
- **User**: Defined in **Cursor Settings → Rules**. Use this folder to draft or store the same content.
- Rule types: Always Apply, Apply Intelligently, Apply to Specific Files (globs), Apply Manually (@rule).

## Commands (`.cursor/commands/` and `~/.cursor/commands/`)

- **Format**: One `.md` file per command. Filename (without `.md`) becomes the command name.
- **Usage**: Type `/` in chat; Cursor lists project + user commands. Content is the prompt sent to the model.
- **User-level**: Put files in `~/.cursor/commands/` (or symlink this `commands/` there).

## Subagents (`.cursor/agents/` and `~/.cursor/agents/`)

- **Format**: `.md` with YAML frontmatter (`name`, `description`) and a body (system prompt).
- **User-level**: Put files in `~/.cursor/agents/` (or symlink this `agents/` there).
- **Naming**: Lowercase letters and hyphens only (e.g. `code-reviewer`).

## Skills (`.cursor/skills/` and `~/.cursor/skills/`)

- **Format**: One **directory** per skill, with at least `SKILL.md` inside (YAML frontmatter: `name`, `description`; body = instructions). Optional: `reference.md`, `examples.md`, `scripts/`.
- **User-level**: Put skill directories in `~/.cursor/skills/` (or symlink this `skills/` there). Do not use `~/.cursor/skills-cursor/` (reserved for Cursor).
- See `skills/README.md` for layout and template.

## Patterns borrowed from other tools

- **Dotfiles**: Keep config in one place (`~/.config/cursor`), symlink into `~/.cursor` so Cursor and your backup/version control stay in sync.
- **Profiles**: Use different rule/command sets per “profile” by swapping symlinks or folders (e.g. `cursor-work` vs `cursor-personal`).
- **Layers**: Prefer a few “always” rules (tone, security) and many file- or task-specific rules so context stays relevant.

See `_template.*` in each directory for the expected format and field descriptions.

## Starter examples included

- **rules/concise-style.mdc** — Always-applied rule for short, actionable replies (paste into Settings → Rules if you want it global).
- **commands/code-review.md** — `/code-review`: quick review with Critical / Warnings / Suggestions.
- **commands/explain-changes.md** — `/explain-changes`: summarize recent git changes and highlight risks.
- **commands/add-tests.md** — `/add-tests`: write tests for untested code; focus on implementation coverage, not libraries; run only the new tests.
- **commands/implement-brief.md** — `/implement-brief`: produce a short implementation brief (decisions, state, requirements) so the next step can implement without re-explaining.
- **rules/multi-step-todos.mdc** — For multi-step tasks, propose a short todo list and get approval before executing (apply intelligently).
- **rules/destructive-confirm.mdc** — Before destructive or high-impact operations, state the risk and ask for explicit confirmation (apply intelligently).
- **agents/code-reviewer.md** — Subagent for focused code review (invoke manually or let the model delegate).
- **agents/debugger.md** — Subagent for errors and failing tests (root cause + minimal fix).
- **commands/retrospective.md** — `/retrospective`: run the **Retrospective & Doctrine Evolution Protocol** (session analysis → lesson distillation → doctrine integration → final report). Use at **end of significant sessions** to capture lessons and update rules.
- **rules/session-retrospective.mdc** — When the user signals task/session complete, suggest running `/retrospective` once (apply intelligently).

After symlinking `commands` and `agents` to `~/.cursor/`, use `/code-review`, `/explain-changes`, `/retrospective`, `/test-fix`, `/add-tests`, `/ui-create`, and `/implement-brief` in chat as needed. Ask the agent to use the code-reviewer or debugger subagent when relevant.

### End-of-session: doctrine evolution

To harden behaviour across sessions, run **`/retrospective`** when a substantial task or session is done. The command runs the full protocol: analyse this conversation → distil durable lessons → update project or global rule files → produce a report. The **session-retrospective** rule prompts the agent to suggest this when you indicate you're done; you can also run `/retrospective` yourself whenever you want to capture learnings.

---

## Migrated from OpenCode (`~/.config/opencode`)

The following were ported from your OpenCode config (dotfiles) and adapted to Cursor semantics (no OpenCode-only hooks or agents; Cursor uses rules, commands, and subagents only).

### Rules (paste into Cursor Settings → Rules or use in project `.cursor/rules/`)

| File                              | Source                                                | Purpose                                                                           |
| --------------------------------- | ----------------------------------------------------- | --------------------------------------------------------------------------------- |
| **rules/git-and-safety.mdc**      | `context/general/ai-working-style.md`                 | Manual git only, ask before UI, check docs before libraries, apply every request. |
| **rules/code-style.mdc**          | `context/general/code-style.md`                       | Comment WHY not WHAT; readability over cleverness; when to comment vs skip.       |
| **rules/git-workflow.mdc**        | `context/general/git-workflow.md`                     | Conventional commits, branch naming, delta, allowed vs approval-required git ops. |
| **rules/prefer-modern-cli.mdc**   | `context/general/cli-tools.md` + `dev-environment.md` | When suggesting shell commands: prefer rg, fd, bat, eza, delta, mise.             |
| **rules/multi-step-todos.mdc**    | (OpenCode Todo Enforcer behaviour)                    | For multi-step or ambiguous tasks, propose a todo list and get approval first.    |
| **rules/destructive-confirm.mdc** | (OpenCode Risk Assessor behaviour)                    | Before destructive/high-impact ops, state risk and ask for explicit confirmation. |

### Commands

| Command              | Source                             | Purpose                                                                                                                                                                                                      |
| -------------------- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **/chronicle**       | `commands/scribe/chronicle.md`     | Document to Obsidian vault (`~/Developer/personal/Obsidian`); suggest location by project type; natural voice + technical detail. (No OpenCode chronicle hook—content is produced in chat or as copy-paste.) |
| **/debug-with-me**   | `commands/mentor/debug-with-me.md` | Structured 5-step debugging: symptom → hypothesis → investigate → execute → iterate. Teach the process.                                                                                                      |
| **/reading-list**    | `commands/mentor/reading-list.md`  | Curated learning resources for a topic (foundational → intermediate → advanced) with links and short "why read" notes.                                                                                       |
| **/test-fix**        | `commands/test-fix.md`             | Debug failing tests: scoped run → root cause → fix → re-run until passing.                                                                                                                                   |
| **/add-tests**       | `commands/add-tests.md`            | Write tests for untested code; test the implementation not libraries; meaningful coverage; run only new tests.                                                                                               |
| **/ui-create**       | `commands/ui-create.md`            | Create UI component only after asking: full implementation, basic structure, or guidance only. Matches "ask before UI" preference.                                                                           |
| **/implement-brief** | `commands/implement-brief.md`      | Produce implementation brief (decisions, state, requirements) so next step can implement without re-explaining.                                                                                              |

### Subagents

| Agent      | Source             | Purpose                                                                                                                                                    |
| ---------- | ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **scribe** | `agents/scribe.md` | Writing specialist: docs, PRs, commit messages, Obsidian chronicles. Natural human voice; technical + readable.                                            |
| **mentor** | `agents/mentor.md` | Teaching and code review: explain why, review performance/security/scalability, guide debugging; offer reading-list and implementation brief for handoffs. |

### What wasn't ported

- **GloomStalker / Todo Enforcer / Risk Assessor:** OpenCode-specific CLIs. Cursor has no hook system; your workspace security rule and the new rules cover git safety and risk awareness. For todo enforcement, you can add a project rule or rely on the agent's built-in todo behavior.
- **Artificer and other OpenCode agents:** Cursor has a single main agent; handoff is done by writing a clear implementation brief (mentor's handoff section and /debug-with-me / /reading-list cover this).
- **OpenCode chronicle hook and obsidian-mapper:** Cursor can't run those Node scripts. /chronicle describes the workflow and locations; you create or paste the doc in Obsidian yourself (or use a local script separately).
- **Project-specific context** (`context/work/`, `context/personal/projects/`): Cursor has no equivalent to OpenCode’s project context files. Use **per-repo** `.cursor/rules/` or `AGENTS.md` in each repository for work/personal project differences, conventions, and project-specific patterns.
