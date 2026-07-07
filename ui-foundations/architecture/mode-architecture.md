---
id: specification.ui-foundations.mode-architecture
title: Mode Architecture
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines how UI Foundations represents contextual variations such as appearance or density.
related:
  references:
    - principle.foundation.accessibility-principles
    - principle.foundation.color-theory
    - specification.ui-foundations.token-architecture
    - specification.ui-foundations.mode-tokens
---

# Mode Architecture

## Question

How are contextual variations represented?

## Purpose

Mode architecture lets UI Foundations adapt to context while keeping activation policy separate from the token definitions themselves.

## Core Concepts

- A mode represents contextual variation.
- Modes can affect appearance, density, contrast, or other environmental decisions.
- Mode definitions should be reusable.
- Mode activation belongs to the consuming context.
- Modes should preserve semantic meaning across variation.

## Architecture

Modes sit above core values and below brand and semantic interpretation. They adapt foundational values to a context without deciding when that context is active.

This separation lets the same knowledge support multiple consuming products with different policies.

## Relationships

Accessibility principles shape mode expectations for contrast, perception, and user preference. Color theory shapes how appearance changes remain meaningful rather than decorative.

## Related Documents

- `principle.foundation.accessibility-principles`
- `principle.foundation.color-theory`
- `specification.ui-foundations.token-architecture`
- `specification.ui-foundations.mode-tokens`

