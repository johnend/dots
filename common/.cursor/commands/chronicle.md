# Chronicle – document to Obsidian

Create documentation for the user's Obsidian vault at **`~/Developer/personal/Obsidian`**.

1. **Infer topic and type** from the conversation or the user's request (code, workflow, learning note, tool guide, or concept).
2. **Suggest location** in the vault:
   - Work projects (`~/Developer/fanduel/*`): `Work/Domains/{Project-Name}/` for code/workflows, `Work/Knowledge/` for cross-project patterns.
   - Personal: `Personal/Learning/Notes/` for learning, `Personal/Knowledge/Tools/` for tools, `Personal/Projects/{Project-Name}/` for project-specific.
3. **Create the content** (here in chat or as a file the user can copy):
   - **Style:** Natural, human voice. Technical detail + readable. Explain _why_ as well as _how_. No corporate or AI-sounding phrasing ("Furthermore", "utilize", "leverage").
   - **Code docs:** Overview, code examples, usage, edge cases, and why decisions were made.
   - **Workflows:** Steps, concrete commands/configs, and a Mermaid diagram if it helps. Include troubleshooting.
   - **Learning notes:** What was learned, why it matters, practical examples, and links for further reading.
   - **Tool guides:** Setup, config examples, common tasks, troubleshooting.
4. **Tell the user** the suggested vault path and that they can create or paste the content there. If they use a different structure, use their path.

Goal: reference-quality technical content that is also enjoyable to read. No dumbing down; no dense walls of text.
