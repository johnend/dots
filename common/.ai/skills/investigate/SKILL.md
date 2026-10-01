---
name: investigate
description: >
  Hypothesis-driven root-cause investigation for bugs with unclear causes: pin scope, generate competing hypotheses, try to falsify each with telemetry and code, keep a ledger, and record findings in the Obsidian work item as you go. Docs-only until the diagnosis is confirmed.
  TRIGGER when: user asks to investigate, root-cause, or debug a bug whose cause isn't obvious ("why is X happening", "wrong offer shown", "events missing", "works on one device but not another"), especially across Datadog, Amplitude and code.
  DO NOT TRIGGER for: support-rota routing (use triage), obvious single-cause bugs with a known fix, or code review.
---

# Investigate

Measurement over theory. The failure mode to avoid: committing to a plausible story and defending it.

## 1. Pin the facts (ask before theorising)

List what's established and confirm with me:

- Env and data project (Amplitude dev vs prod, Datadog env)
- Exactly who is affected: user/account IDs, one vs many, platforms, builds
- Exact surface (which page, component, bar, flow step)
- What I've already ruled out or changed myself (manual flag toggles, config edits, deploys)

Don't continue on an unconfirmed scope.

## 2. Hypotheses

Write 4-6 competing hypotheses, including at least one boring one (config, flag state, data, timing). For each, state what evidence would **refute** it.

## 3. Falsify in parallel

Launch one subagent per hypothesis in a single message (`Explore` in Claude; a subagent in Codex). Each gets the pinned facts, its hypothesis, and these instructions:

- Try to **refute** the hypothesis using Datadog logs/spans, Amplitude events, and code/config. Scope every query to the pinned env/project
- Check whether the data we think is missing is actually logged before concluding it isn't
- Cite exact queries, log lines, event names and `file:line`
- Return: verdict (refuted / supported / inconclusive), evidence for, evidence against, the one measurement that would settle it. Under 250 words, no preamble

## 4. Skeptic pass

On the leading survivor, run one more subagent told to break it: alternative explanations, already-logged data we overlooked, manual changes, environment differences.

## 5. Ledger

Maintain and show this table after every round:

| Hypothesis | Evidence for | Evidence against | Status |
|---|---|---|---|

Status is `open`, `refuted`, or `confirmed`. **Confirmed** requires direct evidence (a log line, event, or reproducible check), not consistency with a story. Never call something the root cause while it's `open`.

## 6. Record as you go

Write the ledger, the pinned facts and the evidence links into the Obsidian work-item note via `chronicle-docs` (`Work/Domains/<Domain>/Work-Items/<Work-Item>/`). Update it as the status changes, so a partial investigation still leaves a hand-off.

## 7. Boundaries

- **No code changes** until I confirm the diagnosis. "Fix it" during an investigation means update the notes
- If two rounds end with everything inconclusive, stop and say what measurement or access is missing
- End with `retro` if any hypothesis was refuted because of a scoping or assumption error
