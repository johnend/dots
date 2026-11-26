# Maintaining agent guidance

Read when recording lessons or reorganising agent instructions and context.

- Reorganise guidance directly, without disposition lists or migration records.
- Keep global preferences in the shared `AGENTS.md`; put conditional guidance in
  the relevant module or project, with a clear reading condition.
- Preserve the rule's applicability and known rationale without inventing missing
  context or duplicating its text in several places.
- Run retro automatically at substantive task completion; keep reviews with no new lessons silent.
- Both tools may maintain scoped guidance and its reading index without separate approval.
- The dotfiles are public: write shared lessons in general terms, with no company
  names, project keys, ticket numbers, field IDs, internal hostnames or team names.
  Company-specific remainders go in `~/.ai-work/AGENTS.md` (private, untracked).
- Give each MCP server or CLI its own module (`context/<tool>.md`) for lessons that
  only apply when calling it; don't mix tools in one module or add empty ones.
- Reuse an existing module before creating a new file or topic/stack directory.
- Give new modules a clear applicability statement and a specific index entry.
- Update the relevant reading index in the same change as a new module.
- Create directories for coherent topics or stacks, not individual incidents or empty scaffolding.
- Keep conditional modules outside auto-loaded rules directories and avoid eager imports.
- Share lessons through repository files; sync machines through the approved Git workflow.
