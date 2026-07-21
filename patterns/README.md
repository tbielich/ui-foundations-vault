---
id: index.patterns
title: Patterns
type: index
status: stable
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-21
authority: supporting
summary: Entry point for agent-readable UI pattern specifications.
---

# Patterns

This directory contains the canonical UI Foundations pattern library. Pattern specs translate standards, design intent, and platform behavior into reusable contracts that components implement.

## Canonical Principle

Patterns describe reusable interaction and semantic concepts.

Components implement one or more patterns.

## Canonical Hierarchy

- **Base patterns**: smallest reusable interaction and semantic building blocks.
- **Composition patterns**: reusable interaction solutions composed from multiple base patterns.
- **Experience patterns**: reusable workflow or page-level structures composed from multiple compositions and components.

For classification decisions, use the canonical checklist in `reference/pattern-taxonomy.md` (`Pattern Classification Checklist` section).

## Source Boundaries

The UI Foundations runtime repository contains human-facing and implementation-facing pattern documentation:

- `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/docs/patterns`
- Supporting generated/site documentation can live under `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-runtime/site`

The vault contains agent-readable pattern specifications:

- `/Users/Thomas.Bielich@tui.com/GitHub/uif/ui-foundations-vault/patterns`

Vault pattern specs must not duplicate product documentation 1:1. Human-facing docs explain usage for designers and consumers. Vault specs define the reusable contract agents need to preserve semantics, accessibility, token expectations, implementation boundaries, and test obligations.

## Pattern Library Model

```txt
Principles
↓
Patterns
↓
Components
↓
Implementations
```

Principles define durable intent. Patterns define reusable contracts. Components implement those contracts. Implementations realize components in runtime systems.

## Conflict Resolution

When guidance conflicts, apply this order:

1. Native HTML behaviour wins.
2. WAI-ARIA and WCAG requirements win.
3. UIF Base Patterns concretize standards.
4. Component specs implement the pattern.
5. Visual design variants must not break semantics.

## Implementation Naming Governance

`Implementation Naming Contract` is the canonical pattern-level section for CSS class naming, token scoping, data-attribute usage, native and ARIA precedence, and agent freedom boundaries.

Pattern specs use `.uif-*` classes as the public styling scope and `--uif-*` CSS custom properties as the token scope. Data attributes remain secondary metadata or state hooks and must not replace native HTML semantics, required ARIA semantics, public component classes, or token conventions. The schema defines the full reusable contract.

## Using Templates

Agents must start new pattern specs from the closest template:

- `templates/base-pattern.template.md` for standard-native primitives such as button, link, input, checkbox, radio, select, textarea, dialog, and disclosure.
- `templates/composition-pattern.template.md` for composed structures such as date picker, calendar grid, form row, search field, filter group, and picker templates.
- `templates/product-pattern.template.md` for domain-specific flows such as flight search, passenger selector, booking summary, price display, travel card, and commerce patterns.

Agents must preserve the section order from `schemas/pattern.schema.md` unless a section is explicitly not applicable. If a pattern spec is incomplete, the agent must add an `Open Questions` section instead of inventing missing rules.

Operational pattern specs must define structure, implementation naming, ownership, minimum component API, state semantics, token slot matrix, positive tests, negative tests, documentation requirements, anti-patterns, and open questions. Any behavior described with conditional language must be classified as required, optional, out of scope, or an open question.

Before deriving implementation output from a pattern spec, review it against `patterns/checklists/pattern-spec-review-checklist.md`.

## Relationships

Pattern specs relate to other UI Foundations concerns as follows:

- Standards: provide native, WAI-ARIA, and WCAG requirements that cannot be weakened by local design choices.
- Components: implement one or more pattern specs and can add API details that remain consistent with pattern contracts.
- Tokens: provide semantic slots for visual expression of patterns and components without changing semantics or behavior.
- Runtime: exposes components that realize pattern contracts in code.
- Tests: verify keyboard behavior, accessibility, states, token use, and component contract compliance.
- Documentation: explains consumer-facing usage without becoming the source for lower-level semantic rules.

## Current Structure

- `base/`: base pattern specs for native or near-native primitives.
- `composition/`: composed pattern specs built from base patterns.
- `product/`: domain-specific pattern specs.
- `templates/`: reusable authoring templates.
- `schemas/`: markdown authoring schema for pattern specs.
- `checklists/`: lightweight review checklists for pattern specs.
- `maps/`: lookup maps connecting pilot patterns to components, tokens, and standards.
