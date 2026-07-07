---
id: specification.capability.verification
title: Verification
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines the capability to verify claims and recommendations.
related:
  references:
    - governance.verification-review
    - governance.precedence
    - reference.relationship-types
    - workflow.operational.release-review
---

# Verification

## Question

What does it mean to verify claims and recommendations?

## Purpose

Verification checks whether a claim, finding, or recommendation is supported by evidence and aligned with authoritative knowledge.

## Inputs

- Claim or recommendation
- Source documents
- Evidence
- Assumptions
- Known conflicts

## Required Knowledge

- Verification review
- Precedence
- Relationship types
- Relevant source documents for the claim

## Reasoning Method

1. State the claim precisely.
2. Identify the source documents that should support it.
3. Check evidence against the claim.
4. Separate confirmed facts from assumptions and inferences.
5. Identify conflicts or missing support.
6. Assign a verification posture.

## Outputs

- Verification result
- Supporting evidence
- Assumptions and gaps
- Conflict notes
- Recommendation to accept, revise, defer, or reject

## Quality Gates

- The claim is specific enough to verify.
- Evidence is linked to source knowledge.
- Assumptions are explicit.
- Recommendations do not exceed the evidence.

## Related Documents

- `governance.verification-review`
- `governance.precedence`
- `reference.relationship-types`
- `workflow.operational.release-review`
