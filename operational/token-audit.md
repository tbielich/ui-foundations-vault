---
id: workflow.operational.token-audit
title: Token Audit
type: workflow
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: supporting
summary: Describes how to audit token decisions against UI Foundations token knowledge.
related:
  references:
    - specification.ui-foundations.token-architecture
    - specification.ui-foundations.token-governance
    - specification.ui-foundations.token-lifecycle
    - reference.token-taxonomy
---

# Token Audit

## Question

How should tokens be audited?

## Purpose

Use this playbook to evaluate whether token decisions have clear meaning, correct layer placement, and justified reuse.

## Inputs

- Token proposal or existing token set
- Claimed token meaning
- Intended consumers
- Known themes, modes, patterns, or components affected
- Evidence of reuse or duplication

## Preconditions

- The token need is described before values are discussed.
- Relevant taxonomy and architecture documents are available.
- The audit scope is limited to token knowledge, not implementation.

## Steps

1. Identify the decision the token represents.
2. Classify the token using the token taxonomy.
3. Check layer placement against token architecture.
4. Check semantic meaning against semantic architecture.
5. Check brand and contextual variation against theme and mode knowledge.
6. Identify duplication or bypassed meaning.
7. Record lifecycle recommendation and required follow-up.

## Outputs

- Layer category
- Meaning assessment
- Duplication findings
- Lifecycle recommendation
- Follow-up questions

## Quality Gates

- The token has one clear meaning.
- The token belongs to the proposed layer.
- The same meaning is not represented elsewhere.
- Local decisions do not bypass semantic roles.
- Findings reference existing token knowledge.

## Related Documents

- `specification.ui-foundations.token-architecture`
- `specification.ui-foundations.token-governance`
- `specification.ui-foundations.token-lifecycle`
- `reference.token-taxonomy`
