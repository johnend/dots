---
name: retro
description: >
  Review the current session for lessons (corrections, re-explanations, repeated failures, tool workarounds) and route each one to the right durable home: Applied Learning in ~/.ai/AGENTS.md, project memory, a skill, or a hook.
  TRIGGER when: user says "retro", "what did we learn", "capture the lessons", "record that", "remember this for next time"; when a correction-nudge hook fires and the correction is generalisable; at the end of a session with friction; and before session-wrap.
  DO NOT TRIGGER for: documenting the work itself (use session-wrap / chronicle-docs), or a one-off preference that only matters in this conversation.
---

# Retro

Turn session friction into durable fixes. Learning that lives only in chat is lost at the next session.

## 1. Find candidates

Scan the conversation for:

- I corrected you, rejected an approach, or re-explained something
- A hypothesis you stated was refuted
- The same tool/command failed more than once, or a workaround was needed (sandbox, zsh, CLI flags, MCP quirks)
- A scope miss: you did more or less than I asked
- Something you had to discover that a future session would have to rediscover

Ignore task facts that only matter today (ticket state, a specific bug's cause) and anything derivable from the repo or git history.

## 2. Route each lesson

| Lesson shape | Destination | Action |
|---|---|---|
| Global, one line, any repo ("`rg -r` means replace") | `## Applied Learning` in `~/Developer/personal/dots/common/.ai/AGENTS.md` | Write directly |
| Specific to this repo/service (URLs, env quirks, owners' channels) | Project auto-memory (Claude) or `~/.codex/memories` is automatic (Codex); otherwise a repo `AGENTS.md`/`CLAUDE.md` note | Write directly |
| A multi-step procedure or a change to how a workflow runs | The relevant skill in `~/.ai/skills/` | Propose a diff via `evolve-skill`; wait for approval |
| Must always/never happen regardless of judgement | A hook in `~/.ai/hooks/` | Propose; wait for approval |
| Contradicts or supersedes an existing instruction | Edit that instruction in place | Propose; wait for approval |

Write to the real dots path above, not the `~/.ai` or `~/.codex/AGENTS.md` symlinks (Claude's Edit tool refuses to write through symlinks).

## 3. Write rules for Applied Learning

- One bullet, under 15 words, imperative or fact form, no explanation
- Read the section first. Skip duplicates; reword an existing bullet rather than adding a near-duplicate
- If a bullet has become a rule elsewhere in AGENTS.md or a skill, delete the bullet
- Only edit the `## Applied Learning` section directly. Anything else in AGENTS.md is a proposal

## 4. Report

Finish with a short list, one line each:

```
Written:  AGENTS.md  - <bullet>
Written:  memory     - <fact>
Proposed: skill triage - <one-line change>  (awaiting approval)
Skipped:  <candidate> - <why: one-off / duplicate / derivable>
```

If nothing qualifies, say "No durable lessons this session" and stop.
