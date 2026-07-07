---
id: specification.ui-foundations.component-lifecycle
title: Component Lifecycle
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines how components mature inside UI Foundations.
related:
  references:
    - governance.lifecycle
    - specification.ui-foundations.component-model
    - specification.ui-foundations.pattern-selection
---

# Component Lifecycle

## Question

How should components mature?

## Purpose

Component lifecycle keeps UI Foundations components from entering the system before their responsibility, reuse value, and ownership are clear.

## Core Concepts

- A component begins as a recurring need.
- A component should be evaluated against existing patterns and components.
- A component should mature through review before becoming stable.
- A component can be revised, deprecated, or archived.
- Lifecycle changes should preserve continuity for consumers.

## Architecture

Component lifecycle applies the vault lifecycle to reusable UI units. It starts with need discovery, moves through boundary review, and matures only when the component has stable purpose and reusable value.

The lifecycle should prevent one-off solutions from becoming permanent system surface.

## Relationships

Vault lifecycle defines maturity. Pattern selection decides whether a need belongs below component level. Component model defines the boundary for promotion.

## Related Documents

- `governance.lifecycle`
- `specification.ui-foundations.component-model`
- `specification.ui-foundations.pattern-selection`

