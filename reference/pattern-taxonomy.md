---
id: reference.pattern-taxonomy
title: Pattern Taxonomy
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-21
authority: source
summary: Defines the canonical pattern hierarchy and classification concepts used in UI Foundations knowledge.
related:
  references:
    - principle.foundation.design-principles
    - principle.foundation.information-architecture
    - specification.ui-foundations.pattern-model
    - specification.ui-foundations.pattern-selection
---

# Pattern Taxonomy

## Question

How are pattern concepts classified?

## Purpose

This document defines the canonical hierarchy for patterns and provides lookup categories for pattern concepts in UI Foundations.

## Core Principle

Patterns describe reusable interaction and semantic concepts.

Components implement one or more patterns.

## Canonical Hierarchy

### Level 1 — Base Patterns

Base patterns describe the smallest reusable interaction and semantic building blocks.

Typical examples include input, button, checkbox, radio, switch, label, link, icon, tooltip, tabs, accordion, avatar, badge, divider, and calendar.

### Level 2 — Composition Patterns

Composition patterns combine multiple base patterns into reusable interaction solutions.

Typical examples include date picker and other multi-part interaction constructs that coordinate multiple base responsibilities.

### Level 3 — Experience Patterns

Experience patterns describe reusable workflows or page-level structures rather than reusable UI elements.

Typical examples include checkout, booking flow, authentication, search results, product detail, and dashboard experiences.

## Classification Rules

- A pattern is **Base** when it can stand as an implementation-independent semantic and interaction contract for a single building block.
- A pattern is **Composition** when it coordinates multiple base patterns and defines their ownership boundaries.
- A pattern is **Experience** when it defines reusable workflow structure across multiple compositions and components.
- A component must not redefine pattern semantics; it implements and composes them.
- Tokens express visual values for patterns and components, but do not change semantic intent.

## Pattern Classification Checklist

Use this checklist when deciding whether a new concept belongs in Base, Composition, Experience, or runtime documentation.

### Step 1 — Identify the Concept

Determine whether the proposal describes:

- A reusable interaction concept
- A reusable UI solution
- A complete user workflow

### Step 2 — Can it Stand Alone?

Ask:

- Can this concept exist independently?
- Does it provide value without depending on another pattern?

If no, continue to composition checks.

### Step 3 — Does it Define Core Semantics?

Ask:

- Does it define its own semantic meaning?
- Does it own an interaction model?
- Does it have accessibility responsibilities?
- Could multiple components implement it?

If mostly yes, classify as **Base Pattern**.

### Step 4 — Is it Implementation-Independent?

Ask:

- Can it be described without framework-specific details?
- Without CSS selectors or runtime-specific APIs?
- Without implementation-specific element wiring?

If yes, it belongs in the pattern library.  
If no, it likely belongs in runtime documentation.

### Step 5 — Does it Combine Multiple Base Patterns?

Ask:

- Does it coordinate multiple Base Patterns into a reusable solution?

If yes, classify as **Composition Pattern**.

### Step 6 — Does it Describe a Complete User Journey?

Ask:

- Does it represent an end-to-end workflow or page-level experience?

If yes, classify as **Experience Pattern**.

### Step 7 — Final Validation

Before introducing a new pattern, verify:

- Does an existing pattern already cover this concept?
- Could this be documented as a variant instead?
- Is it actually a component?
- Is it only an implementation detail?
- Is it primarily a visual variation rather than a semantic concept?

If any answer is yes, reconsider creating a new pattern.

### Decision Matrix

| Question | Yes | No |
|---|---|---|
| Defines its own reusable semantic contract? | Base Pattern | Continue |
| Coordinates multiple Base Patterns? | Composition Pattern | Continue |
| Describes an end-to-end workflow? | Experience Pattern | Continue |
| Is implementation-specific? | Runtime documentation | Pattern library |
| Is only a visual variation? | Variant of existing pattern | New pattern may be justified |

### Classification Examples

| Concept | Classification | Reason |
|---|---|---|
| Button | Base Pattern | Independent semantic interaction. |
| Input | Base Pattern | Shared single-control interaction contract. |
| Calendar | Base Pattern | Independent interaction model with its own accessibility and state semantics. |
| Checkbox | Base Pattern | Independent semantic control. |
| Date Picker | Composition Pattern | Coordinates input, calendar, trigger, and validation concerns. |
| Search Field | Composition Pattern | Coordinates input, icon, and optional action affordances. |
| Login Form | Composition Pattern | Coordinates multiple base patterns as one reusable UI solution. |
| Checkout | Experience Pattern | Complete user workflow crossing multiple compositions. |

### Guiding Principle

Patterns describe concepts. Components implement patterns. Experiences orchestrate patterns into complete user journeys.

When classification is unclear, this principle takes precedence.

## Classes

- Pattern: reusable interaction and semantic intent for a recurring interface problem.
- Pattern problem: the recurring need or user situation a pattern addresses.
- Pattern intent: the design purpose a pattern protects.
- Pattern selection: the choice to apply pattern knowledge to a situation.
- Pattern boundary: the line between general composition guidance and component ownership.
- Pattern participant: a component, token, or content element that contributes to a pattern.
- Pattern evidence: the recurring use, principle, or heuristic that justifies a pattern.
- Pattern fit: the degree to which a pattern matches the problem, context, and user need.

## Relationships

- Principles define durable design intent and reasoning boundaries.
- Patterns operationalize principles into reusable contracts.
- Components implement and compose pattern contracts.
- Implementations realize components in runtime code.

## Related Documents

- `principle.foundation.design-principles`
- `principle.foundation.information-architecture`
- `specification.ui-foundations.pattern-model`
- `specification.ui-foundations.pattern-selection`
