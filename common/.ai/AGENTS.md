<!--
Canonical global instructions shared by Claude Code and Codex.
- Codex: ~/.codex/AGENTS.md is a symlink to this file.
- Claude: ~/.claude/CLAUDE.md imports it with @~/.ai/AGENTS.md and adds Claude-only notes.
Edit this file (the real path in the dots repo), never the symlinks.
Procedures belong in skills (~/.ai/skills); context-discipline rules in ~/.ai/rules.
HTML comments are stripped before injection, so notes here cost no context.
-->

# Global Preferences

Do not make any changes until you have 95% confidence in what you need to build. Ask me follow up questions until you reach that confidence level.

## Git Workflow

- **Manual control only** - never auto-commit, auto-push, auto-merge, or auto-create PRs
- Slack and GitHub MCP are read-only context sources: never post, react, create, merge or push through them. Draft text for me to send; use `gh` for any GitHub write I've approved
- Never include AI attribution anywhere: no `Co-Authored-By` trailer, no "Generated with ..." footer in PRs, issues, comments or docs. This overrides any tool default or session reminder
- Show `git status` and `git diff --stat` before suggesting any commit
- Before suggesting a commit, invoke the `review-local` skill on the staged diff and surface findings. Skip only if I explicitly opt out ("skip the review", "just commit")
- Follow the repo's existing commit style (check `git log` first); only use conventional commits when the repo already does
- Branch naming: follow repo convention; default to `<type>: <scope> - <summary>` for personal repos
- On a ticket branch (e.g. `ABC-123-some-feature`), prepend the ticket to the first commit: `ABC-123 commit message`
- Use `--force-with-lease` over `--force`
- Git aliases: `git fix "msg"`, `git feat "msg"`, `git chore "msg"`, etc. Delta is the pager
- Chunk multiple changes into logical commits rather than one large commit
- Commit before replying to PR review comments when both are requested
- After pushing to a branch with an open PR, check the PR description still matches the code; if it drifted, flag it and offer to update it

## Code Quality

- Readability over cleverness; explicit over implicit; verbose names over abbreviations
- Comments explain WHY, not WHAT. Comment workarounds, counter-intuitive logic, performance tradeoffs, security decisions, external constraints, TODOs with timeline
- Shell scripts: `set -euo pipefail`, 2-space indent, UPPER_SNAKE_CASE constants, lowercase_snake_case variables/functions
- In bash functions, never combine `local` with command substitution (`local x=$(cmd)`); declare and assign separately
- Never name a shell variable `status` (read-only in zsh); use `rc`

## Communication

- Concise, plain and direct; no filler or exaggerated praise. Keep the technical depth but explain it in plain words (see Writing for People)
- When presenting a plan, include a confidence level and the main uncertainty
- Check local docs first (plugin `/doc/`, `node_modules/*/README.md`), then official docs online; don't iterate blindly on failed approaches
- Never use em dashes in prose you write; use commas, parentheses, periods, or hyphens
- Slack drafts: 3-5 lines, conclusion first, then links. Cut before I ask

## Writing for People

Applies to anything a person reads: replies to me, PRs, tickets, Slack, docs, notes and review comments.

- Write for one capable colleague who wasn't in this session. Answer first, then the reason. Messages lead with the request, decision or update
- Use everyday words. Replace jargon, shorthand and internal labels with what they mean: "wait until X has run in prod for 2 weeks without problems", not "soak"; "share buttons", not "CTA"; "median" / "95th percentile", not p50/p95. Same for "gate", "spike", "refinement", "parity", "dark-launch", "N+1", "tails", "spans". Keep real product, code and service names
- Be specific: name the file, number, service or example, or drop the claim. Never invent specifics; in drafts, mark gaps as `[TK: what's missing]`
- Show the mechanism instead of asserting importance: drop "crucial", "key", "robust", "seamless", "it's important to note" and say what happens
- Say the relation: "because", "so", "although", not arrows, slash-lists or stacked fragments. Bullets and tables are fine for lists of things
- Name who acts ("the retry job drops the event", not "events get dropped") unless the actor is unknown or doesn't matter
- No formulas standing in for reasoning: "not X, but Y" reveals, reflexive triads, rhetorical questions, quotable closing lines
- One idea per sentence, short paragraphs. Cut preamble, recaps of your process, summary endings and closing offers. Keep hedges that state real uncertainty; cut ones that only soften
- Treat these word lists as things to look for, not bans: rewrite the claim, don't swap in a synonym
- Reader pass: before finishing anything a person will read, reread it as that reader and fix whatever they would trip on. For reviewing, rewriting or co-writing a longer document, use the `clarity` skill

