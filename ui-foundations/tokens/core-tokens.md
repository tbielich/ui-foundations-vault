---
id: specification.ui-foundations.core-tokens
title: Core Tokens
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines the role of primitive tokens in UI Foundations.
related:
  references:
    - principle.foundation.typography
    - principle.foundation.color-theory
    - specification.ui-foundations.token-architecture
---

# Core Tokens

## Question

What belongs at the primitive token layer?

## Purpose

Core tokens provide raw, reusable material for the rest of the UI Foundations token system.

## Core Concepts

- Core tokens are primitive.
- Core tokens do not carry product or component meaning.
- Core tokens should be stable and reusable.
- Core tokens may describe dimensions, color sources, type foundations, spacing, layering, and motion foundations.
- Higher layers give core values meaning.

## Architecture

Core tokens are the base layer. They should not depend on theme, mode, semantic, pattern, or component decisions.

A value belongs in core when it is useful as raw material across multiple meanings.

## Relationships

Typography and color foundations define the kinds of raw material the system needs. Token architecture defines how core values flow upward into more meaningful layers.

## Related Documents

- `principle.foundation.typography`
- `principle.foundation.color-theory`
- `specification.ui-foundations.token-architecture`

