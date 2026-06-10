---
description: MCP result filtering — extract specific fields at the boundary, use server-side filters and pagination limits, prefer search-then-fetch over list-everything to keep dense MCP responses out of context
alwaysApply: true
---

## MCP Result Filtering

### Core Pattern: Extract at the Boundary

- MCP tools (Atlassian, Datadog, Amplitude, Buildkite) routinely return dense JSON. Identify the specific fields you need before the call, and summarize the response in your own words before reasoning further — don't let raw payloads sit in context as the substrate for your next decision:

  ```
  Before: dump full Jira issue response → reason about it
  After:  fetch with fields=summary,status,assignee → summarize → reason
  ```

- Use server-side filters wherever the tool supports them. Filtering 10 results server-side beats fetching 100 and ignoring 90:
  - **Atlassian** — JQL/CQL filters; `fields=` parameter on issue lookups
  - **Datadog** — scope queries by service, env, and time window; never query open-ended
  - **Amplitude** — use `query_chart` (single chart) over `query_charts` (multi); only multi when explicitly comparing
  - **Buildkite** — pass branch/state filters to `list_builds`; use line ranges for `read_logs`

### Pagination and Limits

- Always pass a `limit` when the tool supports one. Defaults are usually too generous for the question you're actually asking
- For list-style endpoints, start with the smallest useful limit and expand only if needed — fetching 5 then 50 costs less than fetching 200 and discarding 195
- When you only need IDs or counts, look for tools or modes that return just that

### Search-Then-Fetch Pattern

- Use search/list tools to identify the target IDs first, then fetch full detail only for the specific IDs you need:

  ```
  search_X(query=...) → pick relevant IDs → get_X(id) for those only
  ```

- Applies broadly: Jira issues, Datadog logs/spans, Buildkite builds, Amplitude charts, Confluence pages

### Skill Discovery (Datadog and similar)

- When an MCP server ships skill guides, load them once per domain per session — not before every tool call. Datadog's `load_datadog_skill` and `list_datadog_skills` are session-scoped; re-loading the same skill wastes tokens
- Load related visualization or format skills alongside the data-domain skill in a single parallel dispatch

### Anti-Patterns

- **List without limit** — `list_X()` with no cap returns whatever the server defaults to; assume that's too much
- **Fetch-then-discard** — pulling a full payload and only using one field; use server-side `fields=` instead
- **Repeated lookups** — re-fetching the same issue, build, or dashboard within a session; the data didn't change in 30 seconds
- **Open-ended queries** — Datadog/Amplitude queries without a time window or scope pull massive result sets
- **Re-loading session skills** — `load_datadog_skill` on the same skill twice in one conversation
- **Calling `get_X` when `search_X` already returned the needed fields** — search responses often include enough detail

### Review Checklist for New MCP Calls

Before invoking an MCP tool, verify:

- ✓ Have I scoped this with server-side filters (JQL, time window, branch, status)?
- ✓ Have I passed a `limit` or `fields=` parameter where supported?
- ✓ Is this a search-then-fetch, or am I dumping a whole list?
- ✓ Did I already fetch this entity earlier in the session?
- ✓ If loading a skill: have I already loaded it this session?
