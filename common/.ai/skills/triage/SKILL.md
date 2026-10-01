---
name: triage
description: >
  Support-rota triage: take a reported failure (Slack message, staging/QA bug, error screenshot), trace it to the failing component, identify the owning team from evidence, and draft a short Slack hand-off.
  TRIGGER when: user is on support/rota duty, pastes a Slack report or error and asks what's going on, "who owns this", "who should I contact", "triage this", or wants a hand-off reply drafted.
  DO NOT TRIGGER for: deep multi-hypothesis root-cause work on our own code (use investigate), or fixing the issue.
---

# Triage

Goal: route the issue to the right owner quickly with evidence. **Routing, not fixing.** Do not propose code changes or workarounds unless I ask.

## 1. Pin the scope (before any query)

Extract or ask for:

- **Env:** dev / staging / QA / prod. Every Datadog query and link must carry this env filter
- **Identity:** affected user/account/device. Is it one user or everyone? If unclear, ask, since a single-user failure changes the whole search
- **Time:** when it started. Check at least 24h back before stating a start time
- **Surface:** product, platform, app build

If I only asked "who owns this", skip to step 3 once the failing component is clear from the report.

## 2. Trace to the rejecting component

- Find the failing request in Datadog logs/spans (scoped to env and time), then follow it until you reach the component that returned the error (gateway, auth, downstream service, CDN/edge)
- Quote the decisive evidence: status, error message, service name, a log or trace link
- Label the finding **Confirmed** (evidence shows the component rejecting it) or **Hypothesis** (inferred)
- If the evidence stops at an edge layer (CloudFront Function, WAF, Kong) that doesn't say why, say so and hand over. Don't invent a criterion

## 3. Identify the owner (evidence only)

Check in order, and cite the file and line or entry used:

1. `CODEOWNERS` in the owning repo
2. API owners files / service catalog (`service.datadog.yaml`, Datadog service entities)
3. The team's intake channel from the catalog or Confluence

Rules:

- Name a **team and intake channel**, never an individual as owner
- Ticket authors and Confluence page owners are not operational owners
- git-blame names may be listed only as "recent authors", and only if useful
- If no evidence exists, say "Owner unverified" and list the best-guess team with why

## 4. Output

```
**Verdict:** <Confirmed|Hypothesis> - <one line: what fails, where>
**Owner:** <team> - <intake channel> (source: <file:line or catalog entry>)
**Evidence:** <1-3 env-scoped links>
**Open questions:** <only if any>

**Slack draft:**
> <under 80 words: what's failing, which component, who owns it, the link(s). Conclusion first.>
```

Keep the draft short on the first attempt; don't wait for me to ask.

## 5. Close

If routing went wrong or needed a correction this session, run `retro` to record the lesson.
