# Jira and Confluence (twg)

Read before using `twg` for Jira or Confluence. Formatting and permission rules stay in the global `AGENTS.md`.

- Issue types vary by Jira project. List the project's types before choosing one; some teams use `Task` plus a label instead of a dedicated type.
- Custom fields such as Team are set by field ID (`customfield_NNNNN`), not display name. Look the ID up before writing.
- `twg jira workitem link workitem --id A --target-id B --link-type-id Blocks` means A blocks B.
- `--description-format markdown` converts headings, lists and links to ADF cleanly.
- To cross-link new tickets, create them first, then update their descriptions with the real keys.
- Confluence Cloud deep links: a heading's anchor is its text with spaces as hyphens (`#Key-findings`), generated at render so absent from storage HTML; anchor macros link by their name (`#E07`). Check anchor macros exist in the `--format html` body before linking.
