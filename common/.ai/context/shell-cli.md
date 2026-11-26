# Shell, Git and local tools

Read before substantial shell commands, Git remote operations, filesystem changes, Stow work, or Mise/uv verification. Check the actual execution shell and machine; an OS-specific workaround is not universal.

- Normalise terminal wrapping before asserting CLI error messages.
- Inspect registered CLI options when help truncates flag names.
- Recheck Git with fsmonitor disabled per command after IPC warnings.
- Check filesystem devices before renaming audit scratch.
- Use login-free shells and verified Mise pruning exclusions during verification.
- Anchor generated directory ignore rules to avoid hiding source packages with matching names.
- Check optional CLI availability before relying on it for verification.
- Run mise and uv with approved cache access in restricted workspaces.
- Use locked binaries directly when disposable checkouts lack trusted Mise configuration.
- Protect configured Mise tools from automatic pruning during unrelated verification.
- Use discovered paths for searches; avoid speculative shell globs.
- `rg -r` means replace, not recursive; ripgrep recurses by default.
- `rg` patterns starting with `-`: pass via `-e`.
- Sandboxed `git fetch`/`push`/`rebase` fails (self-signed cert, SSH known_hosts, protected files); retry unsandboxed.
- Fetch origin before citing local repo files as current state.
- `git add -p` is unavailable (no interactive input). To split one file across commits, write the intermediate content to scratch, then `git hash-object -w` and `git update-index --cacheinfo 100644,<blob>,<path>`; lint-staged keeps the unstaged remainder.
- Sandbox blocks DNS (`dig` times out); retry lookups unsandboxed.
- Sandboxed `tsx` dev servers fail with `EPERM` on `listen` (IPC pipe); run unsandboxed. Unsandboxed `$TMPDIR` is `/var/folders/...`, not the sandbox temp dir, so read its logs unsandboxed too.
- Verify live symlinks before interpreting Stow simulation errors as broken links.
- Bash tool runs zsh: `$var` doesn't word-split; use `${=var}` or literal commands.
- macOS `/bin/bash` is 3.2: no `BASHPID`, `mapfile` or associative arrays.
