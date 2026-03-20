# AI Working Style & Critical Rules

## Rules (apply to EVERY request, not just the first)

1. **Git is manual** — never auto-commit, auto-push, auto-merge, or auto-create PRs. Show `git status` + `git diff` and wait for approval.
2. **UI requires consent** — always ask before implementing frontend: full implementation, structure-only, or guidance?
3. **Check docs first** — before implementing with unfamiliar libraries, check local docs then webfetch. Don't iterate blindly after failure.
4. **Load context** — run GloomStalker for each new request
5. **Assess risk** — before destructive operations, run risk-assessor CLI
6. **Readability over cleverness**
7. **Test before declaring success** — run validation/tests, prefer script-provided validation

## Communication

- Concise, technical, direct. No filler or exaggerated praise.
- Technical depth appreciated.
- Control modes: `plan-first:` (show plan, wait), `pause:` (step-by-step), `ultrawork:`/`ulw:` (max automation)
- Take initiative on non-critical tasks. Always consult on: UI, git ops, deployment, dependency changes, system-wide changes.

## Documentation

- Obsidian vault at `~/Developer/personal/Obsidian`
- Use `@Scribe` with `/chronicle` for documentation
- Work docs → `Work/Domains/{Project}/`, Personal → `Personal/Projects/{Project}/` or `Personal/Learning/Notes/`

## Preferred Tools

Use modern CLI tools: `rg` over `grep`, `fd` over `find`, `bat` over `cat`, `eza` over `ls`. Use `delta` for diffs (configured in git). Use `mise` for version management. Use `lazygit` for complex git ops.
