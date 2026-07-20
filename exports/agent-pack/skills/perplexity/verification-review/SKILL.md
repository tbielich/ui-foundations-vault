---
name: verification-review
description: Load when evaluating whether a claim, change, or recommendation is supported by sufficient evidence.
metadata:
  canonical_title: Verification Review
  source_id: governance.verification-review
  source_path: governance/verification-review.md
---

# Verification Review

Verification review checks whether a proposed change has enough evidence to be trusted.

## Purpose

Use verification review to keep UI Foundations work grounded in observable facts, explicit assumptions, and reproducible checks.

## Review Questions

- What changed?
- What source of truth supports the change?
- What assumptions are being made?
- What evidence confirms the result?
- What remains unverified?
- Which repository should act on the finding?

## Evidence Standards

Prefer direct evidence:

- Local file references
- Existing specifications
- Recorded decisions
- Test output
- Screenshots or rendered artifacts when visual behavior matters
- Links to authoritative source material when external context is required

## Output

A verification review should end with one of these outcomes:

- Accepted: evidence is sufficient.
- Accepted with notes: evidence is sufficient, but follow-up is useful.
- Needs revision: evidence is incomplete or conflicts with the expected result.
- Out of scope: the change belongs in another repository or process.
