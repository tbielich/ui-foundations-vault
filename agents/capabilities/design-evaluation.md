---
id: agent-capability.design-evaluation
title: Design Evaluation
type: agent-capability
status: review
owners:
  - ui-foundations
created: 2026-07-20
updated: 2026-07-20
authority: supporting
summary: Tool-independent agent capability profile for evaluating design quality. References the canonical specification.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - specification.capability.design-evaluation
    - workflow.operational.component-review
    - workflow.component-review
---

# Design Evaluation

## Purpose

Evaluate design quality against vault source knowledge, producing traceable findings and a clear recommendation.

## Capability

Conduct structured design evaluation using Gestalt principles, usability heuristics, visual hierarchy, and component/pattern knowledge. Findings must cite the principle or heuristic they depend on.

Canonical definition: `specification.capability.design-evaluation`

## Inputs

- design artifact, proposal, or description
- user goal and task context
- known constraints and evidence
- related principles, patterns, and specifications

## Outputs

- design quality assessment
- strengths and weaknesses
- prioritized issues with source citations
- explicit assumptions and open questions

## Boundaries

- does not redesign the artifact unless a separate scope requests it
- does not introduce new principles; references existing vault knowledge
- does not produce implementation code

## Required Knowledge

- `principle.foundation.design-principles`
- `principle.foundation.gestalt-principles`
- `principle.foundation.usability-heuristics`
- `principle.foundation.visual-hierarchy`

## Related

- `specification.capability.design-evaluation`
- `workflow.operational.component-review`
- `workflow.component-review`
