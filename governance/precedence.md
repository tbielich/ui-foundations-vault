---
id: governance.precedence
title: Knowledge Precedence
type: governance
status: stable
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines the canonical order for resolving conflicts between vault documents.
---

# Knowledge Precedence

## Purpose

This document defines how humans and agents should resolve conflicts between vault documents.

Precedence protects the vault from treating every document as equally authoritative. It also lets agents reason predictably when retrieved context contains principles, specifications, workflows, prompts, and examples at the same time.

## Canonical Order

When two documents conflict, use this order unless a later accepted governance document explicitly changes it.

1. Governance
2. Principles
3. ADRs
4. Specifications
5. Workflows
6. Patterns
7. Prompts
8. Examples

## Rationale

### Governance

Governance has highest precedence because it defines how the vault is maintained, reviewed, trusted, changed, and retired.

Governance does not define product intent or implementation requirements. It defines the rules by which those documents become authoritative.

### Principles

Principles define durable intent and quality bars. They should guide interpretation when a lower-level document is ambiguous.

Principles should not contain procedural detail. They explain what must remain true over time.

### ADRs

ADRs record durable decisions, including tradeoffs and consequences. An accepted ADR can clarify or narrow a principle for a specific context.

ADRs should not silently replace governance. If an ADR changes governance, the governance document must be updated.

### Specifications

Specifications define normative requirements, constraints, structures, and expected behavior.

Specifications implement principles and ADRs at a more concrete level. They override workflows, prompts, examples, and patterns when those documents describe conflicting action.

### Workflows

Workflows describe repeatable activity. They are authoritative only as process guidance, not as a source of principles or requirements.

If a workflow conflicts with a specification, update the workflow.

### Patterns

Patterns describe reusable approaches. They are less binding than workflows and specifications because they may apply only in recurring situations.

Patterns help recognition and reuse, but they should not create hidden requirements.

### Prompts

Prompts operationalize vault knowledge for agents. They are instructions for a session, not independent sources of truth.

If a prompt conflicts with governance, principles, ADRs, or specifications, the prompt is wrong.

### Examples

Examples illustrate usage. They are never normative by default.

Examples may clarify intent, but they must not be used to override explicit guidance.

## Conflict Resolution

When a conflict is found:

1. Identify the highest-precedence accepted or stable source.
2. Check whether a newer accepted or stable governance document changes the interpretation.
3. Treat lower-precedence conflicting documents as candidates for revision.
4. Record unresolved conflicts with an explicit relationship when metadata is present.

## Normative Defaults

Document types are normative by default as follows:

- Governance: normative
- Principles: normative
- ADRs: normative when accepted or stable
- Specifications: normative
- Workflows: informative
- Patterns: informative
- Prompts: informative
- Templates: informative
- Glossary: normative for terminology when accepted or stable
- Examples: informative
- Indexes: informative

Informative documents can still be important. They guide action, but they do not override normative documents.
