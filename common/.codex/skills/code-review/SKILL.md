---
name: code-review
description: Review code changes for bugs, regressions, risk, and missing tests with severity-first output and concrete file references.
---

# Code Review Workflow

1. Review changed code first:
- Prefer `git diff` / uncommitted changes as review scope.

2. Output order:
- Critical
- Warnings
- Suggestions

3. Focus areas:
- Correctness and behavioral regressions
- Security and unsafe data handling
- Test gaps
- Maintainability and coupling risks

4. Output requirements:
- Include file paths and lines when possible.
- Provide concrete remediation guidance.
- If no findings, state that explicitly and list residual risk.
