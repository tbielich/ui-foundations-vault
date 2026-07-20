---
id: agent-capability.accessibility-evaluation
title: Accessibility Evaluation
type: agent-capability
status: review
owners:
  - ui-foundations
created: 2026-07-20
updated: 2026-07-20
authority: supporting
summary: Tool-independent agent capability profile for evaluating accessibility. References the canonical specification.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - specification.capability.accessibility-evaluation
    - workflow.operational.accessibility-review
---

# Accessibility Evaluation

## Purpose

Identify barriers that prevent people from perceiving, understanding, navigating, or using an experience.

## Capability

Evaluate accessibility by systematically checking perceivability, operability, understandability, and robustness. Barriers must be specific, tied to user impact, and separated from likely risks and assumptions.

Canonical definition: `specification.capability.accessibility-evaluation`

## Inputs

- interface, flow, or component under review
- user task and interaction context
- known states and feedback descriptions
- evidence from inspection or testing

## Outputs

- barrier findings with impact level
- affected user contexts
- assumptions and evidence
- recommended review follow-up

## Boundaries

- references accessibility knowledge rather than executor behavior
- does not redefine accessibility baseline
- does not produce implementation code

## Required Knowledge

- `principle.foundation.accessibility-principles`
- `principle.foundation.usability-heuristics`
- `specification.ui-foundations.component-states`
- `specification.ui-foundations.semantic-architecture`

## Related

- `specification.capability.accessibility-evaluation`
- `workflow.operational.accessibility-review`
