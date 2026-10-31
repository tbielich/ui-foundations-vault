---
id: export-pack.governance.token-governance
title: Token Governance
type: governance
status: accepted
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-10-31
authority: derived
summary: Reusable token governance guidance for consuming repositories.
related:
  references:
    - registry.sync-contract
    - adr.token-model-and-figma-projection
---

# Token Governance

## Rules

- Preserve `Core → Appearance {Brand, Scheme, Scale} → Semantics → Patterns`, as defined in `adr.token-model-and-figma-projection`. Brand, Scheme and Scale are independent contextual axes.
- Preserve Surface, Content, Foreground and Border as distinct roles. Contrast repairs must preserve intended brand hue and inversion; verify every affected Brand × Scheme × State combination.
- Library source changes, publication and consuming-file updates are separate steps. Verify actual resolved consumer values before claiming parity.
- Runtime repositories may implement token output, but canonical token meaning belongs in the vault.
- Token changes should describe consumer impact before implementation work begins.
- Token aliases, renames, and removals require migration notes.
- Repeated token implementation issues should be reflected back into vault lessons.

## Review Expectations

Manual review is required for token naming changes, semantic meaning changes, lifecycle changes, and changes that affect accessibility-relevant color or spacing behavior.
