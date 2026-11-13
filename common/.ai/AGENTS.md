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

- Concise, technical, direct; no filler or exaggerated praise. Technical depth appreciated
- When presenting a plan, include a confidence level and the main uncertainty
- Check local docs first (plugin `/doc/`, `node_modules/*/README.md`), then official docs online; don't iterate blindly on failed approaches
- Never use em dashes in prose you write; use commas, parentheses, periods, or hyphens
- Slack drafts: 3-5 lines, conclusion first, then links. Cut before I ask

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
- Don't use `- [ ]` checkboxes (rendered escaped); use plain `-` bullets
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

## Applied Learning

- Validate Markdown fragments against complete heading slugs, including dates.

- Use Chromium headless-shell for CLI rendering when regular Chromium hangs.

- Check existing viewer configuration before changing diagrams or recommending replacement tools.

- Configure visible fields on GitHub table views; Roadmap rejects column configuration.

- Limit GitHub schema introspection to two inputFields selections per query.

- Insert new sections before existing headings without duplicating those headings.

- Verify raw policy text when extracted pages omit relevant clauses.

- Normalise terminal wrapping before asserting CLI error messages.

- Verify acquisition permission independently of static-map display rights.

- Inspect registered CLI options when help truncates flag names.

- Nest view variants beneath their primary inspection category.

- Verify map exports contain pixels before accepting service responses.

- Check contour density against each map’s actual height range.
- Generalise display lines without changing source terrain or implying vertical accuracy.

- Use object-dtype arrays for empty Shapely spatial-index queries.

- Allow subnanometre floating-point tolerance in derived polygon-boundary predicates.

- Allow CSSOM rounding when verifying fractional percentage positions.

- Preserve observed partial boundary cells when clipping raster displays to polygon outlines.

- Clarify whether colour thresholds are bands or continuous scale anchors.

- Inspect existing API definitions before writing verification helpers.

- Recheck Git with fsmonitor disabled per command after IPC warnings.

- Check filesystem devices before renaming audit scratch.

- Separate standard, dependency and project imports, including imports inside test functions.

- Verify SVG text bounds in the browser; successful raster rendering can hide clipping.
- Check serialized SVG transforms separately from float32 browser matrix values.
- Compare SVG bounds and viewports in the same coordinate system.
- Check SVG clipping inherited from ancestor groups.
- Validate visibility, placement and every reference to SVG geometry used as evidence.
- Reject non-finite browser measurements before JSON serialization.
- Verify raster coverage at every viewport corner after rotation.

- Use login-free shells and verified Mise pruning exclusions during verification.

- Extend generated schemas with allOf; replacing properties erases generated field definitions.

- Poll asynchronous browser state instead of assuming fixed delays complete work.

- Check assertion line lengths before validation; formatters cannot reliably split long expressions.

- Inspect read results before constructing dependent patches; use separate tool calls.

- Anchor generated directory ignore rules to avoid hiding source packages with matching names.

- Check optional CLI availability before relying on it for verification.

- Run mise and uv with approved cache access in restricted workspaces.
- Protect configured Mise tools from automatic pruning during unrelated verification.

- Bound audits, review before expensive verification, and repeat checks only with concrete justification.

- Use discovered paths for searches; avoid speculative shell globs.

- Inspect nested model fields before constructing or mutating fixture values.

- Verify public API documentation before treating frontend endpoints as supported provider interfaces.

- Keep new Python lines within the configured Ruff line length before validation.

- Split long string literals before validation; formatters cannot shorten their source lines.

- Preserve Markdown bullet markers when composing patch hunks.

- Locate every affected patch context after formatting, including small sibling edits.
- Recheck formatter-changed patch context before applying multi-file edits.

- Use whole-block patches when inserting sibling branches.

- Version-gate stricter validation to preserve historical parsing contracts.

- Clarify whether visual feedback targets the base image or a toggled overlay.

