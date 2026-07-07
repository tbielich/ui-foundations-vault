---
id: specification.capability.design-evaluation
title: Design Evaluation
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines the capability to evaluate design quality.
related:
  references:
    - principle.foundation.design-principles
    - principle.foundation.gestalt-principles
    - principle.foundation.usability-heuristics
    - principle.foundation.visual-hierarchy
    - workflow.operational.component-review
---

# Design Evaluation

## Question

What does it mean to evaluate design quality?

## Purpose

Design evaluation determines whether an interface is clear, usable, coherent, appropriately structured, and aligned with the design intent.

## Inputs

- Design artifact or description
- User goal and task context
- Known constraints
- Relevant principles and heuristics
- Evidence of current behavior or expected use

## Required Knowledge

- Design principles
- Gestalt principles
- Usability heuristics
- Visual hierarchy
- Component and pattern knowledge when reviewing UI Foundations work

## Reasoning Method

1. Identify the goal, user, context, and constraints.
2. Evaluate perceptual structure using Gestalt principles.
3. Evaluate usability using heuristics.
4. Evaluate hierarchy, density, clarity, rhythm, and attention.
5. Separate confirmed issues from assumptions.
6. Rank findings by impact on understanding and use.

## Outputs

- Design quality assessment
- Strengths and weaknesses
- Prioritized issues
- Evidence and assumptions
- Open questions

## Quality Gates

- Findings cite the principle or heuristic they rely on.
- The assessment distinguishes design quality from implementation detail.
- The output does not redesign the artifact unless a separate capability requires it.

## Related Documents

- `principle.foundation.design-principles`
- `principle.foundation.gestalt-principles`
- `principle.foundation.usability-heuristics`
- `principle.foundation.visual-hierarchy`
- `workflow.operational.component-review`

