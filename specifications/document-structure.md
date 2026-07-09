---
id: specification.document-structure
title: Document Structure
type: specification
status: stable
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines canonical layouts for vault document types.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
---

# Document Structure

## Purpose

Vault documents should be predictable without becoming rigid. A consistent structure helps humans scan documents and helps agents extract purpose, authority, relationships, and expected action.

These layouts define preferred section patterns. They are not templates for filling space. Omit sections that do not add value.

## Universal Structure

Every governed document should include:

1. Frontmatter
2. A single level-one heading
3. A purpose or context section
4. The main body appropriate to its document type
5. Related documents or references when useful

## Principle

Recommended sections:

- Purpose
- Core Principle
- Guidance
- Examples
- Related
- References

Principles should express durable intent and quality bars. They should not contain procedural steps unless those steps are part of the principle itself.

## Governance

Recommended sections:

- Purpose
- Scope
- Rules
- Review Expectations
- Ownership
- Related

Governance documents define how the vault is maintained, trusted, changed, or retired.

## ADR

Recommended sections:

- Context
- Decision
- Rationale
- Consequences
- Alternatives Considered
- Verification
- Related

ADRs should explain why a decision exists, not only what was decided.

## Specification

Recommended sections:

- Purpose
- Scope
- Requirements
- Constraints
- Relationships
- Validation
- Examples
- References

Specifications define normative requirements and expected behavior.

## Workflow

Recommended sections:

- Goal
- Inputs
- Steps
- Outputs
- Constraints
- Verification
- Related

Workflows describe repeatable activity. They should reference governance and specifications rather than redefining them.

## Pattern

Recommended sections:

- Context
- Problem
- Pattern
- When to Use
- When Not to Use
- Examples
- Related

Patterns describe reusable approaches. They should stay less prescriptive than specifications.

## Prompt

Recommended sections:

- Purpose
- Context
- Instructions
- Expected Output
- Constraints
- Related

Prompts should operationalize existing vault knowledge. They should not introduce independent principles or governance.

## Agent Capability

Recommended sections:

- Purpose
- Capability
- Inputs
- Outputs
- Boundaries
- Required Knowledge
- Related

Agent capability documents should be tool-independent. They describe what an agent role can do, not how a specific vendor tool is configured.

## Template

Recommended sections:

- Purpose
- Template
- Usage Notes
- Related

Templates should remain lightweight and readable.

## Glossary

Recommended sections:

- Term
- Definition
- Usage
- Related Terms
- References

Accepted or stable glossary entries define canonical vocabulary.

## Index

Recommended sections:

- Purpose
- Navigation
- Recommended Starting Points
- Related

Indexes are navigational and informative. They should not contain unique normative guidance.

## Registry

Recommended sections or fields:

- Purpose
- Version
- Controlled values
- Entries
- Review expectations

Registries are machine-readable declarations. They should avoid hidden behavior and should not execute synchronization.

## Lesson

Recommended sections:

- Source
- Local Fact
- Generalized Lesson
- Affected Areas
- Evidence
- Proposed Action
- Open Questions

Lessons capture reusable learning from concrete work. They are evidence for future governance, specifications, workflows, prompts, or export packs.

## Export Pack

Recommended sections:

- Purpose
- Contents
- Consumption Rules
- Boundaries
- Related

Export packs package reviewed guidance for other repositories. They are derived artifacts and should not override their source documents.

## Schema

Recommended sections or fields:

- Purpose
- Target file or artifact
- Required fields
- Optional fields
- Validation limits

Schemas are advisory. They help humans and agents detect structural problems, but they do not override governance, specifications, or review.
