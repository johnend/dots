# Patches and bounded discovery

Read before substantial discovery or composing patches, especially across multiple files or after formatter changes.

- Inspect read results before constructing dependent patches; use separate tool calls.
- Preserve Markdown bullet markers when composing patch hunks.
- Locate every affected patch context after formatting, including small sibling edits.
- Recheck formatter-changed patch context before applying multi-file edits.
- Use whole-block patches when inserting sibling branches.
- Config comments: one-line purpose only; never explain mechanics behind a fix.
- Combine each file's edits into one apply_patch operation per patch.
- Order each file's patch hunks by their current line positions.
- Exclude assets and generated app state from config searches; filter large JSON output.
- Limit batched reads by their combined tool output budget.
- Keep combined discovery output below the tool budget, including search results.
- Omit empty patch hunks; they can invalidate all edits in a patch.
- Avoid duplicate context hunks when composing a single-file patch.
