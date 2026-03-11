---
name: evolve-skill
description: Review user feedback or session patterns and create or update Codex skills so durable behavior changes are captured in the right SKILL.md with proposal-first approval.
---

# Evolve Skill

Use this skill when the user wants to adjust Codex behavior via skills, update an existing skill, or turn a repeated workflow into a new skill.

# 1. Define the target

- Identify whether the request should update an existing skill or create a new one.
- Prefer updating an existing skill when the behavior clearly belongs there.
- Create a new skill only when the workflow is distinct enough to need its own trigger and instructions.

# 2. Gather the minimum context

- Read the relevant `SKILL.md` files and only the local files needed to understand the request.
- If the request is based on recent interaction, review the current conversation for concrete examples.
- Distill durable lessons, not one-off preferences unless the user explicitly wants a one-off encoded.

# 3. Design the change

- Write or update trigger language so the skill activates for the right requests.
- Keep instructions concise, operational, and scoped to the workflow.
- Add guardrails for approvals, validation, or preservation of existing content when the workflow needs them.
- Avoid overlapping heavily with another skill unless the overlap is intentional and clearly bounded.

# 4. Propose before editing

- Show the target path and the proposed `SKILL.md` content or diff before applying changes.
- Ask for explicit approval before modifying a skill if the request is framed as behavioral evolution, retrospection, or config hardening.
- If the user explicitly asked to create or update the skill directly, apply the change without a separate approval round.

# 5. Apply cleanly

- Create the skill directory only when needed.
- Keep the skill lean; do not add extra docs unless they are directly required.
- If the skill has UI metadata such as `agents/openai.yaml`, keep it in sync when present.

# 6. Verify

- Re-read the final `SKILL.md` to confirm the trigger, workflow, and guardrails are coherent.
- In the response, explain what behavior the skill now captures and when to invoke it.
