# Contracts, fixtures and validation

Read when changing schemas, parsers, validation rules, imported fixtures, or regression checks. Preserve the applicable contract and version boundary.

- Inspect existing API definitions before writing verification helpers.
- Extend generated schemas with allOf; replacing properties erases generated field definitions.
- Bound audits, review before expensive verification, and repeat checks only with concrete justification.
- Inspect nested model fields before constructing or mutating fixture values.
- Version-gate stricter validation to preserve historical parsing contracts.
- Compare large serialized regression results by digest to avoid expensive failure diffs.
- Derive configured test output paths from returned artifacts rather than hardcoded locations.
- Revise dependent assertions when changing fixture versions or adding imported records.
- Restrict numeric validation to numeric fields; preserve identifiers as literal text.
- Summarise generated asset inventories instead of returning every path.
