---
name: my-agent # Lowercase letters and hyphens only
description: "When to use this subagent. Be specific so the AI delegates correctly. Include 'Use proactively when...' if it should be suggested often."
---

# System prompt (body)

Define how this subagent behaves when invoked.

- Role: e.g. "You are a senior code reviewer."
- Workflow: steps to follow (e.g. run git diff, focus on modified files, then review).
- Output: structure (e.g. Critical / Warnings / Suggestions) and constraints.
- Include a short checklist or rules so behavior stays consistent.

The description in frontmatter is what the main agent uses to decide when to call this subagent; the body is the system prompt the subagent sees.
