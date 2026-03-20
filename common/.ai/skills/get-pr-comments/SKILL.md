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

- Collect review comments and discussion comments.
- De-duplicate repeated feedback where multiple comments point to the same issue.

# 3. Distill into action

- Group comments by severity, actionability, or theme.
- Separate concrete requested changes from open questions or preference-level feedback.

# Output

- Grouped feedback summary
- Action list ordered by priority
- Open questions that still need clarification
