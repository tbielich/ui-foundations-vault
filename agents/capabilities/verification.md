---
id: agent-capability.verification
title: Verification
type: agent-capability
status: review
owners:
  - ui-foundations
created: 2026-07-20
updated: 2026-07-20
authority: supporting
summary: Tool-independent agent capability profile for verifying claims and recommendations. References the canonical specification.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - specification.capability.verification
    - governance.verification-review
    - governance.precedence
---

# Verification

## Purpose

Check whether a claim, finding, or recommendation is supported by evidence and aligned with authoritative knowledge.

## Capability

Verify claims by locating source documents, checking evidence, separating facts from assumptions, and assigning a verification posture. Recommendations must not exceed the evidence.

Canonical definition: `specification.capability.verification`

## Inputs

- claim or recommendation to verify
- source documents and evidence
- known assumptions and conflicts

## Outputs

- verification result with posture
- supporting evidence
- assumptions and gaps
- recommendation: accept, revise, defer, or reject

## Boundaries

- claims must be specific enough to verify
- does not override higher-precedence vault knowledge
- does not produce runtime implementation guidance

## Required Knowledge

- `governance.verification-review`
- `governance.precedence`
- `reference.relationship-types`

## Related

- `specification.capability.verification`
- `governance.verification-review`
- `governance.precedence`
