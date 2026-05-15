---
name: review-pr
description: >
  Review a colleague's pull request and output a structured review with actionable findings — no auto-commenting on GitHub, no plan mode, no implementation.
  TRIGGER when: user asks to review a PR, review a pull request, check a PR, look at a PR, give feedback on a PR, first-pass review, or references a PR number/URL to review.
  DO NOT TRIGGER when: user asks to fetch or summarize existing PR comments (use get-pr-comments), or wants to review their own uncommitted changes (use code-review).
---

# Review PR

Review a colleague's pull request and output a structured, actionable review the user can post or reference on the PR. **This is a review-only skill — never enter plan mode, never implement fixes, never modify code.**

## Input

- Accepts a PR number, URL, or branch name as the argument.
- If no argument is provided, ask for the PR number.

## Steps

### 1. Gather context

Run these in parallel:

- `gh pr view <pr> --json title,body,author,baseRefName,headRefName,files,additions,deletions,labels` — PR metadata.
- `gh pr diff <pr>` — full diff.
- `gh pr view <pr> --json comments,reviews,reviewRequests` — existing review comments (to avoid duplicating already-flagged issues).
- `gh api repos/{owner}/{repo}/pulls/{pr}/comments` — inline review comments.

### 2. Read project standards

Read the repo's coding standards and instruction files to calibrate findings:

- `CLAUDE.md` (project root)
- `.github/copilot-instructions.md`
- Any `.github/instructions/` files relevant to the changed areas (e.g. analytics, copy, routing)

### 3. Read surrounding code

For each changed file, read the full file (not just the diff) to understand context — types, sibling functions, existing patterns. This prevents false positives and reveals whether the PR is following or breaking local conventions.

### 4. Analyse the diff

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

### 5. Output the review

Output the review directly as formatted text in your response. **Do NOT use EnterPlanMode, tasks, or any planning tools.**

Use this structure:

---

**PR: `<title>` (#`<number>`) by `<author>`**

**Summary**
> Brief description of what the PR does, products/areas affected, size (+additions / -deletions across n files).

**Overall assessment**: Clean / Minor issues / Needs changes — one-line verdict.

**Test coverage**
> Assessment of whether the changes are adequately tested, and any specific gaps.

**Already flagged by reviewers**
> Summary of existing review comments so you know what's already covered. Omit if none.

---

### Findings

Present all findings as a single markdown table, ordered by severity (Critical → Warning → Suggestion → Nit → Question):

| File:Line | Severity | Category | Finding |
|-----------|----------|----------|---------|
| `path/to/file.ts:42` | Warning | Bug/Correctness | Brief description — what the issue is and why it matters |

Categories: Bug/Correctness, Security, Performance, Test Gap, Style/Convention, Naming, Architecture, Question

If the PR is clean, replace the table with a single line stating that and note any residual risk.

---

### Inline comments

For each row in the findings table, output a paste-ready block for GitHub's PR review UI, grouped by file:

> **`<file_path>`** — line `<line_number>` (`<severity>`)
>
> ```<lang>
> // the specific line(s) of code this comment targets (from the diff)
> ```
>
> **Comment:**
> The review comment text — actionable, concise, written as if addressing the PR author directly.

Use line numbers from the PR diff (the lines the author would see in the GitHub Files Changed tab). Include 2-3 lines of surrounding code for context.

---

If a section has no items, omit it.

## Rules

- **Review only** — never enter plan mode, never implement fixes, never edit code, never push, comment, approve, or request changes on GitHub.
- Output the review as text in your response — not as a plan, not as tasks.
- Keep descriptions concise — one or two lines per finding.
- Always include `file:line` references.
- **Tone**: Frame suggestions and nits as short questions, not prescriptive statements. Raise the concern, ask if it's worth addressing, and give the author an easy out. Avoid lecturing or over-explaining — the user will be pasting these as-is and wants them to read naturally as peer feedback, not AI output.
- Flag uncertainty: if you're unsure about a finding, frame it as a question rather than a statement.
- Consider the PR holistically: does the change make sense as a unit? Is it too large? Should it be split?
