# Git Workflow

## Core Settings

- Editor: nvim | Pager: delta (side-by-side, catppuccin-mocha) | Default branch: main
- Merge conflict style: diff3 | Force push: `--force-with-lease` only
- GitHub: authenticated via `gh` CLI | LFS: enabled

## Commit Style

Conventional commits via git aliases (when the repo uses this convention):
```bash
git fix "msg"      # fix: msg
git feat "msg"     # feat: msg
git chore "msg"    # chore: msg
git docs "msg"     # docs: msg
git refactor "msg" # refactor: msg
git test "msg"     # test: msg
```

Imperative tense, under 72 chars first line. Group related edits into a single commit.

## AI Git Operations

**Allowed (read-only):** `git status`, `git log`, `git diff`, `git show`, `git branch`, `git remote -v`, `git blame`

**Requires explicit approval:** `git add`, `git commit`, `git push`, `git pull`, `git fetch`, `git checkout`/`switch`, `git merge`, `git rebase`, `git reset`, `git stash`, `git branch -d/-D`

**Forbidden:** `git push --force` (use `--force-with-lease`), `git reset --hard` without confirmation, force pushing to main/master, rewriting public history

## Before Committing

1. `git status` to see all changes
2. `git diff` to review (delta configured automatically)
3. Stage related files
4. Wait for user approval — never commit without explicit request
