---
id: export-pack.governance
title: Governance Pack
type: export-pack
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: derived
summary: Curated governance guidance for reviewed consumption by UI Foundations ecosystem repositories.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - registry.sync-contract
---

# Governance Pack

## Purpose

The Governance Pack contains reusable rules for naming, tokens, components, and accessibility.

It is intended for reviewed consumption by runtime, documentation, package, and experiment repositories. It should be copied only when local ownership and review expectations are clear.

## Contents

- `pack.yml`
- `CHANGELOG.md`
- `naming-rules.md`
- `token-governance.md`
- `component-governance.md`
- `accessibility-baseline.md`

## Version

Current version: `0.1.0`

Channel: `draft`

The manifest in `pack.yml` defines publishable pack metadata. The changelog records version history. Runtime repositories may consume this pack only through reviewed local changes.