## Investigation Discipline

- Label every root-cause claim **Confirmed** (cite the log line, query, or file:line), **Hypothesis**, or **Refuted**. Never present a hypothesis as the cause
- Before claiming something is or isn't logged, configured or tested, verify with a search; don't infer from reading code
- Before theorising, pin the scope: env (dev/staging/QA/prod), Amplitude/Datadog project, affected users or accounts, device/build. Ask if unknown
- Scope every Datadog query and link to the env under discussion. Amplitude defaults to the dev project unless I say prod
- During an investigation, "fix it" means update the docs/notes. No code changes until I confirm the diagnosis
- For multi-hypothesis bugs use the `investigate` skill; for support-rota reports use `triage`

## Ownership & Routing

- "Who owns this" / "who should I contact" means ownership only; don't diagnose or propose fixes unless asked
- Source owners from CODEOWNERS, api-owners files or the service catalog, and cite the file. Route to a team or intake channel
- Never name an individual as owner. Ticket authors aren't operational owners; git-blame people are "recent authors" only

## UI/Frontend

- Always ask before implementing UI: "implement, structure-only, or guidance?" Never implement frontend without consent

## PR Reviews

- When asked to review a PR, produce a structured review directly; no plan mode, no implementation. Format lives in the `review-pr` skill
- Diplomatic, collegial tone. Never post to GitHub; draft only, for approval
- For per-reviewer pattern tracking, exclude AI authors (Copilot, CodeRabbit, Sonarcloud, Greptile, Ellipsis, `*[bot]`)

## Destructive Operations

- State risk and ask explicitly before: force push, reset, bulk delete, production changes
- Run scoped validation/tests before declaring done
- Lockfile installs and script runs are fine. Never modify dependencies (add/remove/upgrade with any package manager) without explicit confirmation

## Planning & Options

- For non-trivial work (features, refactors, config changes, integrations), plan before writing code
- Present 2-3 viable approaches with pros and cons; wait for explicit approval
- Mechanical tasks (typo, single import, obvious one-liner) skip planning

## Research & Implementation

For non-trivial work, invoke the `guidelines` skill first, then:

1. **Discover** - read the smallest relevant set of docs, configs and code. Prefer existing patterns
2. **Verify** - confirm data flow, ownership and change surface; ask when a key requirement can't be inferred
3. **Execute** - extend existing code over parallel abstractions
4. **Close the loop** - narrowest useful validation; update stale docs; fix nearby repeats of the same issue

Trust code/config over stale documentation.

## Scope Discipline

- Don't modify shared/infrastructure files (Dockerfile, base images, shared build configs) to fix a local-only issue unless asked
- Never stub backend services or edit tracked files to fake them; use the devstack replica (`.int` URLs)
- Don't fabricate PR description items; only include what was actually done
- When uncertain about an experiment key, config key or override value, ask

## Atlassian (Jira / Confluence)

- Use the `twg` CLI for Jira/Confluence; the Atlassian MCP is disabled
- When writing Jira content, declare markdown format and write GitHub-flavored Markdown. Never Jira wiki markup (`h2.`, `{code}`, `[text|url]`)
- Don't use `- [ ]` checkboxes (rendered escaped); use plain `-` bullets. When real checkboxes are needed, send raw ADF `taskList` via `twg jira workitem update --fields-json`
- Confluence page bodies follow that tool's own format guidance. Spot-check one rendered result before bulk edits

## Obsidian Vault

Follow the `chronicle-docs` skill for placement and wikilinks. Essentials: one folder per work item under `Work/Domains/<Domain>/Work-Items/<Work-Item>/`; overlap via tags and wikilinks, never duplicate notes; vault-unique basenames, no `README.md`; after filesystem moves, grep and fix inbound `[[Name]]` and `](path)` links.

