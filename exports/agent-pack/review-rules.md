---
id: export-pack.agent.review-rules
title: Review Rules
type: workflow
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: derived
summary: Review rules for agents evaluating cross-repo UI Foundations changes.
related:
  governed_by:
    - governance.precedence
    - registry.sync-contract
---

# Review Rules

## Review Focus

Agents reviewing UI Foundations ecosystem changes should check:

- Whether the change belongs in the current repository.
- Whether copied guidance remains traceable to the vault.
- Whether implementation repositories keep their runtime authority.
- Whether governance, token, component, and accessibility rules are applied consistently.
- Whether a reusable finding should become a vault lesson.

## Required Escalation

Manual review is required when a change:

- Rewrites repository agent guidance.
- Changes package boundaries.
- Changes token naming or token lifecycle expectations.
- Changes component lifecycle, composition, or accessibility expectations.
- Promotes a repeated lesson into a governance rule.
