---
id: export-pack.runtime.css-architecture-rules
title: CSS Architecture Rules
type: specification
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: derived
summary: Non-code CSS architecture expectations for UI Foundations runtime repositories.
related:
  references:
    - registry.sync-contract
---

# CSS Architecture Rules

## Rules

- CSS should express token and component semantics clearly enough to review.
- Component styling should avoid hidden dependencies on unrelated components.
- State styling should be explicit and discoverable.
- Token usage should preserve the distinction between semantic intent and generated output.
- Build and bundling details remain local to runtime repositories.
