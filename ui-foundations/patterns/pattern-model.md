---
id: specification.ui-foundations.pattern-model
title: Pattern Model
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines what a pattern is in UI Foundations.
related:
  references:
    - principle.foundation.design-principles
    - principle.foundation.usability-heuristics
    - principle.foundation.information-architecture
    - specification.ui-foundations.component-model
---

# Pattern Model

## Question

What is a pattern?

## Purpose

The pattern model describes reusable composition intent that sits between immutable design knowledge and component-level system units.

## Core Concepts

- A pattern solves a recurring interface problem.
- A pattern describes composition intent.
- A pattern can be implemented by one or more components.
- A pattern should cite the principles or heuristics it serves.
- A pattern should not introduce behavior that belongs to a component lifecycle.

## Architecture

Patterns translate foundational design knowledge into reusable project-specific structures. They are more concrete than principles and less bound than components.

A pattern should describe when a structure is useful and what quality it protects.

## Relationships

Design principles and usability heuristics supply the quality basis for patterns. Information architecture supplies grouping and wayfinding logic. Components may implement or participate in patterns.

## Related Documents

- `principle.foundation.design-principles`
- `principle.foundation.usability-heuristics`
- `principle.foundation.information-architecture`
- `specification.ui-foundations.component-model`

