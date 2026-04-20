---
name: get-pr-comments
description: Fetch review and discussion comments for the current pull request and turn them into a concise action list.
---

# Get PR Comments

Use this skill when the user wants a concise summary of feedback on the active pull request for the current branch.

# 1. Resolve the active PR

- Use the current branch to identify the open pull request.
- If there is no active PR for the branch, say so clearly and stop.

# 2. Fetch feedback

Collect all three comment types using `gh`:

- **Inline review comments** (on specific lines of code): `gh api repos/{owner}/{repo}/pulls/{pr}/comments`
- **PR discussion comments** (general thread): `gh api repos/{owner}/{repo}/issues/{pr}/comments`
- **Review summaries** (the body submitted with each review): `gh api repos/{owner}/{repo}/pulls/{pr}/reviews`

De-duplicate repeated feedback where multiple comments point to the same issue.

# 3. Distill into action

- Group comments by severity, actionability, or theme.
- Separate concrete requested changes from open questions or preference-level feedback.

# Output

- Grouped feedback summary
- Action list ordered by priority
- Open questions that still need clarification
