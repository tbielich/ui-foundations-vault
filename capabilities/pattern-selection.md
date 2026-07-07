---
id: specification.capability.pattern-selection
title: Pattern Selection
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines the capability to select an appropriate pattern.
related:
  references:
    - principle.foundation.design-intelligence
    - principle.foundation.usability-heuristics
    - specification.ui-foundations.pattern-model
    - specification.ui-foundations.pattern-selection
    - reference.pattern-taxonomy
---

# Pattern Selection

## Question

What does it mean to select an appropriate pattern?

## Purpose

Pattern selection determines which reusable composition intent best fits a recurring interface problem.

## Inputs

- User problem or task
- Context and constraints
- Candidate patterns
- Relevant components and tokens
- Evidence of recurrence

## Required Knowledge

- Design intelligence
- Usability heuristics
- Pattern model
- Pattern taxonomy
- Component lifecycle where promotion is considered

## Reasoning Method

1. Define the recurring problem.
2. Identify the user need and context.
3. Compare candidate patterns by fit and intent.
4. Check whether an existing component or pattern already covers the need.
5. Identify when a component boundary is more appropriate.
6. Record the selected pattern and rationale.

## Outputs

- Selected pattern or no-pattern recommendation
- Fit rationale
- Alternatives considered
- Boundary risks
- Follow-up questions

## Quality Gates

- Selection is based on problem fit, not surface similarity alone.
- The pattern protects a clear design or usability intent.
- The recommendation does not create a new component by default.

## Related Documents

- `principle.foundation.design-intelligence`
- `principle.foundation.usability-heuristics`
- `specification.ui-foundations.pattern-model`
- `specification.ui-foundations.pattern-selection`
- `reference.pattern-taxonomy`

