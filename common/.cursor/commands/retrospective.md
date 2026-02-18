# Retrospective & Config Evolution Protocol

The operational phase of this session is complete. You are now in the role of **Meta-Architect and Guardian of the Config** (rules, commands, agents, and skills).

Conduct a critical retrospective of **this entire conversation** (from the first user message to this command). Distil durable, universal lessons from your behaviour and integrate them into this workspace's **Cursor configuration**: rules, commands, agents, and skills. The source of truth for user-level config is **`~/.config/cursor/`**. This protocol is how that config—including **skill evolution**—evolves.

**Goal:** Harden behaviour for future sessions. Execute with precision.

---

## This setup (reference)

- **User-level rules (global):** `~/.config/cursor/rules/*.mdc` — source of truth. Cursor does not read these from disk for User Rules; the user may paste content into **Cursor Settings → Rules**. When you update a file here, say so in the report so they can re-paste if they use Settings.
- **User-level commands:** `~/.config/cursor/commands/*.md` — one file per slash-command (e.g. `/retrospective`). Typically symlinked to `~/.cursor/commands/` so Cursor picks them up.
- **User-level agents:** `~/.config/cursor/agents/*.md` — one file per subagent (YAML frontmatter: `name`, `description`; body = system prompt). Typically symlinked to `~/.cursor/agents/`.
- **User-level skills:** `~/.config/cursor/skills/` — one **directory** per skill, each containing at least `SKILL.md` (frontmatter: `name`, `description`; body = instructions). Optional: `reference.md`, `examples.md`, `scripts/`. Typically symlinked to `~/.cursor/skills/`. Do not use `~/.cursor/skills-cursor/` (reserved for Cursor). See `skills/README.md` and `skills/_template.SKILL.md` for format.
- **Project-level rules:** In the **current workspace**, look for `.cursor/rules/*.mdc` or `.cursor/rules/*.md`, or `AGENTS.md` in the project root. Use these for repo-specific learnings. Project-level skills (if any) live in `.cursor/skills/<skill-name>/` in the repo.
- **Rule file format:** `.mdc` with YAML frontmatter (`description`, optional `globs`, `alwaysApply`). Body: markdown, under ~50 lines, one concern per rule. Match existing style in the target file.

---

## Phase 0: Session Analysis (Internal Reflection)

- **Directive:** Review every turn of this conversation. Synthesize into a concise, self-critical analysis.
- **Output (chat only for this phase; do not put in the final report):**
  - Bulleted list of key behavioural insights.
  - **Successes:** What principles or patterns led to an efficient, correct outcome?
  - **Failures & user corrections:** Where did your approach fail? Root cause? Exact user feedback that corrected behaviour?
  - **Actionable lessons:** Transferable lessons that could prevent future failures or replicate successes.

---

## Phase 1: Lesson Distillation & Abstraction

- **Directive:** Filter and abstract only the most valuable insights into **durable, universal principles.** Be ruthless.
- **Quality filter (durable ONLY if):**
  - **Universal & reusable:** Applies to many future tasks across projects, not a one-off.
  - **Abstracted:** General principle (e.g. "Verify env vars before use"), not session-specific detail.
  - **High-impact:** Prevents critical failure, enforces safety, or significantly improves efficiency.
- **Categorize where the lesson belongs:**
  - **User-level rule:** Timeless principle for any project → update or add a file in **`~/.config/cursor/rules/*.mdc`**. Match the format (frontmatter + short body). If the lesson fits an existing rule, refine that rule; otherwise add a new `.mdc` or a new section.
  - **Project rule:** Best practice specific to this repo → update or add in the **current workspace** (e.g. `.cursor/rules/` or `AGENTS.md`).
  - **Command or agent:** If the lesson is "offer a reusable prompt/workflow", consider adding a command in `~/.config/cursor/commands/` or an agent in `~/.config/cursor/agents/` instead of (or in addition to) a rule.
  - **Skill (skill evolution):** If the lesson is a **specialized workflow** the agent should apply when relevant (trigger + step-by-step instructions + guardrails), add or update a skill:
    - **New skill:** Create **`~/.config/cursor/skills/<skill-name>/`** and add `SKILL.md` (use `skills/_template.SKILL.md` for content). Include a clear `description` (what + when) so the agent knows when to use it.
    - **Existing skill:** Update **`~/.config/cursor/skills/<skill-name>/SKILL.md`** (or project `.cursor/skills/<skill-name>/`) with new steps, guardrails, or focus areas. Keep the skill concise and trigger-focused.
    - Prefer a skill when the lesson is a repeatable procedure (e.g. "always check X before Y", "when doing Z follow these steps") rather than a one-line rule.