Add a one-line bullet here (under 15 words, no explanation) when: you make the same mistake twice, I correct or re-explain something, or a workaround is found for a tool limitation. Write it immediately, tell me you did, and don't ask first. Repo-specific facts go in project memory instead. Run the `retro` skill at the end of sessions with friction. Prune bullets that are stale or now covered elsewhere.

- `rg -r` means replace, not recursive; ripgrep recurses by default.
- `rg` patterns starting with `-`: pass via `-e`.
- Debugging Claude/gateway config: read settings files first, not env probes.
- Never infer the newest gateway model from env vars; check the model list.
- CloudFront `FunctionGeneratedResponse` identifies the layer, not the reason; hand over.
- Slack and GitHub MCP are read-only context sources: never post, react, create, merge or push through them. Draft text for me to send; use `gh` for any GitHub write I've approved
- Large PR reviews: use the 1M-context model or delegate to subagents.
- Testing guard hooks: feed blocked sample commands from a file, not inline.
- Sandboxed `git fetch`/`push` fails on a self-signed cert; retry unsandboxed.
- Config comments: one-line purpose only; never explain mechanics behind a fix.
- Combine each file's edits into one apply_patch operation per patch.
- Order each file's patch hunks by their current line positions.
- Match application headers in HTTP diagnostics; default tool headers can change responses.
- Exclude assets from config searches; filter large JSON output before returning it.
- Limit batched reads by their combined tool output budget.
- Keep combined discovery output below the tool budget, including search results.
- Compare large serialized regression results by digest to avoid expensive failure diffs.
- Release closure-captured loop variables by reassignment, not deletion, to satisfy Ruff.
- Freeze fingerprinted source files throughout incremental-cache verification.
- Keep pytest's cache provider enabled when using --ff or --lf.
- Omit empty patch hunks; they can invalidate all edits in a patch.

- Derive configured test output paths from returned artifacts rather than hardcoded locations.
- Revise dependent assertions when changing fixture versions or adding imported records.
- Avoid duplicate context hunks when composing a single-file patch.
- Revise the existing interface when the user rejects a parallel review surface.
- Recheck imports after auto-fixes before adding later symbol usages.
- Treat CSS function names case-insensitively while preserving identifier case.
- Restrict numeric validation to numeric fields; preserve identifiers as literal text.
- Separate publication eligibility from strict aggregate read validity.
- Tokenize SVG path data before checking numeric finiteness.
- Summarise generated asset inventories instead of returning every path.
- Test magnitude-based selection with vertically scaled negative controls.
- Separate domain exclusions from missing observations in coverage denominators.
- Verify complete rendered stroke footprints, including casing, against continuous support.
- Extract relevant XML fields instead of printing complete metadata documents.
- Verify provider HTTP responses before treating web-reader failures as unavailable documentation.
- Separate numerical estimator support from physical feature-size requirements.
- Test non-quadratic smooth terrain before interpreting better fits as discrete transitions.
- Exclude held-out heights from discovery, preprocessing, derivative stencils and model fitting.
- Verify each group's painted footprint against its own associated model support.
- Disable Ruff caching when checking scratch files against a read-only repository.
- Measure the requested contrast directly before substituting curvature or edge-detection proxies.
- Require feature-wide evidence before promoting local matches into whole-feature classifications.
- Apply eligibility requirements before reducing ranked alternatives to a winner.
- Count evidence intersections when qualification requires multiple conditions in the same cases.
- Fix evaluation observations and weights independently of training-selected candidates.
- Verify that a claimed counterexample occurs within the algorithm's declared search space.
- Verify discovery with production grid alignment and quotas separately from fixed-witness replay.
- Specify how gaps split candidates before fitting and budget each fragment.
- Give review variants explicit verifier identities and routes into the review surface.
- Require detached readers to recompute eligibility from sealed evidence.
- End independent implementation reviews with a copyable prompt for the implementation chat.
- Construct negative controls that pass earlier gates and isolate the intended failure.
- Verify terminal-dependent hooks through the actual runtime, including shared daemon environment.
