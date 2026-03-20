# Code Style Guidelines

## Core Philosophy

**Readability over cleverness.** Explain WHY, not WHAT.

## When to Comment

Comment when a competent developer would struggle to understand WHY code exists or is written a certain way:

- **Workarounds/hacks** — explain the underlying issue and when it can be removed
- **Counter-intuitive logic** — explain why it looks wrong but isn't
- **Performance tradeoffs** — explain why an inefficient-looking approach was chosen
- **Security decisions** — explain why sanitization/checks happen here specifically
- **External constraints** — browser bugs, API quirks, library workarounds (link to issue)
- **TODOs with timeline** — `TODO(2026-Q2): Remove once clients upgrade to v3`
- **Magic numbers** — explain what the value represents and where it comes from
- **Algorithm choices** — explain why this algorithm over alternatives

## When NOT to Comment

- Self-documenting code, standard patterns, type definitions, simple validation, obvious operations
- Standard business logic (domain knowledge, not code knowledge)
- For gray areas: comment obscure library behavior and complex multi-conditional business rules; skip simple rules and well-known libraries

## Style

### Shell Scripts
- `#!/usr/bin/env bash` + `set -euo pipefail`
- 2-space indent, UPPER_SNAKE_CASE constants, lowercase_snake_case variables/functions

### TypeScript/JavaScript
- Follow project ESLint/Prettier config
- PascalCase: classes, interfaces, components. camelCase: variables, functions. UPPER_SNAKE_CASE: constants
- Prefer explicit over implicit, verbose names over abbreviations
- Keep functions small and focused (single responsibility)
