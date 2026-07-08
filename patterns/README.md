---
id: index.patterns
title: Patterns
type: index
status: stable
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: supporting
summary: Entry point for agent-readable UI pattern specifications.
---

# Patterns

This directory contains agent-readable UI pattern specifications for UI Foundations. These specs translate standards, existing UI Foundations documentation, and platform behavior into stable implementation guidance that agents can use when producing component specs, tests, documentation updates, or review feedback.

## Source Boundaries

The main UI Foundations repository contains human-facing pattern documentation:

- `/Users/Thomas.Bielich@tui.com/GitHub/ui-foundations/docs/patterns`
- Supporting generated/site documentation can live under `/Users/Thomas.Bielich@tui.com/GitHub/ui-foundations/site`

The vault contains agent-readable pattern specifications:

- `/Users/Thomas.Bielich@tui.com/GitHub/ui-foundations-vault/patterns`

Vault pattern specs must not duplicate product documentation 1:1. Human-facing docs explain usage for designers and consumers. Vault specs define the reusable contract agents need to preserve semantics, accessibility, token expectations, implementation boundaries, and test obligations.

## Source-of-Truth Model

```txt
External Standards
↓
UIF Base Pattern
↓
UIF Component Spec
↓
Runtime Implementation
↓
Tests
↓
Documentation
```

External standards and native platform behavior provide the highest-level basis. UIF base patterns concretize those rules for UI Foundations. Component specs implement patterns. Runtime code, tests, and documentation must remain traceable to the component spec and pattern contract.

## Conflict Resolution

When guidance conflicts, apply this order:

1. Native HTML behaviour wins.
2. WAI-ARIA and WCAG requirements win.
3. UIF Base Patterns concretize standards.
4. Component specs implement the pattern.
5. Visual design variants must not break semantics.

## Using Templates

Agents must start new pattern specs from the closest template:

- `templates/base-pattern.template.md` for standard-native primitives such as button, link, input, checkbox, radio, select, textarea, dialog, and disclosure.
- `templates/composition-pattern.template.md` for composed structures such as date picker, calendar grid, form row, search field, filter group, and picker templates.
- `templates/product-pattern.template.md` for domain-specific flows such as flight search, passenger selector, booking summary, price display, travel card, and commerce patterns.

Agents must preserve the section order from `schemas/pattern.schema.md` unless a section is explicitly not applicable. If a pattern spec is incomplete, the agent must add an `Open Questions` section instead of inventing missing rules.

Operational pattern specs must define structure, ownership, minimum component API, state semantics, token slot matrix, positive tests, negative tests, documentation requirements, anti-patterns, and open questions. Any behavior described with conditional language must be classified as required, optional, out of scope, or an open question.

## Relationships

Pattern specs relate to other UI Foundations concerns as follows:

- Standards: provide native, WAI-ARIA, and WCAG requirements that cannot be weakened by local design choices.
- Components: implement one or more pattern specs and can add API details that remain consistent with the pattern.
- Tokens: provide semantic slots for visual expression without changing semantics or behavior.
- Tests: verify keyboard behavior, accessibility, states, token use, and component contract compliance.
- Documentation: explains consumer-facing usage without becoming the source for lower-level semantic rules.

## Current Structure

- `base/`: base pattern specs for native or near-native primitives.
- `composition/`: composed pattern specs built from base patterns.
- `product/`: domain-specific pattern specs.
- `templates/`: reusable authoring templates.
- `schemas/`: markdown authoring schema for pattern specs.
- `maps/`: lookup maps connecting pilot patterns to components, tokens, and standards.
