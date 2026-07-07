---
id: specification.capability.specification-generation
title: Specification Generation
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines the capability to generate a specification from existing knowledge.
related:
  references:
    - specification.document-structure
    - specification.vault-metadata
    - governance.precedence
    - workflow.operational.spec-session
---

# Specification Generation

## Question

What does it mean to generate a specification?

## Purpose

Specification generation turns existing knowledge, constraints, and decisions into a structured normative document.

## Inputs

- Topic and scope
- Existing related documents
- Known requirements and constraints
- Evidence and assumptions
- Intended consumers

## Required Knowledge

- Document structure
- Vault metadata
- Precedence
- Relevant foundations, UI Foundations knowledge, and reference documents

## Reasoning Method

1. Define the single question the specification answers.
2. Identify source documents by precedence.
3. Separate requirements, constraints, assumptions, and examples.
4. Choose the correct domain and document type.
5. Draft sections according to the document structure standard.
6. Add relationships to source knowledge.
7. Surface unresolved questions.

## Outputs

- Specification draft or revision
- Metadata and relationship set
- Requirements and constraints
- Assumptions and open questions
- Verification notes

## Quality Gates

- The specification does not introduce unsupported knowledge.
- Requirements are separated from examples.
- Relationships point to existing documents.
- Metadata follows the vault standard.

## Related Documents

- `specification.document-structure`
- `specification.vault-metadata`
- `governance.precedence`
- `workflow.operational.spec-session`
