---
id: export-pack.governance
title: Governance Pack
type: export-pack
status: accepted
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-10-31
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

The portable machine-readable naming source for runtime consumption is `contracts/naming-contract.json`. Markdown documentation may explain the naming rules, but runtime repositories should consume the JSON contract instead of duplicating Vault rules in local code or documentation.

It is intended for reviewed consumption by runtime, documentation, package, and experiment repositories. It should be copied only when local ownership and review expectations are clear.

## Contents

- `pack.yml`
- `CHANGELOG.md`
- `contracts/naming-contract.json`
- `naming-rules.md`
- `token-governance.md`
- `component-governance.md`
- `accessibility-baseline.md`

## Version

Current version: `0.9.0`

Channel: `stable`

The manifest in `pack.yml` defines publishable pack metadata. The changelog records version history. Runtime repositories may consume this pack only through reviewed local changes.

## Release Review

Version 0.9.0 and its source-status transitions are a proposal until owner review
and merge. Branch output is a release candidate, not published governance.
See `docs/evidence/governance-pack-0.9.0.md` for the review scope and validation.
Runtime adoption and Figma upload remain separate reviewed consumer actions.
