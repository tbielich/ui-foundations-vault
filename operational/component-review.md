---
id: workflow.operational.component-review
title: Component Review
type: workflow
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: supporting
summary: Describes how to review a component against existing UI Foundations knowledge.
related:
  references:
    - specification.ui-foundations.component-model
    - specification.ui-foundations.component-composition
    - specification.ui-foundations.component-states
    - specification.ui-foundations.pattern-selection
    - principle.foundation.usability-heuristics
---

# Component Review

## Question

How should a component be reviewed?

## Purpose

Use this playbook to evaluate whether a component has a clear responsibility, appropriate boundary, usable states, and justified system value.

## Inputs

- Component proposal or existing component description
- Intended user need
- Known states and responsibilities
- Relevant pattern and token knowledge
- Evidence of repeated need

## Preconditions

- The component topic has a defined purpose.
- Existing patterns and components have been checked.
- Relevant foundation and UI Foundations documents are available.

## Steps

1. Identify the user need and recurring problem.
2. Check whether pattern selection resolves the need without a new component boundary.
3. Review the component responsibility against the component model.
4. Review composition for unnecessary structural complexity.
5. Review state handling against component state knowledge and usability heuristics.
6. Identify token and semantic dependencies without designing new tokens.
7. Record findings as accept, revise, defer, or reject.

## Outputs

- Review recommendation
- Boundary rationale
- State and composition findings
- Open questions
- Follow-up documents to update

## Quality Gates

- The component has distinct responsibility.
- The need is reusable beyond one local case.
- State and status are not confused.
- Composition is no more complex than the need requires.
- Findings reference existing knowledge.

## Related Documents

- `specification.ui-foundations.component-model`
- `specification.ui-foundations.component-composition`
- `specification.ui-foundations.component-states`
- `specification.ui-foundations.pattern-selection`
- `principle.foundation.usability-heuristics`

