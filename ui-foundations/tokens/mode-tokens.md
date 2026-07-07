---
id: specification.ui-foundations.mode-tokens
title: Mode Tokens
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines the role of contextual variation tokens in UI Foundations.
related:
  references:
    - principle.foundation.accessibility-principles
    - principle.foundation.color-theory
    - specification.ui-foundations.mode-architecture
---

# Mode Tokens

## Question

How should contextual variation become reusable knowledge?

## Purpose

Mode tokens capture contextual variation without deciding when or why a consuming experience activates that variation.

## Core Concepts

- Mode tokens represent context.
- Mode tokens should preserve semantic meaning.
- Mode tokens can support appearance, density, contrast, or other environmental adaptations.
- Mode definitions should be reusable across consuming experiences.
- Mode policy should remain outside token definition.

## Architecture

Mode tokens sit between core values and higher-level interpretation. They adapt raw material to a context while preserving the same conceptual roles above them.

A mode should describe variation. It should not prescribe product behavior.

## Relationships

Accessibility principles shape the need for adaptable experiences. Color theory shapes how variation preserves meaning and contrast.

## Related Documents

- `principle.foundation.accessibility-principles`
- `principle.foundation.color-theory`
- `specification.ui-foundations.mode-architecture`

