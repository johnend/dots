# Agent configuration, hooks and gateways

Read when configuring or diagnosing Codex, Claude, AI gateways, model selection, or terminal-dependent hooks. Verify CLI/version behavior before applying a recorded workaround.

- Validate Codex profiles with `mcp list`; app-server startup validation rejects `--profile`.
- Debugging Claude/gateway config: read settings files first, not env probes.
- Redact config dumps by value pattern (`Bearer`, `sk-`), not only key names.
- Never infer the newest gateway model from env vars; check the model list.
- Testing guard hooks: feed blocked sample commands from a file, not inline.
- Verify terminal-dependent hooks through the actual runtime, including shared daemon environment.
- Verify both tools resolve installed skills to the same canonical files.
