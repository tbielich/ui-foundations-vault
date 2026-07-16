---
id: reference.document-types
title: Document Types
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-16
authority: source
summary: Defines the canonical document type taxonomy used in the vault.
related:
  references:
    - specification.vault-metadata
    - specification.document-structure
---

# Document Types

## Question

What document types exist in the vault?

## Purpose

This document is a lookup table for document types. It mirrors the approved metadata taxonomy without adding new types.

## Types

- `principle`: durable belief, quality bar, or foundational design knowledge.
- `governance`: rule for trust, lifecycle, precedence, review, or ownership.
- `workflow`: repeatable activity that produces an output.
- `prompt`: reusable agent session starter or instruction pattern.
- `specification`: normative requirements, constraints, structures, or expected behavior.
- `adr`: recorded decision with context, tradeoffs, and consequences.
- `agent-capability`: tool-independent description of what an agent role can do.
- `template`: reusable document structure.
- `glossary`: canonical vocabulary or term definition.
- `pattern`: reusable approach that is less normative than a specification.
- `index`: navigation or entry-point document.
- `publication`: informative long-form knowledge intended for human and agent readers; it does not override normative vault documents.

## Related Documents

- `specification.vault-metadata`
- `specification.document-structure`
