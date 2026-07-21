---
id: index.patterns.base
title: Base Patterns
type: index
status: stable
owners:
  - ui-foundations
created: 2026-07-21
updated: 2026-07-21
authority: supporting
summary: Scope and inclusion rules for base patterns in the UI Foundations pattern library.
---

# Base Patterns

Base patterns describe the smallest reusable interaction and semantic building blocks.

They are implementation-independent contracts that components can implement directly or compose with other base patterns.

## What Belongs in Base Patterns

- A single, reusable interaction concept
- A single, reusable semantic responsibility
- Stable keyboard, focus, and accessibility expectations
- Stable state model and token expectations
- Clear ownership boundary that does not require orchestration across multiple independent patterns

## Inclusion Criteria

A candidate belongs in `patterns/base/` when it:

1. Represents one reusable building block.
2. Can be described without framework-specific implementation details.
3. Has stable semantic and interaction responsibilities.
4. Does not require cross-pattern orchestration to be meaningful.

Use the canonical `Pattern Classification Checklist` in `reference/pattern-taxonomy.md` before adding a new base pattern.

## What Should Not Be Added

- Multi-part flows that coordinate several base building blocks
- Page-level or workflow-level structures
- Runtime-implementation specifics, APIs, or framework code
- Pattern proposals that only make sense as component-specific convenience features

## Relationship to Composition Patterns

Composition patterns combine multiple base patterns into reusable interaction solutions.

If a concept depends on coordinated ownership across multiple base responsibilities (for example field + trigger + popup + calendar-grid behavior), it belongs in `patterns/composition/`, not `patterns/base/`.