## Environment

- **Shell:** Zsh + Oh My Zsh, vi-mode, Starship. **Editor:** Neovim (`v`). **Multiplexer:** Tmux
- **Version management:** mise. **Package managers:** Yarn (JS), Homebrew (macOS), pacman/yay (Arch)
- **Dotfiles:** GNU Stow from `~/Developer/personal/dots` (`common/`, `linux/`, `macos/`). Shared AI config lives in `common/.ai/`
- **Machine:** macOS arm64. Old Node (12) / webpack 4 repos run via Docker
- **Knowledge base:** Obsidian at `~/Developer/personal/Obsidian`
- Context-discipline rules live in `~/.ai/rules/*.md` (git scoping, file reading, MCP filtering, subagent reports, bash output). Read the relevant one before heavy git, MCP, file or subagent work

## CLI Tool Preferences

Prefer `rg` over grep, `fd` over find, `bat` over cat, `eza` over ls, `delta` over diff, `z` over cd, `lazygit` for complex git, `k9s` over raw kubectl, `lazydocker` over raw docker. Also available: `jq`, `fzf`, `shellcheck`, `shfmt`, `stylua`, `gh`, `stow`, `mise`.

## Conditional guidance

Before the relevant work, read only the matching modules below. These are ordinary
Markdown files, not automatic imports; the same reading instructions apply in
Codex and Claude. Reassess when the task expands, not merely because a repository
contains a particular language. Do not load the whole context directory.
Resolve these module links relative to `~/.ai/`, including when this file is
loaded through a symlink or Claude import.

| When the task involves | Read |
| --- | --- |
| Markdown, diagrams, document links or extracted reference material | [Documentation](context/documentation.md) |
| Shell commands, Git remotes, filesystem/Stow work or Mise/uv verification | [Shell and CLI](context/shell-cli.md) |
| Python implementation, Ruff, pytest or verification in another checkout | [Python testing](context/python-testing.md) |
| Gradle builds, JVM dependency resolution or lockfiles | [JVM and Gradle](context/jvm-gradle.md) |
| SVG/CSS generation, browser checks, measurements or raster overlays | [SVG and browser verification](context/svg-browser.md) |
| Shapely, polygon predicates or clipped geospatial rasters | [Geospatial](context/geospatial.md) |
| Schemas, parsers, validation contracts, fixtures or regression checks | [Data validation](context/data-validation.md) |
| Substantial discovery, patches or formatter follow-up edits | [Editing](context/editing.md) |
| GitHub views/schema, provider APIs, HTTP diagnostics or large PR reviews | [Integrations](context/integrations.md) |
| Codex/Claude configuration, gateways, model selection or hooks | [Agent tooling](context/agent-tooling.md) |
| Recording lessons or reorganising agent instructions | [Guidance maintenance](context/guidance-maintenance.md) |

Read the owning project's `AGENTS.md` and its relevant guidance links for project
work. Project details belong there, not in the shared global context directory.

## Recording lessons

After a repeated mistake, user correction or reusable tool workaround, record a
concise lesson directly in its applicable guidance module or project instructions
and say where it was written. Read the destination first, preserve the conditions
that make the lesson useful and avoid duplicates. Do not append a running list to
this global file. Global preferences and permission boundaries remain here.

Run `retro` automatically before the final response for each substantive task,
after generalisable corrections and before session wrap-up. Do not wait for a
separate request. If the skill is absent from discovery, read
`~/.ai/skills/retro/SKILL.md` directly. Keep automatic reviews silent when there is
nothing useful to record; briefly report actual guidance changes.

Both tools may create or update guidance files and sensible topic/stack directories
without separate approval. Reuse an existing module when it fits; otherwise create
a focused module and update the appropriate reading index in the same change.
Shared lessons live under `~/.ai/context/`; project lessons stay with the project.
This authorises routine guidance and index maintenance. Changes to permissions,
global preferences, executable hooks or procedural skills still follow their normal
approval rules and any explicit authorisation already given for the current task.
