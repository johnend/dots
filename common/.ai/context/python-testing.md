# Python implementation and testing

Read when changing Python imports/tests, running Ruff or pytest, or verifying a separate checkout.

- Separate standard, dependency and project imports, including imports inside test functions.
- Check assertion line lengths before validation; formatters cannot reliably split long expressions.
- Override pytest's configured pythonpath when verifying code from another checkout.
- Keep new Python lines within the configured Ruff line length before validation.
- Split long string literals before validation; formatters cannot shorten their source lines.
- Release closure-captured loop variables by reassignment, not deletion, to satisfy Ruff.
- Keep pytest's cache provider enabled when using --ff or --lf.
- Recheck imports after auto-fixes before adding later symbol usages.
- Disable Ruff caching when checking scratch files against a read-only repository.
