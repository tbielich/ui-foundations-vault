---
id: export-pack.governance.component-governance
title: Component Governance
type: governance
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: derived
summary: Reusable component governance guidance for consuming repositories.
related:
  references:
    - registry.sync-contract
---

# Component Governance

## Rules

- Component guidance must distinguish model, lifecycle, states, composition, and implementation.
- Runtime repositories own component code and tests.
- The vault owns reusable component expectations, review criteria, and governance.
- Component variants should be justified by user need, accessibility behavior, or product semantics.
- Component exceptions should be documented locally and reflected back as lessons when reusable.

## Review Expectations

Manual review is required when a change affects component lifecycle, public API expectations, accessibility behavior, composition rules, or cross-package boundaries.
