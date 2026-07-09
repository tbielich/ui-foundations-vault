---
id: export-pack.governance.accessibility-baseline
title: Accessibility Baseline
type: governance
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: derived
summary: Reusable accessibility baseline for UI Foundations ecosystem repositories.
related:
  references:
    - registry.sync-contract
---

# Accessibility Baseline

## Rules

- Accessibility requirements are part of component and pattern quality, not a separate polish step.
- Interactive states must be perceivable, operable, and testable.
- Design tokens that affect contrast, spacing, focus, motion, or typography require accessibility review.
- Component documentation should describe accessibility expectations where behavior is not obvious.
- Accessibility findings from runtime work should become lessons when they recur.

## Review Expectations

Manual review is required for changes that alter focus behavior, keyboard operation, contrast, semantic structure, motion expectations, or screen reader behavior.
