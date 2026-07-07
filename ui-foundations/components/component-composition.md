---
id: specification.ui-foundations.component-composition
title: Component Composition
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines how components should be composed without unnecessary structural complexity.
related:
  references:
    - principle.foundation.gestalt-principles
    - principle.foundation.information-architecture
    - specification.ui-foundations.component-model
---

# Component Composition

## Question

How should components be composed?

## Purpose

Component composition keeps component structure understandable while allowing complexity when it solves a real problem.

## Core Concepts

- Start with the simplest structure that preserves meaning.
- Add structure only for real layout, behavior, accessibility, or state needs.
- Composition should make relationships clearer.
- Optional composition should not become default complexity.
- A component should remain obvious to use and reason about.

## Architecture

Composition is a boundary between local structure and reusable system surface. UI Foundations favors minimal composition until a recurring need justifies a stronger abstraction.

Structural complexity must carry meaning or behavior. Otherwise it becomes maintenance burden.

## Relationships

Gestalt principles explain why grouping matters. Information architecture explains how structure supports understanding. The component model defines when composition becomes a component concern.

## Related Documents

- `principle.foundation.gestalt-principles`
- `principle.foundation.information-architecture`
- `specification.ui-foundations.component-model`

