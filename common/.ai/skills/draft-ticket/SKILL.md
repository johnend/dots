---
name: draft-ticket
description: >
  Draft a tech/Jira ticket from conversation context or user-provided details, get explicit approval, then create it — as a real Jira issue (FanDuel repos) or an Obsidian note (personal projects).
  TRIGGER when: user asks to write/create/draft a ticket, "file a bug", "make a Jira ticket", "write this up as a ticket/story/task".
  DO NOT TRIGGER for: PR descriptions (use describe-pr) or general documentation/notes (use chronicle-docs).
---

# Draft Ticket

Draft a ticket, show it for approval, then create it. Never create anything before explicit approval.

---

## 1. Determine destination

- Current working directory under `~/Developer/fanduel/` → **Jira path**.
- Otherwise → **Obsidian path**.

**Jira path only** — verify the `fd-atlassian` MCP is reachable before going further. There is no `authenticate` tool for this server, so check by making a lightweight call (`atlassianUserInfo`). If it fails, tell the user the Atlassian MCP isn't available/authenticated and ask whether to:
1. Fix it and retry, or
2. Fall back to drafting an Obsidian note instead.

---

## 2. Resolve target project + ticket type

**Jira path:**

- Do **not** infer the Jira project key from the current GitHub repo — it is frequently wrong.
- Default-suggest `RACNS` ("most tickets for work go here") and ask the user to confirm or supply a different project key.
- Once confirmed, call `getVisibleJiraProjects` (scoped to the key) then `getJiraProjectIssueTypesMetadata` for that project to fetch the real issue types available on it. Present those as the type choices — never a hardcoded list.
- After the type is chosen, call `getJiraIssueTypeMetaWithFields` (`requiredFieldsOnly: true`) for that project + type to discover **mandatory custom fields** before drafting. FanDuel projects often require select fields that aren't obvious. Gather any values you can't infer as part of the draft, and use `allowedValues` for the option id.
  - Known: RACNS **Bug** requires **"Stage found in"** (`customfield_15822`) — options Production (`17983`) / Pre-Production (`17984`). Infer from where the bug was found (e.g. devstack/int → Pre-Production, live → Production) and state the inference; don't ask if it's obvious from context.

**Obsidian path:**

- Ask for the project name (used to build the vault path).
- Offer ticket type: Feature / Bug / Chore / Research.
- Resolve the vault root using the same order as `chronicle-docs`: try `/home/johne/Documents/Obsidian` first, then `~/Developer/personal/Obsidian`; use whichever exists.
- File target: `Personal/Projects/<project>/Tickets/<Short-Title>.md`.

---

## 3. Gather ticket content

- If the current conversation already contains relevant investigation or findings, use that context automatically to build the title/summary/description — don't ask the user to confirm this first.
- Otherwise, ask for: summary, description, actions, acceptance criteria.
- If UI/frontend files or work are implicated, ask for Figma links to embed.
- If screenshots are relevant, tell the user they must upload these to Jira themselves (no tool here can upload images) — note this as a follow-up rather than embedding anything.

---

## 4. Draft content rules

- **Keep it short and conversational by default.** Aim for a tight ticket a colleague can skim — plain, informal language ("what's happening", "done when", "watch out for"), not formal spec prose. Cut anything that doesn't earn its place; don't restate the same point across sections.
- As brief as possible without losing necessary context.
- Never prescribe a technical solution — describe the problem/requirement, leave implementation to the engineer.
- Minimal-to-no code snippets or implementation options.
- Optional **Starting points** section listing key files/functions as investigation leads — visually de-emphasized, never the focus of the ticket:
  - Jira: a blockquote/panel-style block labeled "Starting points" (Jira has no expand/collapsible macro).
  - Obsidian: a `> Starting points` blockquote, or a `>[!note]-` callout if an existing note in the vault already uses Obsidian callouts (check one existing note for convention rather than assuming).
- Always include, explicitly labeled:
  - **Assumptions** — anything inferred rather than confirmed by the user.
  - **Potential issues** — risks, edge cases, unknowns.
  - **Testing** — what should be verified, only when relevant (omit rather than force it).
- Precision bar: the description + acceptance criteria should be unambiguous enough that an engineer (or AI) given only the ticket could execute with ≥95% confidence.

---

## 5. Jira formatting

- Use the markdown supported by `createJiraIssue`/`editJiraIssue`'s `contentFormat: markdown` (headings, lists, code fences, blockquotes for the "Starting points" block).
- If unsure whether a specific formatting construct will render as intended, note that as a risk in the draft rather than guessing or over-engineering detection.

---

## 6. Present draft for approval

- Show the full drafted ticket — title, type, project/vault target, body — before creating anything.
- Wait for explicit approval. Treat hedged or ambiguous replies ("maybe later", "let me think") as not-yet-approved; do not proceed without clear intent.

---

## 7. Create the artifact

**Jira:** call `createJiraIssue` with the confirmed project key, issue type, title, markdown description (`contentFormat: markdown`), and any required custom fields (pass options via `additional_fields`, e.g. `{"customfield_15822": {"id": "17984"}}`). Report back the issue key and URL.

- If the create still fails on a missing required field, the error's `problems`/`allowedValues` name the field and valid options. Set it from context (or ask only if it can't be inferred) and retry once — don't re-surface the whole draft for approval over a mechanical field.

**Obsidian:** write the file directly at `Personal/Projects/<project>/Tickets/<Short-Title>.md` — self-contained, no handoff to `chronicle-docs` (ticket frontmatter is ticket-specific, not generic doc frontmatter). Include frontmatter:

```yaml
date: <ISO 8601>
type: <Feature|Bug|Chore|Research>
status: open
tags: [<project>, ticket, <type>]
```

Apply `chronicle-docs`'s wikilink hygiene (no bare `README.md`, no speculative links to notes that don't exist) only if the ticket body references other vault notes.

---

## 8. Output

- What was created — issue key + link, or file path.
- Any assumptions or risks called out in the draft.
- Any outstanding follow-ups (e.g. "upload screenshots to Jira yourself").
