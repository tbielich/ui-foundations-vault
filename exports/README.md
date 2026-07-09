---
id: exports.index
title: Export Packs
type: index
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: supporting
summary: Navigation for reviewed cross-repo export packs.
related:
  governed_by:
    - registry.sync-contract
  references:
    - export-pack.agent
    - export-pack.governance
    - export-pack.runtime
---

# Export Packs

## Purpose

Export packs curate reusable vault guidance for reviewed consumption by other UI Foundations repositories.

They are derived from canonical vault knowledge. When a pack conflicts with a source document, the source document and vault precedence win.

## Packs

- `agent-pack/`: agent guidance, behavior rules, review rules, and reusable prompts.
- `governance-pack/`: versioned naming rules, token governance, component governance, and accessibility baseline.
- `runtime-pack/`: runtime validation expectations, component implementation rules, CSS architecture rules, and package boundary rules.

## Publication

Governance Pack publication is declared by:

- `registry/governance-packs.yml`
- `exports/governance-pack/pack.yml`
- `exports/governance-pack/CHANGELOG.md`

Publication metadata is advisory until reviewed. It does not trigger automatic synchronization.
