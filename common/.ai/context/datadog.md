# Datadog

Read before querying Datadog through the MCP server or the UI.

- RUM returning zero events is not proof of no data: data access restrictions hide events silently, and the MCP `aggregate_rum_events` tool also appends an `@_dd.application.rum_enabled` filter. Check `datadog.estimated_usage.rum.ingested_sessions` / `indexed_sessions` by `application.id` and `env` first; usage metrics show ingestion even when the events are hidden from you.
