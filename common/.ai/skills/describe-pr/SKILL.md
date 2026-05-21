---
name: describe-pr
description: >
  Create a pull request OR update the description of an existing PR for the current branch. Handles repo PR templates, JIRA ticket extraction (including title prefix), a prose summary followed by implementation bullets with rationale, testing evidence, and screenshot prompts for UI/frontend changes.
  TRIGGER when: user asks to create a PR, open a PR, "/describe-pr", "/create-pr", update the PR description, refresh PR body, or after pushing a branch that already has a PR.
effort: medium
model: claude-haiku-4-5
---

# Describe PR (Create or Update)

Create a PR for the current branch — or update an existing PR's description — using a consistent shape: short prose summary, implementation bullets, rationale, and testing evidence. Use **only the `gh` CLI** for all GitHub operations.

## Output discipline

- Use variable-capture for **discovery** commands so success is silent and only failures surface (see `bash-output-suppression` rule in `~/.claude/rules/`). Applies to `git log`, `git diff`, `gh pr view`, `gh pr list`, `gh repo view`, etc.
- Do **not** suppress output for state-changing remote operations: `gh pr create`, `gh pr edit`, `git push`. Their stderr is load-bearing (auth/SAML errors).

## 1. Pre-flight checks

- Confirm current branch is NOT `main` or `master`. If it is, stop and tell the user.
- Identify the base branch: `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`.
- Check for uncommitted changes with `git status --short`. If any, show them and ask the user what to do before proceeding.

## 2. Detect existing PR

Run `gh pr view --json number,url,body,title,headRefName,baseRefName,labels` (variable-capture; non-zero exit means no PR exists).

- **PR exists** → **Update mode**: preserve the existing title unless the user asks otherwise; rewrite the body.
- **No PR** → **Create mode**: draft a new title and body.

In update mode, also fetch the current body so you can preserve any sections the user filled in manually that aren't derivable from the branch (e.g. "Tested in staging" notes, screenshots they pasted in the web UI).

## 3. Extract JIRA ticket

From the current branch name, match `[A-Z]+-[0-9]+` (most commonly `RACNS-1234`). If found, capture it for use in the body. If not found, proceed without — do not invent one.

## 4. Find a PR template

Check these paths in order and use the **first** one found:

1. `.github/PULL_REQUEST_TEMPLATE.md`
2. `.github/pull_request_template.md`
3. `docs/pull_request_template.md`
4. `PULL_REQUEST_TEMPLATE.md`
5. `.github/PULL_REQUEST_TEMPLATE/` directory — if multiple templates exist, list them and ask the user which to use.

If a template is found, its **structure and hierarchy are authoritative**. Fit the summary/bullets/rationale/evidence into the template's sections; do not invent new top-level sections that aren't in the template.

### Handling template checkboxes

- Check off (`- [x]`) only items you can **verify from the branch** (e.g. test files added in diff, migration files present, docs updated).
- Leave unchecked (`- [ ]`) anything ambiguous or requiring manual action.
- For unchecked items that need attention, add a brief inline note: `- [ ] Tested in staging — *needs manual verification*`.
- Never check off something just because the description sounds plausible.

## 5. Analyse the changes

- `git log <base>..HEAD --oneline` — all commits on the branch (variable-capture).
- `git diff <base>...HEAD --stat` — file/line summary (variable-capture).
- `git diff <base>...HEAD` — full diff (variable-capture; needed to write a meaningful description).

Review **all** commits and the full diff. Identify intent and motivation, not just file-by-file changes.

## 6. Detect UI / frontend changes

Inspect changed file paths from `git diff --name-only <base>...HEAD`. Treat the PR as containing UI work if any of these match:

- Extensions: `.tsx`, `.jsx`, `.vue`, `.svelte`, `.astro`, `.html?`, `.css`, `.scss`, `.sass`, `.less`, `.styl`, `.module.css`/`.module.scss`, `*.stories.*`
- Paths containing `/components/`, `/ui/`, `/pages/`, `/app/`, `/views/`, `/styles/`, `/.storybook/`
- Native mobile UI: `.swift`, `.kt` under `/ui/` paths, Android `res/layout/*.xml`

If UI changes are detected, **prompt the user** before drafting:

> "This PR touches UI. Do you want to include screenshots? Reply with image URLs (already uploaded somewhere), local file paths, or 'no'."

Handling the reply:

- **URLs provided**: embed directly as `![label](url)` in the description's Screenshots section.
- **Local paths provided**: include a Screenshots section with a clear placeholder for the user to drag-drop into the GitHub web UI after the description is applied (the `gh` CLI does not upload images — only the web UI does).
- **"no" / skip**: omit the Screenshots section entirely.

## 7. Draft the description

### Title

Under 70 chars total, imperative mood (e.g. "Add retry logic to webhook handler").

**Prepend the JIRA ticket** if one was extracted in step 3, matching the user's commit-prefix convention:

- Format: `RACNS-1234 Add retry logic to webhook handler` (space-separated, no colon, no brackets).
- The 70-char budget **includes** the ticket prefix.
- In **update mode**, check the existing title first — if it already starts with the same ticket (e.g. `RACNS-1234 `), keep the title; do not double up. If the existing title is missing the prefix and a ticket was extracted from the branch, ask the user whether to fix the title or leave it alone.

### Body shape (no template)

```
<one short prose paragraph — 1-3 sentences — describing the functional/user-visible change. Code detail only if essential for understanding. The diff handles the rest.>

## Changes
- bullet covering implementation point
- bullet covering implementation point
- bullet covering implementation point

## Why
- bullet on rationale / motivation / constraint
- bullet on rationale (omit section if no non-obvious rationale exists)

## Testing
- what was tested and how (specific commands run, scenarios exercised)
- evidence: passing test names, screenshots referenced below, manual verification steps
- known gaps or things left for reviewer to validate

## Screenshots
<only if UI changes — see step 6>

JIRA: RACNS-1234 (omit line if no ticket)
```

### Body shape (template exists)

Fit the same content into the template's sections. Leave inapplicable optional sections as `N/A` rather than deleting them. Preserve template formatting (headings, checkbox lists, HTML comments).

### Style rules

- Bullets over paragraphs everywhere except the opening summary.
- Explain the WHY, not a line-by-line WHAT.
- No auto-generated changelogs or file lists.
- Do **not** fabricate "approaches tried", testing that didn't happen, or evidence that doesn't exist. If you didn't verify it, don't claim it.
- Include the JIRA ticket if extracted in step 3.

## 8. Present for approval

Show the user:

- Mode (Create or Update)
- Proposed title (current title in update mode)
- Proposed body
- Whether the branch needs pushing (Create mode) or is already up to date (Update mode)
- Any screenshot prompts still outstanding

**Wait for explicit approval before applying.**

## 9. Apply

### Create mode

- Push the branch if needed: `git push -u origin <branch>` (let output flow through).
- Create the PR: `gh pr create --title "..." --body "..."` (let output flow through).
- Return the PR URL.

### Update mode

- Edit the body: `gh pr edit <number> --body "..."` (let output flow through).
- Return the PR URL.

Do **not** auto-merge, auto-assign reviewers, add labels, or push without confirmation unless the user explicitly asks.
