---
name: review-local
description: >
  Review the user's own unmerged work for bugs, regressions, risk, and missing tests with severity-first output and concrete file references. Handles two scopes: uncommitted/staged changes (pre-commit) and the full branch diff against its base (pre-PR self-review). Read-only — produces findings, does not edit code.
  TRIGGER when: user asks to review their local changes, uncommitted changes, staged changes, current diff, current branch, "review my branch", "review my changes", or "review before I open the PR".
  DO NOT TRIGGER when: user references an existing PR number/URL (use review-pr), wants a security-only audit (use built-in security-review), or wants the patch tidied/edited rather than reviewed (use pre-commit-cleanup).
---

# Review Local Changes

Review the user's own unmerged work and produce a structured, actionable findings list. **This is a review-only skill — never edit code, never commit.**

## 1. Determine scope

Two scopes are supported:

- **Working-tree scope** — uncommitted + staged changes (`git diff HEAD`). Use this for pre-commit reviews.
- **Branch scope** — every commit on the current branch vs its base (`git diff <base>...HEAD`). Use this for pre-PR self-reviews. Also show the commit list so the user can spot commits to drop/squash/amend.

### Choosing the scope

If the user names a scope explicitly (e.g. "review my branch", "review since main", "review my staged changes", "review uncommitted"), honour that.

Otherwise auto-detect:

| Working tree | Branch ahead of base | Action |
|---|---|---|
| Has uncommitted/staged changes | — | Working-tree scope |
| Clean | Ahead | Branch scope |
| Has changes AND branch is ahead | — | Ask which scope (or "both"); default to working-tree if not answered |
| Clean | At base | Say "nothing to review" and stop |

### Detecting the base branch

In order:
1. `gh repo view --json defaultBranchRef -q .defaultBranchRef.name` → e.g. `main`
2. If `gh` unavailable: try `origin/main`, then `origin/master`
3. If still ambiguous: ask the user

Use `git merge-base <base> HEAD` as the diff base so unrelated upstream commits don't pollute the review.

## 2. Gather the diff

- **Working-tree scope**: `git diff HEAD` (covers staged + unstaged together).
- **Branch scope**: `git log <base>..HEAD --oneline` for context, then `git diff $(git merge-base <base> HEAD)...HEAD` for the diff.

## 3. Output order

- Critical
- Warnings
- Suggestions

## 4. Focus areas

- Correctness and behavioural regressions
- Security and unsafe data handling
- Test gaps
- Maintainability and coupling risks
- **Branch scope only**: commits that look like good candidates to drop, squash, or amend (e.g. WIP commits, reverted-later changes, fix-up commits that could fold into their predecessor). Flag as Suggestions, not Critical.

## 5. Output requirements

- State which scope was reviewed at the top.
- For branch scope, include the commit list before findings.
- Include file paths and line numbers when possible (`file:line` format).
- Provide concrete remediation guidance.
- If no findings, state that explicitly and list residual risk.
