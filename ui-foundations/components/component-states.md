---
id: specification.ui-foundations.component-states
title: Component States
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines how UI Foundations understands component state.
related:
  references:
    - principle.foundation.usability-heuristics
    - principle.foundation.accessibility-principles
    - specification.ui-foundations.semantic-architecture
    - specification.ui-foundations.component-model
---

# Component States

## Question

How should component state be represented?

## Purpose

Component state describes temporary condition, interaction, or availability without confusing it with global semantic meaning.

## Core Concepts

- State is local to interaction or component condition.
- Status is global semantic meaning.
- State should be perceivable and understandable.
- State should not rely on one visual cue.
- Repeated states should be named and treated consistently.
- State should preserve accessibility and recoverability.

## Architecture

Component states live at the component level because they describe behavior or condition in context. They may use semantic tokens for expression, but they should not create new global meaning.

Separating state from status keeps local interaction behavior from polluting the semantic layer.

## Relationships

Usability heuristics define feedback, control, and error prevention. Accessibility principles define perceivable and operable state communication. Semantic architecture defines the boundary between global meaning and local state.

## Related Documents

- `principle.foundation.usability-heuristics`
- `principle.foundation.accessibility-principles`
- `specification.ui-foundations.semantic-architecture`
- `specification.ui-foundations.component-model`

