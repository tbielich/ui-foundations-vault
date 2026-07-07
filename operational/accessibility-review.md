---
id: workflow.operational.accessibility-review
title: Accessibility Review
type: workflow
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: supporting
summary: Describes how to review accessibility using existing foundation and UI Foundations knowledge.
related:
  references:
    - principle.foundation.accessibility-principles
    - principle.foundation.usability-heuristics
    - specification.ui-foundations.component-states
    - specification.ui-foundations.semantic-architecture
---

# Accessibility Review

## Question

How should accessibility be reviewed?

## Purpose

Use this playbook to evaluate whether an experience remains perceivable, operable, understandable, robust, and recoverable.

## Inputs

- Experience or component under review
- Intended user task
- Known states, errors, and feedback
- Relevant content and interaction context
- Available evidence

## Preconditions

- The review scope is clear.
- The intended task and user context are known.
- Relevant accessibility and usability foundation documents are available.

## Steps

1. Identify the task, user context, and required interaction.
2. Review perceivability of information, controls, state, and feedback.
3. Review operability across expected input methods.
4. Review clarity of labels, instructions, errors, and recovery paths.
5. Review robustness of meaning across presentation changes.
6. Check that color, state, and status do not carry meaning alone.
7. Record findings by impact and required follow-up.

## Outputs

- Accessibility findings
- Impact assessment
- Assumptions and evidence
- Required revisions
- Follow-up questions

## Quality Gates

- Meaning is available through more than one cue when needed.
- State and feedback are perceivable.
- Recovery from error is understandable.
- Accessibility findings cite existing foundation or UI Foundations knowledge.

## Related Documents

- `principle.foundation.accessibility-principles`
- `principle.foundation.usability-heuristics`
- `specification.ui-foundations.component-states`
- `specification.ui-foundations.semantic-architecture`

