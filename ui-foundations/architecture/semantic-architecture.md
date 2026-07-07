---
id: specification.ui-foundations.semantic-architecture
title: Semantic Architecture
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines why UI Foundations separates semantic meaning from local surfaces.
related:
  references:
    - principle.foundation.color-theory
    - principle.foundation.typography
    - specification.ui-foundations.token-architecture
    - specification.ui-foundations.semantic-tokens
---

# Semantic Architecture

## Question

Why are semantic tokens separated from implementation?

## Purpose

Semantic architecture preserves meaning across themes, modes, patterns, and components without binding that meaning to one local surface.

## Core Concepts

- Semantics name purpose, not appearance.
- Semantic roles stay stable while values may change.
- Status meaning is global.
- Interaction state is local.
- Typography structure and text color remain separate decisions.

## Architecture

Semantic roles sit between contextual interpretation and local use. They translate foundational design meaning into stable project vocabulary.

A semantic role should answer what something means. It should not answer where it appears, how it is rendered, or which component currently uses it.

## Relationships

Color theory supplies the principle that color communicates meaning. Typography supplies the principle that text style communicates structure. Semantic architecture keeps those meanings available without duplicating them in each local surface.

## Related Documents

- `principle.foundation.color-theory`
- `principle.foundation.typography`
- `specification.ui-foundations.token-architecture`
- `specification.ui-foundations.semantic-tokens`

