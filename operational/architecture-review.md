---
id: workflow.operational.architecture-review
title: Architecture Review
type: workflow
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: supporting
summary: Describes how to review architecture against existing vault knowledge.
related:
  references:
    - docs.architecture
    - governance.precedence
    - specification.ui-foundations.token-architecture
    - specification.ui-foundations.component-architecture
    - specification.ui-foundations.pattern-model
---

# Architecture Review

## Question

How should architecture be reviewed?

## Purpose

Use this playbook to evaluate whether a proposed architectural change fits existing vault boundaries, layers, and relationships.

## Inputs

- Architecture proposal or change
- Affected knowledge domains
- Claimed rationale
- Related decisions, specifications, and reference terms
- Known tradeoffs

## Preconditions

- The architectural scope is explicit.
- Existing architecture documents have been reviewed.
- Conflicts and assumptions can be recorded.

## Steps

1. Identify the architectural question being answered.
2. Locate the relevant vault layer and domain.
3. Check the proposal against precedence.
4. Check whether the proposal duplicates existing architecture.
5. Review relationships to foundations, tokens, patterns, and components.
6. Identify tradeoffs, assumptions, and unresolved conflicts.
7. Recommend accept, revise, defer, or reject.

## Outputs

- Architecture review recommendation
- Relationship findings
- Conflict or duplication findings
- Tradeoffs
- Follow-up documents to update

## Quality Gates

- The proposal fits an existing knowledge domain or identifies a clear gap.
- No lower-precedence document overrides higher-precedence knowledge.
- Relationships are explicit.
- Architectural intent is separated from operational steps.

## Related Documents

- `docs.architecture`
- `governance.precedence`
- `specification.ui-foundations.token-architecture`
- `specification.ui-foundations.component-architecture`
- `specification.ui-foundations.pattern-model`

