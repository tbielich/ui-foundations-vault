---
id: specification.ui-foundations.pattern-selection
title: Pattern Selection
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines when a pattern should be used in UI Foundations.
related:
  references:
    - principle.foundation.design-intelligence
    - principle.foundation.usability-heuristics
    - specification.ui-foundations.pattern-model
    - specification.ui-foundations.component-lifecycle
---

# Pattern Selection

## Question

When should a pattern be used?

## Purpose

Pattern selection helps UI Foundations choose reusable composition knowledge before creating or changing component-level system surface.

## Core Concepts

- Use a pattern when the problem recurs.
- Use a pattern when composition intent matters more than a single component.
- Use a pattern when multiple components share the same design rationale.
- Avoid a pattern when the case is local, temporary, or too specific.
- Promote pattern knowledge when it improves consistency and decision quality.

## Architecture

Pattern selection sits before component promotion. It tests whether a need is best handled as reusable composition guidance, an existing component arrangement, or a new component boundary.

The selection decision should preserve the smallest useful system surface.

## Relationships

Design intelligence supplies the reasoning order. Usability heuristics identify interaction risks. Pattern model defines what qualifies as reusable composition knowledge.

## Related Documents

- `principle.foundation.design-intelligence`
- `principle.foundation.usability-heuristics`
- `specification.ui-foundations.pattern-model`
- `specification.ui-foundations.component-lifecycle`

