---
name: create-pr
description: Create a pull request from the current branch with a concise summary, respecting repo PR templates. Triggered by "/create-pr" or "create a PR".
---

# Create Pull Request

Create a PR for the current branch with a concise, high-signal description.

## 1. Pre-flight checks

- Confirm the current branch is NOT `main` or `master`. If it is, stop and tell the user.
- Identify the base branch (default branch of the repo via `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`).
- Check for uncommitted changes with `git status`. If there are any, show them and ask the user what to do before proceeding.

## 2. Check for a PR template

Look for a PR template in the repo. Check these paths in order and use the **first** one found:

1. `.github/PULL_REQUEST_TEMPLATE.md`
2. `.github/pull_request_template.md`
3. `docs/pull_request_template.md`
4. `PULL_REQUEST_TEMPLATE.md`
5. `.github/PULL_REQUEST_TEMPLATE/` directory — if multiple templates exist, list them and ask the user which to use.

If a template is found, use its structure as the PR body skeleton and fill in the sections based on the changes.

### Handling template checkboxes

Templates often contain checklists (e.g. `- [ ] Unit tests added`). For each checkbox:

- **Check it off** (`- [x]`) only if you can **verify it from the branch** — e.g. run `git diff <base>...HEAD` to confirm test files were added/modified, check for migration files, confirm docs were updated, etc.
- **Leave it unchecked** (`- [ ]`) if verification is ambiguous, requires manual action (e.g. "tested in staging"), or depends on information you don't have access to.
- **Add a brief inline note** next to ambiguous items so the user knows what still needs attention, e.g. `- [ ] Tested in staging — *needs manual verification*`

## 3. Analyse the changes

- Run `git log <base>..HEAD --oneline` to see all commits on the branch.
- Run `git diff <base>...HEAD` to see the full diff against the base branch.
- Review ALL commits, not just the latest.

## 4. Draft the PR

**Title:** Under 70 characters. Use the imperative mood (e.g. "Add retry logic to webhook handler").

**Body — if no template:**

```
## Summary
- 3–5 bullet points covering what changed and why
- Focus on intent and impact, not file-by-file narration

## Test plan
- How to verify the changes work
```

**Body — if template exists:** Fill in the template sections concisely. Leave optional/inapplicable sections with "N/A" rather than deleting them.

**Style rules:**
- No verbose prose — bullets over paragraphs.
- No file lists or auto-generated changelogs.
- Explain the WHY, not a line-by-line WHAT.
- If the branch name contains a ticket number (e.g. `ABC-123-feature`), include it in the body.

## 5. Present for approval

Show the user:
- The proposed title
- The proposed body
- Whether the branch needs pushing

**Wait for explicit approval before creating the PR.**

## 6. Create the PR

- Push the branch if needed: `git push -u origin <branch>`
- Create the PR: `gh pr create --title "..." --body "..."`
- Return the PR URL to the user.

Do NOT auto-merge, auto-assign reviewers, or add labels unless the user asks.
