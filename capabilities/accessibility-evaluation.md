---
id: specification.capability.accessibility-evaluation
title: Accessibility Evaluation
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines the capability to evaluate accessibility.
related:
  references:
    - principle.foundation.accessibility-principles
    - principle.foundation.usability-heuristics
    - specification.ui-foundations.component-states
    - workflow.operational.accessibility-review
---

# Accessibility Evaluation

## Question

What does it mean to evaluate accessibility?

## Purpose

Accessibility evaluation identifies barriers that prevent people from perceiving, understanding, navigating, or using an experience.

## Inputs

- Interface, flow, or component under review
- User task and context
- Known states and feedback
- Content and interaction description
- Evidence from inspection or testing

## Required Knowledge

- Accessibility principles
- Usability heuristics
- Component state knowledge
- Semantic architecture where meaning and state are involved

## Reasoning Method

1. Identify the task and expected interaction.
2. Check perceivability of information and feedback.
3. Check operability across input and navigation modes.
4. Check understandable language, structure, state, and recovery.
5. Check robustness of meaning across presentation changes.
6. Prioritize barriers by task impact.

## Outputs

- Barrier findings
- Affected user contexts
- Impact level
- Evidence and assumptions
- Recommended review follow-up

## Quality Gates

- Barriers are specific and tied to user impact.
- Confirmed barriers are separated from likely risks.
- Findings reference accessibility knowledge rather than executor behavior.

## Related Documents

- `principle.foundation.accessibility-principles`
- `principle.foundation.usability-heuristics`
- `specification.ui-foundations.component-states`
- `workflow.operational.accessibility-review`
