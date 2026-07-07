---
id: specification.ui-foundations.semantic-tokens
title: Semantic Tokens
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines the role of semantic tokens in UI Foundations.
related:
  references:
    - principle.foundation.color-theory
    - principle.foundation.typography
    - specification.ui-foundations.semantic-architecture
---

# Semantic Tokens

## Question

What meaning should tokens expose?

## Purpose

Semantic tokens expose stable design meaning so that local surfaces do not need to know raw values or brand-specific interpretation.

## Core Concepts

- Semantic tokens name roles.
- Semantic tokens preserve meaning across themes and modes.
- Semantic tokens separate meaning from local presentation.
- Semantic tokens should be shared when the meaning is shared.
- Semantic tokens should not encode component-specific behavior.

## Architecture

Semantic tokens form the project vocabulary for reusable visual meaning. They sit above core, mode, and theme decisions, and below pattern or component decisions.

When a decision represents general meaning, it belongs in semantics. When it represents local behavior, it belongs closer to the local surface.

## Relationships

Color theory and typography foundations define how meaning can be communicated. Semantic architecture defines why that meaning is separated from local implementation.

## Related Documents

- `principle.foundation.color-theory`
- `principle.foundation.typography`
- `specification.ui-foundations.semantic-architecture`

