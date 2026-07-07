---
id: workflow.component-review
title: Component Review Workflow
type: workflow
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines a repeatable review workflow for UI Foundations component proposals.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  depends_on:
    - principle.foundation.design-intelligence
    - governance.verification-review
---

# Component Review Workflow

Use this workflow to review a UI Foundations component proposal or change.

## Inputs

- Component name
- Intended user need
- Relevant principles
- Existing specifications or decisions
- Proposed API, anatomy, states, and behavior
- Visual evidence when available

## Steps

1. Confirm the component belongs in UI Foundations.
2. Check whether an existing component, pattern, or token already solves the need.
3. Review anatomy, variants, states, accessibility expectations, and responsive behavior.
4. Verify that naming is consistent with existing vocabulary.
5. Identify implementation impact for `ui-foundations`.
6. Record any durable choice as a decision.
7. Capture reusable rules in a specification.

## Output

The review should produce:

- Recommendation: accept, revise, defer, or reject
- Key rationale
- Required changes
- Open questions
- Follow-up documents to create or update
