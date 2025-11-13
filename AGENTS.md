# Repository Guidelines

## Project Structure & Module Organization
Dotfiles are split by portability: `common/` holds cross-platform config (Neovim under `common/.config/nvim`, shell profiles), while `linux/` and `macos/` overlay host-specific tweaks such as Sway rules or `.tool-versions`. Installer assets stay in `lib/`; `lib/sway/` ships the EndeavourOS/Arch bootstrap and package manifests. Lightweight utilities that run under an existing desktop live in `linux/scripts/`.

## Build, Test, and Development Commands
- `stow common -t $HOME` — symlink the shared configs into a fresh home directory; repeat for `linux` or `macos` as needed.
- `bash common/install.sh` — reproducibly install Oh My Zsh, Powerlevel10k, TPM, and rebuild the `bat` cache.
- `sudo ./lib/sway/sway-install.sh --dry-run` — show everything the Sway installer would touch; drop `--dry-run` to perform the real install.
- `./lib/sway/validate-environment.sh` — confirm required packages, services, and dotfiles are present after provisioning.
- `zsh linux/scripts/toggle-internal-kb.sh` — quick utility to enable/disable the laptop keyboard inside Sway.

## Coding Style & Naming Conventions
Shell scripts should declare their interpreter (`#!/bin/bash` or `#!/bin/zsh`), enable safe-mode flags (`set -euo pipefail` for Bash additions), and keep indentation to two spaces for readability. Use uppercase snake case for constants (`INTERNAL_KB_ID`) and descriptive lowercase names for locals. Configuration directories should mirror upstream paths (e.g., `common/.config/<app>`), and filenames should stay lowercase with hyphens to match their window manager bindings. Run `shellcheck` locally before committing complex scripts, and keep comments actionable—explain why a non-obvious command is needed rather than what it does.

## Testing Guidelines
Prefer script-provided validation over ad-hoc testing. Always execute `sway-install.sh --dry-run` before touching live systems, and rerun `validate-environment.sh` after modifying package sets or unit files. When updating terminal or shell configs, launch a subshell with `env ZDOTDIR=$(pwd)/common zsh -f` to ensure they bootstrap without host artifacts. UI tweaks should be exercised manually inside Sway or macOS (e.g., reload Waybar to catch syntax errors). Document manual test steps in PR descriptions whenever automation is impossible.

## Commit & Branch Guidelines
Follow the existing `<area>: <scope> - <summary>` pattern seen in history (`linux: sway - wayland firefox env vars`). Group related edits into a single commit, keep tense imperative, and describe the user-facing delta in under 72 characters. Do not create commits without owner sign-off; instead post `git status` plus `git diff --stat` (or `git diff | delta`) so the owner can inspect changes first. This is a personal repo, so unsolicited PRs are closed by default—open a feature branch only when a long refactor would otherwise block work on `main`, then wait for explicit approval before merging. When requesting review, call out the directories touched, rerun scripts, and any manual verifications performed, and update `AGENTS.md` in the same branch whenever workflows or policies change so future contributors stay aligned.
