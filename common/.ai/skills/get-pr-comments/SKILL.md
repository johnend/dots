---
name: get-pr-comments
description: Fetch review and discussion comments for the current pull request, classify human-reviewer feedback against tracked patterns, and turn it all into a concise action list.
effort: medium
model: claude-haiku-4-5
---

# Get PR Comments

Use this skill when the user wants a concise summary of feedback on the active pull request for the current branch. As well as summarising, this skill maintains a long-running ledger of feedback patterns from human teammates in the user's Obsidian vault.

# 1. Resolve the active PR

- Use the current branch to identify the open pull request.
- If there is no active PR for the branch, say so clearly and stop.
- Note the PR author's GitHub handle — comments from the author themselves are excluded from pattern tracking.

# 2. Fetch feedback

Collect all three comment types using `gh`:

- **Inline review comments** (on specific lines of code): `gh api repos/{owner}/{repo}/pulls/{pr}/comments`
- **PR discussion comments** (general thread): `gh api repos/{owner}/{repo}/issues/{pr}/comments`
- **Review summaries** (the body submitted with each review): `gh api repos/{owner}/{repo}/pulls/{pr}/reviews`

Capture for each comment: author login, author `user.type`, `html_url` (permalink), `created_at`, and body. De-duplicate repeated feedback where multiple comments point to the same issue.

# 3. Identify human reviewers

Pattern tracking (steps 4–6) applies **only** to human teammates other than the PR author. Treat the following as non-human and exclude from pattern analysis (their feedback still appears in the action list):

- `user.type == "Bot"` on the GitHub author payload
- Login ends in `[bot]` (e.g. `github-actions[bot]`)
- Login matches, case-insensitive, any of: `copilot`, `coderabbit`, `sonarcloud`, `sonarqube`, `graphite`, `greptile`, `ellipsis`, `claude`

Also exclude the PR author's own comments from pattern tracking.

# 4. Load existing pattern data

Read from the vault **before** classifying so prior context is in scope:

- Index: `~/Developer/personal/Obsidian/Work/Team/PR-Feedback-Patterns/Index.md`
- Per-reviewer files for every human commenter on this PR: `~/Developer/personal/Obsidian/Work/Team/PR-Feedback-Patterns/reviewers/<github-handle>.md`

If a reviewer file does not exist, create it in step 6. If the directory does not exist, create it.

# 5. Classify each human comment

Automatically assign one or more tags from the taxonomy below to each human comment. Be conservative — if a comment is genuinely useful, do not force a negative tag; record a positive tag instead, or no tag at all. Every tag must be paired with a one-sentence rationale grounded in the comment text.

### Negative patterns
- `nitpick-no-rationale` — style/preference framed as a request with no reasoning
- `cya-hedge` — "just to be safe", "what if…" with no concrete failure mode
- `preference-as-requirement` — opinion framed as blocking
- `linter-restate` — duplicates what an automated tool already flagged
- `scope-creep` — asks for changes unrelated to the PR's stated purpose
- `late-blocker` — substantive blocking comment landed after prior approval or several iteration cycles
- `re-litigation` — re-opens a settled team decision
- `tone-curt` — short, abrupt phrasing that reads as dismissive
- `tone-dismissive` — sarcasm or condescension visible in the comment text

### Positive (counter-balancing) patterns
- `constructive-with-rationale` — clearly explains the why
- `caught-real-bug` — surfaced an actual defect
- `taught-something` — left the author with a new insight

# 6. Update the vault

For each human commenter on this PR, write or update `reviewers/<handle>.md` using this shape:

```markdown
---
github-handle: <handle>
display-name: <name if known, else handle>
last-updated: <YYYY-MM-DD>
total-comments-reviewed: <n>
tag-counts:
  nitpick-no-rationale: <n>
  cya-hedge: <n>
  preference-as-requirement: <n>
  linter-restate: <n>
  scope-creep: <n>
  late-blocker: <n>
  re-litigation: <n>
  tone-curt: <n>
  tone-dismissive: <n>
  constructive-with-rationale: <n>
  caught-real-bug: <n>
  taught-something: <n>
---

# <handle>

## Dominant patterns
- `<tag>` (<count>) — one-line summary of how it shows up for this reviewer

## Evidence

### <YYYY-MM-DD> — <owner>/<repo>#<pr> "<PR title>"
- **Comment:** <html_url>
- **Excerpt:** > <verbatim excerpt, ≤2 lines, trimmed>
- **Tags:** `<tag>`, `<tag>`
- **Rationale:** <one sentence on why these tags fit>
```

Rules for updates:
- Only include tag keys with a non-zero count in the frontmatter `tag-counts` block.
- Append new evidence entries chronologically; group all entries from the same PR under one `###` heading.
- Recompute `## Dominant patterns` from the updated counts (top 3 by count, ties broken by recency).
- Bump `last-updated` and `total-comments-reviewed`.

Then update `~/Developer/personal/Obsidian/Work/Team/PR-Feedback-Patterns/Index.md`:

- Refresh the reviewer's row in the `## Reviewers` table (add it if missing):
  `| [@handle](reviewers/handle.md) | <total> | tag (n), tag (n), tag (n) | <YYYY-MM-DD> |`
- Sort the table by `Last seen` descending.
- Bump the file's `last-updated` frontmatter.

# 7. Distill into action

- Group comments by severity, actionability, or theme.
- Separate concrete requested changes from open questions or preference-level feedback.

# Output

- Grouped feedback summary
- Action list ordered by priority
- Open questions that still need clarification
- **Reviewer pattern notes** — for each human reviewer on this PR, a one-line callout of their dominant existing patterns from the vault plus any new tags added this round. Keep tone observational, never judgemental. Example: `@alice — established: nitpick-no-rationale (4), constructive-with-rationale (6). This PR added: cya-hedge.`
