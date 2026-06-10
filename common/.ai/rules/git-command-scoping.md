---
description: Git command scoping — cap log output with -n, scope diffs to known paths, start with --stat before full content, avoid re-running status/log/diff calls already visible in the session, never use git status -uall
alwaysApply: true
---

## Git Command Scoping

### Core Pattern: Scope Before Running

- Git commands flood context easily — a default `git log` can return hundreds of commits, a default `git diff` can be thousands of lines. Cap and scope every git call to what you actually need:

  ```bash
  git log --oneline -n 20                 # browse recent history
  git log --oneline -n 20 -- path/        # recent history for a specific area
  git diff --stat                         # file-level overview, no content
  git diff -- path/to/file                # full diff scoped to one file
  ```

### Log Scoping

- **`--oneline -n N`** — browse recent commits without full message bodies
- **`-- path`** — scope to specific files or directories
- **`--since=` / `--until=`** — time-bounded windows
- **`--author=`** — when looking for a specific contributor's work
- **`-p -- path`** — patch view scoped to a single path when you need both the commit list and the content

### Diff Scoping

- **`git diff --stat`** — file-level summary with insertion/deletion counts; cheap first look
- **`git diff -- path`** — full diff content for a specific path
- **`git diff base..head -- path`** — branch-vs-branch on a specific path
- **`git show --stat <commit>`** — list of files in a commit without the full patch
- **`git show <commit> -- path`** — what one commit changed in a specific path

### Status Scoping

- Default `git status` is fine — it self-scopes to working tree changes
- **NEVER use `-uall`** — already in the system prompt, but worth restating: it can dump thousands of untracked files on a large repo and exhaust memory
- Don't re-run `git status` if it was already shown earlier in the same session and nothing has changed since

### Avoid Repetition

- The session already contains earlier git output. Before re-running `git status`, `git log`, or `git diff`, check whether the answer is already in context
- If you ran `git diff --stat` and now need the full diff for one file, run `git diff -- that_file` — don't re-run the unscoped `git diff`

### Remote-Contact Commands Are Different

- `git push`, `git fetch`, `git pull`, `git ls-remote`, `git commit`, and `gh` are exceptions to output suppression — their stderr is load-bearing for auth and hook errors. Cross-reference `bash-output-suppression.md` for full guidance. Scoping is still useful (e.g., `gh pr list --limit 10`), but never suppress their output

### Anti-Patterns

- **`git log` with no limit** — dumps hundreds of commits when you wanted the last few
- **`git show <merge>`** — full patch view of a large merge commit can be tens of thousands of lines; use `--stat` first
- **Unscoped `git diff`** when you already know the affected paths
- **Re-running** `git status` / `git log` / `git diff` when the same output is already visible in the session
- **`git status -uall`** on large repos — memory exhaustion risk
- **Piping git through `cat`** — git already paginates correctly; `cat` adds noise without value

### Review Checklist for New Git Calls

Before running a git command, verify:

- ✓ Does this have a limit (`-n`, `--max-count`) or natural scope?
- ✓ Is there a path filter that would shrink the output?
- ✓ Have I already run this (or an equivalent) in the session?
- ✓ For diffs: am I starting with `--stat` before going to full content?
- ✓ For remote commands (push/fetch/pull/commit/gh): am I letting output flow through, not suppressing?
