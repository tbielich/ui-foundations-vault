---
id: specification.capability.design-reasoning
title: Design Reasoning
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines the capability to reason about design decisions.
related:
  references:
    - principle.foundation.design-intelligence
    - principle.foundation.design-principles
    - workflow.operational.architecture-review
---

# Design Reasoning

## Question

What does it mean to reason about design decisions?

## Purpose

Design reasoning makes design choices explicit by connecting goals, users, context, constraints, principles, tradeoffs, and consequences.

## Inputs

- Design decision or decision space
- Goal and user context
- Constraints
- Options or alternatives
- Known risks and assumptions

## Required Knowledge

- Design intelligence
- Design principles
- Relevant UI Foundations architecture knowledge
- Precedence and verification expectations

## Reasoning Method

1. Frame the decision by goal, user, context, and constraints.
2. Identify options and the assumptions behind them.
3. Evaluate each option against relevant principles and system knowledge.
4. Make tradeoffs visible.
5. Identify the decisive factor.
6. State what should be monitored or revisited.

## Outputs

- Structured decision framing
- Option comparison
- Tradeoff summary
- Recommendation when evidence supports one
- Risks and revisit triggers

## Quality Gates

- Reasoning separates facts, assumptions, and judgment.
- Recommendation follows from the stated criteria.
- The decision does not override higher-precedence vault knowledge.

## Related Documents

- `principle.foundation.design-intelligence`
- `principle.foundation.design-principles`
- `workflow.operational.architecture-review`