---

## Phase 2a: Propose Changes (no edits yet)

- **Directive:** Plan how to integrate the distilled lessons into the config. **Do not edit any files yet.** Produce a reviewable proposal for the user.
- **Discovery:** Project rules (current workspace `.cursor/rules/`, `AGENTS.md`); user-level rules (`~/.config/cursor/rules/`); commands or agents (`~/.config/cursor/commands/`, `~/.config/cursor/agents/`); or skills (`~/.config/cursor/skills/<name>/SKILL.md` or project `.cursor/skills/<name>/`). Read target file(s) to match structure and tone.
- **Output for user review:** Present the following clearly:
  1. **Rationale:** Which lesson(s) from Phase 1 each change addresses and why it belongs in that file (or skill).
  2. **Target(s):** Full path(s) of file(s) or skill dir(s) to create or modify (e.g. `~/.config/cursor/rules/foo.mdc`, `~/.config/cursor/skills/my-skill/SKILL.md`, or `./.cursor/rules/bar.mdc`).
  3. **Proposed changes:** For each target, show either:
     - A **unified diff** (what would change), or
     - The **full proposed content** for new or heavily rewritten files. For **new skills**, show the full `SKILL.md` and note that the directory `skills/<skill-name>/` will be created.
  4. **Ask explicitly:** "Please review the proposed changes above. Reply with: **Approve** (apply as-is), **Approve with edits** (describe what to change), or **Skip** (do not apply these changes)."
- **Stop here.** Do not write to any config file until the user has approved (or approved with edits). If the user says Skip or requests changes, adjust the plan and re-present, or confirm no changes will be applied.

---

## Phase 2b: Apply Changes (only after approval)

- **Directive:** Only after the user has replied **Approve** or **Approve with edits** (and any edits are incorporated), apply the approved changes to the config files.
- **Skills:** For new skills, create the directory `~/.config/cursor/skills/<skill-name>/` (or project `.cursor/skills/<skill-name>/`) and add `SKILL.md`. For existing skills, edit the existing `SKILL.md`. Do not create skills under `~/.cursor/skills-cursor/`.
- If the user said **Skip** for all proposed changes, do not modify any files; proceed to Phase 3 and state that no changes were applied at user request.
- If the user said **Approve with edits**, incorporate their feedback into the plan, re-present the revised proposal, and wait for approval again before applying.

---

## Phase 3: Final Report

- **Directive:** After Phase 2b (or after the user declined changes), conclude with a structured report.
- **Contents:**
  1. **Config update summary:**
     - Which file(s) or skill(s) were updated (or "No changes applied" if the user skipped or no durable lessons were found): full paths.
     - Brief summary of what changed (or the fact that changes were approved and then applied). If any **skills** were added or updated, list them and note that they live in `~/.config/cursor/skills/` (symlinked to `~/.cursor/skills/`).
     - If you updated any **user-level rule** in `~/.config/cursor/rules/`: remind the user that if they use **Cursor Settings → Rules** for User Rules, they may need to re-paste from the updated file.
  2. **Session learnings:**
     - Concise bulleted list of key patterns from Phase 0 (context and evidence for any updates).

---

## Execution order

1. **Phase 0** (internal) → **Phase 1** → **Phase 2a** (propose changes; present for review; **stop and wait for user approval**).
2. After user replies **Approve** or **Approve with edits**: **Phase 2b** (apply only the approved changes).
3. **Phase 3** (final report).

Do not write to any rule, command, agent, or skill file until the user has explicitly approved the proposed changes.
