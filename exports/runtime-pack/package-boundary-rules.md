---
id: export-pack.runtime.package-boundary-rules
title: Package Boundary Rules
type: specification
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: derived
summary: Non-code package boundary expectations for UI Foundations runtime repositories.
related:
  references:
    - registry.sync-contract
---

# Package Boundary Rules

## Rules

- Package boundaries should make ownership and consumer impact visible.
- Shared knowledge should not become an implicit package dependency.
- Runtime packages own exports, dependency declarations, build output, and release mechanics.
- Vault guidance may describe expected boundaries but must not change package configuration directly.
- Boundary changes require review when they affect downstream consumers or export surfaces.
