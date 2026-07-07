---
id: specification.ui-foundations.token-governance
title: Token Governance
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines review principles for token decisions in UI Foundations.
related:
  references:
    - governance.precedence
    - governance.verification-review
    - specification.ui-foundations.token-architecture
---

# Token Governance

## Question

How should token decisions be governed?

## Purpose

Token governance protects UI Foundations from uncontrolled value growth, duplicated meaning, and unstable local decisions.

## Core Concepts

- Token decisions need a reason.
- The same meaning should not be represented twice.
- New tokens should fit the existing layer model.
- Local tokens should not bypass semantic roles.
- Governance should prefer clarity over quantity.
- Verification should check meaning, layer, relationship, and downstream impact.

## Architecture

Token governance applies the vault precedence model to token knowledge. Immutable foundations shape quality expectations. UI Foundations architecture determines layer placement. Token lifecycle determines maturity.

A token should be accepted only when its purpose, layer, and relationships are clear.

## Relationships

Precedence defines which knowledge resolves conflicts. Verification review defines evidence expectations. Token architecture defines the conceptual constraints for new token decisions.

## Related Documents

- `governance.precedence`
- `governance.verification-review`
- `specification.ui-foundations.token-architecture`

