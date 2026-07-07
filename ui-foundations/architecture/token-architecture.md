---
id: specification.ui-foundations.token-architecture
title: Token Architecture
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines how UI Foundations organizes design decisions into token layers.
related:
  references:
    - principle.foundation.design-principles
    - principle.foundation.color-theory
    - principle.foundation.typography
    - specification.ui-foundations.semantic-architecture
    - specification.ui-foundations.theme-architecture
    - specification.ui-foundations.mode-architecture
---

# Token Architecture

## Question

How are design tokens organised?

## Purpose

Token architecture gives UI Foundations a stable way to separate raw values, contextual decisions, semantic meaning, and reusable interface surfaces.

## Core Concepts

- Core tokens hold primitive values.
- Mode tokens represent contextual variation.
- Theme tokens represent brand-level interpretation.
- Semantic tokens name reusable meaning.
- Pattern and component tokens express local surface decisions.
- References move from specific decisions toward more foundational layers.

## Architecture

UI Foundations uses layered token reasoning:

1. Core defines raw material.
2. Modes adapt raw material to context.
3. Themes interpret meaning for a brand.
4. Semantics expose stable roles.
5. Patterns and components consume roles for local needs.

Local tokens should not recreate global meaning. Global tokens should not encode local behavior.

## Relationships

Design principles shape what the token system must preserve: clarity, consistency, contrast, and intentionality. Color and typography foundations define the kinds of meaning that tokens must keep separate.

## Related Documents

- `principle.foundation.design-principles`
- `principle.foundation.color-theory`
- `principle.foundation.typography`
- `specification.ui-foundations.semantic-architecture`
- `specification.ui-foundations.theme-architecture`
- `specification.ui-foundations.mode-architecture`

