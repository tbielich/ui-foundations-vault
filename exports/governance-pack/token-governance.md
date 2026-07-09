---
id: export-pack.governance.token-governance
title: Token Governance
type: governance
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: derived
summary: Reusable token governance guidance for consuming repositories.
related:
  references:
    - registry.sync-contract
---

# Token Governance

## Rules

- Token decisions must preserve a clear distinction between core, semantic, theme, mode, and component-facing usage.
- Runtime repositories may implement token output, but canonical token meaning belongs in the vault.
- Token changes should describe consumer impact before implementation work begins.
- Token aliases, renames, and removals require migration notes.
- Repeated token implementation issues should be reflected back into vault lessons.

## Review Expectations

Manual review is required for token naming changes, semantic meaning changes, lifecycle changes, and changes that affect accessibility-relevant color or spacing behavior.
