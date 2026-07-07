---
id: specification.ui-foundations.token-lifecycle
title: Token Lifecycle
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines how token decisions mature inside UI Foundations.
related:
  references:
    - governance.lifecycle
    - specification.ui-foundations.token-governance
    - specification.ui-foundations.token-architecture
---

# Token Lifecycle

## Question

How should token decisions mature?

## Purpose

Token lifecycle keeps UI Foundations token decisions intentional, reviewable, and aligned with the architecture as they evolve.

## Core Concepts

- A token begins as a need, not as a value.
- The correct layer must be identified before a token is named.
- A token should have clear meaning, ownership, and reuse potential.
- A token can be refined, promoted, deprecated, or retired.
- Token changes should protect downstream stability.

## Architecture

Token lifecycle follows the vault lifecycle but applies it to token decisions. A token decision should move from local need to reviewed system knowledge only when it has stable meaning and repeatable value.

Deprecation should preserve traceability and provide replacement guidance when possible.

## Relationships

Vault lifecycle defines document maturity. Token governance defines review expectations for token decisions. Token architecture defines where each decision belongs.

## Related Documents

- `governance.lifecycle`
- `specification.ui-foundations.token-governance`
- `specification.ui-foundations.token-architecture`

