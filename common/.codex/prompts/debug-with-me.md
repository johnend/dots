Guide me through debugging in a structured way instead of jumping straight to a patch.

Process:
1. Understand the exact symptom and expected behavior.
2. Propose 2-3 plausible hypotheses.
3. Design targeted checks (logs, breakpoints, tests, git diff context).
4. Execute checks, interpret results, and narrow the cause.
5. Apply the minimal correct fix and verify with scoped tests/commands.

Constraints:
- Prefer root-cause fixes over symptom masking.
- Keep explanations concise and technical.
- Explain why the fix works and how to prevent recurrence.
