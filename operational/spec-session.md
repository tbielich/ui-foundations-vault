---
id: workflow.operational.spec-session
title: Specification Session
type: workflow
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: supporting
summary: Describes how to conduct a specification session using existing vault knowledge.
related:
  references:
    - specification.document-structure
    - specification.vault-metadata
    - governance.precedence
    - governance.verification-review
---

# Specification Session

## Question

How should a specification session be conducted?

## Purpose

Use this playbook to create or revise a specification while preserving vault structure, precedence, and evidence quality.

## Inputs

- Topic to specify
- Existing related documents
- Known constraints
- Evidence and assumptions
- Intended consumers

## Preconditions

- The topic belongs in a specification.
- Existing documents have been checked for overlap.
- The session has a clear expected output.

## Steps

1. Define the question the specification must answer.
2. Identify source documents using precedence.
3. Separate requirements from examples and assumptions.
4. Place the topic in the correct knowledge domain.
5. Draft using the canonical document structure.
6. Add metadata and relationships without adding new fields.
7. Review evidence, conflicts, and open questions.

## Outputs

- Specification draft or revision
- Explicit assumptions
- Related document links
- Open questions
- Verification notes

## Quality Gates

- The specification has one clear scope.
- The document follows the metadata and structure standards.
- Higher-precedence sources are not contradicted.
- Assumptions are visible.

## Related Documents

- `specification.document-structure`
- `specification.vault-metadata`
- `governance.precedence`
- `governance.verification-review`

