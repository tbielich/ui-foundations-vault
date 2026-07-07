---
id: reference.relationship-types
title: Relationship Types
type: specification
status: review
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines canonical relationship meanings used between vault documents.
related:
  references:
    - specification.vault-metadata
    - governance.precedence
---

# Relationship Types

## Question

What relationship types connect knowledge documents?

## Purpose

This document is a lookup table for relationship meanings. It defines how documents refer to one another without adding governance process.

## Types

- `depends_on`: this document needs another document to be understood or applied.
- `supports`: this document provides evidence or context for another document.
- `supersedes`: this document replaces another document.
- `superseded_by`: this document has been replaced by another document.
- `implements`: this document operationalizes another document.
- `implemented_by`: this document is operationalized by another document.
- `governs`: this document sets rules for another document.
- `governed_by`: this document is constrained by another document.
- `references`: this document cites or points to another document.
- `conflicts_with`: this document has a known unresolved conflict with another document.

## Related Documents

- `specification.vault-metadata`
- `governance.precedence`

