---
name: review-pr
description: >
  Review a colleague's pull request and output a structured review with actionable findings — no auto-commenting on GitHub, no plan mode, no implementation.
  TRIGGER when: user asks to review a PR, review a pull request, check a PR, look at a PR, give feedback on a PR, first-pass review, or references a PR number/URL to review.
  DO NOT TRIGGER when: user asks to fetch or summarize existing PR comments (use get-pr-comments), or wants to review their own uncommitted changes (use review-local).
---

# Review PR

Review a colleague's pull request and output a structured, actionable review the user can post or reference on the PR. **This is a review-only skill — never enter plan mode, never implement fixes, never modify code.**

> [!NOTE]
> `gh` CLI commands require sandbox-disabled execution and should be batched upfront rather than retried after a block

## Input

- Accepts a PR number, URL, or branch name as the argument.
- If no argument is provided, ask for the PR number.

## Steps

### 1. Gather context

Never load the full diff into the main context up front. Large PRs have overflowed context before.

Run these in parallel:

- `gh pr view <pr> --json title,body,author,baseRefName,headRefName,files,additions,deletions,labels` — PR metadata and per-file line counts.
- `gh pr diff <pr> --name-only` — changed file list.
- `gh pr view <pr> --json comments,reviews,reviewRequests` — existing review comments (to avoid duplicating already-flagged issues).
- `gh api repos/{owner}/{repo}/pulls/{pr}/comments` — inline review comments.

Then size the review:

- **Small** (under ~500 changed lines and under ~15 files): read `gh pr diff <pr>` directly and continue to step 2.
- **Large**: group files by area (feature, layer, or directory) and launch one subagent per group in a single message (`Explore` in Claude; a subagent in Codex). Each gets the PR number, its file list, the repo path and these instructions: read the diff hunks and surrounding code for these files only; return candidate findings as `file:line · category · severity · one-line issue · the 2-3 relevant code lines`; under 300 words; no preamble. If tests or logs are relevant, one extra subagent finds the tests covering the changed code and reports gaps under 200 words.

Write the review from the subagent reports. Read specific hunks yourself (`gh pr diff <pr> -- <path>` or the local file) only to confirm a finding before including it. Drop anything you can't confirm, or frame it as a Question.

### 2. Read project standards

Read the repo's coding standards and instruction files to calibrate findings:

- `CLAUDE.md` (project root)
- `.github/copilot-instructions.md`
- Any `.github/instructions/` files relevant to the changed areas (e.g. analytics, copy, routing)

### 3. Read surrounding code

For each changed file, read the full file (not just the diff) to understand context — types, sibling functions, existing patterns. This prevents false positives and reveals whether the PR is following or breaking local conventions. On large PRs this is the subagents' job; only do it yourself for files behind a finding you're confirming.

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

Output the review directly as formatted text in your response. **Do NOT enter plan mode or use planning/task tools.**

Use this structure.

#### Header block

```
**PR: `<title>` (#`<number>`) by `<author>`**

**Summary**
Brief description of what the PR does, products/areas affected, size
(+additions / -deletions across n files).

**Overall assessment:** Clean / Minor issues / Needs changes — one-line verdict.

**Test coverage:** Assessment of whether changes are adequately tested and any gaps.

**Already flagged by reviewers:** Summary of existing review comments so you know
what's already covered. Omit if none.

**<n> warnings · <n> suggestions · <n> nits · <n> questions**
```

The severity tally line goes last in the header. Omit severities with zero findings.

#### Findings — severity-grouped, one self-contained block per finding

For each severity that has findings, emit a box-drawing header, then each finding inline. Severities go in order: Critical → Warning → Suggestion → Nit → Question.

Box header (use this exact width — 62 chars between the corners):

```
╔══════════════════════════════════════════════════════════════╗
║  WARNINGS · <n> findings                                     ║
╚══════════════════════════════════════════════════════════════╝
```

Each finding is a self-contained block:

````
### `<file_path>:<line>` · <Category>

```<lang>
// 2-3 lines of surrounding code from the diff for context
```

The review comment — actionable, concise, written as if addressing the PR
author directly. This is what the user will paste into GitHub.
````

Between findings within the same severity section, separate with a thick rule:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

No rule before the first finding or after the last one. No rule between severity sections — the next box header is enough.

Categories: Bug/Correctness, Security, Performance, Test Gap, Style/Convention, Naming, Architecture, Question

If the PR is clean, skip the findings section and add a single line stating that, noting any residual risk.

## Rules

- **Review only** — never enter plan mode, never implement fixes, never edit code, never push, comment, approve, or request changes on GitHub.
- Output the review as text in your response — not as a plan, not as tasks.
- Keep descriptions concise — one or two lines per finding.
- Always include `file:line` references.
- **Tone**: Frame suggestions and nits as short questions, not prescriptive statements. Raise the concern, ask if it's worth addressing, and give the author an easy out. Avoid lecturing or over-explaining — the user will be pasting these as-is and wants them to read naturally as peer feedback, not AI output.
- Flag uncertainty: if you're unsure about a finding, frame it as a question rather than a statement.
- Consider the PR holistically: does the change make sense as a unit? Is it too large? Should it be split?
