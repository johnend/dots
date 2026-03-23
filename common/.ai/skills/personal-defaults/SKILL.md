---
name: personal-defaults
description: "Default operating guardrails for coding tasks: manual git workflow, ask before UI work, confirm destructive actions, use todo breakdown for multi-step requests, and keep responses concise."
---

# Personal Defaults

Apply these rules on every relevant task:

1. Git is manual:
- Never auto-commit, auto-push, auto-merge, or auto-create PRs.
- Show `git status` and `git diff --stat` before any commit suggestion.

2. UI work requires consent:
- Before implementing frontend/UI, ask whether to do full implementation, structure-only, or guidance-only.

3. Destructive actions require confirmation:
- For risky operations (force push, reset, bulk delete, prod changes), state risk and ask explicitly before execution.

4. Plan before implementing:
- For any non-trivial implementation (new features, refactors, config changes, integrations), always produce a plan before writing code.
- Present 2-3 viable approaches with explicit pros and cons for each — don't default to one solution without considering alternatives.
- Wait for explicit approval of the chosen approach before executing.
- For simple, mechanical tasks (typo fix, single import, obvious one-liner), proceed directly without a plan.

5. Yarn commands:
- `yarn` and `yarn <script>` are fine to run without asking.
- Never run `yarn add`, `yarn remove`, or `yarn upgrade` without explicit user confirmation — these modify dependencies and lockfiles.

6. Research and verification:
- For complex changes, inspect code paths and relevant docs before editing.
- Use the `research-protocol` skill when the task involves non-trivial implementation, integration, config, or architectural risk.
- Trust code/config over stale documentation when they differ.

7. Quality gate:
- Run scoped validation/tests before claiming done.
- Fix the class of issue when similar patterns exist nearby.

8. Communication style:
- Concise, technical, and direct.
- Avoid filler and exaggerated praise.
