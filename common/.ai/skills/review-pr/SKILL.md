---
name: review-pr
description: >
  Review a colleague's pull request and produce a structured checklist plan for manual review — no auto-commenting on GitHub.
  TRIGGER when: user asks to review a PR, review a pull request, check a PR, look at a PR, give feedback on a PR, first-pass review, or references a PR number/URL to review.
  DO NOT TRIGGER when: user asks to fetch or summarize existing PR comments (use get-pr-comments), or wants to review their own uncommitted changes (use code-review).
---

# Review PR

Produce a first-pass review checklist for a colleague's pull request so the user can walk through it themselves. **Never post comments or reviews on GitHub.**

## Input

- Accepts a PR number, URL, or branch name as the argument.
- If no argument is provided, ask for the PR number.

## Steps

### 1. Gather context

Run these in parallel:

- `gh pr view <pr> --json title,body,author,baseRefName,headRefName,files,additions,deletions,labels` — PR metadata.
- `gh pr diff <pr>` — full diff.
- `gh pr view <pr> --json comments,reviews,reviewRequests` — existing review comments (to avoid duplicating already-flagged issues).

### 2. Read project standards

Read the repo's coding standards and instruction files to calibrate findings:

- `CLAUDE.md` (project root)
- `.github/copilot-instructions.md`
- Any `.github/instructions/` files relevant to the changed areas (e.g. analytics, copy, routing)

### 3. Analyse the diff

Review every changed file in the diff. For each finding, record:

- **File path and line(s)** — use `file:line` format
- **Category** — one of: Bug/Correctness, Security, Performance, Test Gap, Style/Convention, Naming, Architecture, Question
- **Severity** — Critical, Warning, Suggestion, or Nit
- **Description** — what the issue is and why it matters
- **Already flagged** — if an existing review comment covers this, note it and skip

Prioritise:
1. Correctness and behavioural regressions
2. Security and unsafe data handling
3. Missing or insufficient tests
4. Violations of project conventions (from step 2)
5. Readability, naming, structure

### 4. Check for repo-specific conventions

- Read any project-level instruction files or CLAUDE.md for repo-specific patterns and conventions.
- Flag violations of those conventions in findings.

### 5. Output as a plan

Present findings as a **plan** (use EnterPlanMode / task list) with the following structure:

```
## PR: <title> (#<number>) by <author>

### Summary
- Brief description of what the PR does
- Products/areas affected
- Size: +<additions> / -<deletions> across <n> files

### Critical (must fix)
- [ ] <file:line> — description

### Warnings (should fix)
- [ ] <file:line> — description

### Suggestions (nice to have)
- [ ] <file:line> — description

### Nits
- [ ] <file:line> — description

### Questions (things to clarify with the author)
- [ ] <file:line> — question

### Test coverage
- Assessment of whether the changes are adequately tested
- Specific test gaps to check

### Already flagged by reviewers
- Summary of existing review comments (so you know what's covered)
```

If a section has no items, omit it. If the PR looks clean, say so explicitly and note any residual risk.

## Rules

- **Read-only** — never push, comment, approve, or request changes on GitHub.
- Keep descriptions concise — one line per finding where possible.
- Always include file:line references.
- Flag uncertainty: if you're unsure about a finding, frame it as a question rather than a statement.
- Consider the PR holistically: does the change make sense as a unit? Is it too large? Should it be split?
