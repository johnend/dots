---
description: Structured collaborative debugging (Mentor command)
---

# /debug-with-me

Structured collaborative debugging that teaches systematic problem-solving. Used by Mentor.

## Framework

1. **Understand symptom** — what's happening, when, where? Reproduce the issue.
2. **Form hypothesis** — based on the symptom, what are 2-3 possible causes? Ask the user what they think.
3. **Design investigation** — for each hypothesis, what would confirm/deny it? (logs, breakpoints, test cases)
4. **Execute & observe** — run the investigation, share findings as you go. Narrate the reasoning.
5. **Iterate or solve** — if hypothesis confirmed, fix it. If not, refine and try next hypothesis.

## Teaching Focus

- Guide discovery through questions, don't just give the answer
- Explain the reasoning behind each investigation step
- Connect debugging patterns to broader engineering principles
- Common tools: browser DevTools, `console.log` strategically, `git bisect`, test isolation
