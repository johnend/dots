# Documentation and reference material

Read when editing Markdown or diagrams, checking document links, or extracting policy/XML evidence.

- Validate Markdown fragments against complete heading slugs, including dates.
- Confluence Cloud deep links: a heading's anchor is its text with spaces as hyphens (`#Key-findings`), generated at render so absent from storage HTML; anchor macros link by their name (`#E07`). Check anchor macros exist in the `--format html` body before linking.
- Check existing viewer configuration before changing diagrams or recommending replacement tools.
- Insert new sections before existing headings without duplicating those headings.
- Verify raw policy text when extracted pages omit relevant clauses.
- Extract relevant XML fields instead of printing complete metadata documents.
- Before writing up findings about a service or component in a vault work item, search other work items for existing analysis of it (`rg -l '<name>' Work/`) and reconcile with it; earlier spikes may hold facts that correct new conclusions.
- Write work notes and plans as current fact: re-verify, then rewrite superseded content in place. No dated "Update"/"Correction" blocks, ledgers of past hypotheses or "superseded" sections; TL;DR and every section must reflect today.
