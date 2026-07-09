---
id: docs.architecture
title: Architecture
type: index
status: stable
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: supporting
summary: Describes the vault's role, boundaries, knowledge levels, and canonical content locations.
related:
  references:
    - governance.precedence
    - governance.lifecycle
    - specification.document-structure
    - specification.vault-metadata
---

# Architecture

UI Foundations Vault is the knowledge and governance layer for the UI Foundations ecosystem.

## Position in the Ecosystem

The UI Foundations ecosystem is split across focused repositories:

- `ui-foundations`: runtime assets for the UI Foundations ecosystem.
- `ui-foundations-vault`: canonical knowledge for the UI Foundations ecosystem.
- `ui-foundations-intelligence`: reasoning and execution engine for the UI Foundations ecosystem.
- `ui-foundations-studio`: workspace for the UI Foundations ecosystem.

## Boundary

This repository does not execute workflows. It describes them.

This repository does not implement components. It specifies and governs them.

This repository does not orchestrate agents. It defines reusable agent knowledge, roles, and prompts.

## Knowledge Standard

The vault is maintained as a lightweight knowledge standard. Its documents should be stable enough for humans to review and structured enough for agents to consume.

The standard is:

- Markdown-first
- Git-friendly
- Tool-independent
- Human-readable
- Machine-readable
- Governed by explicit lifecycle and precedence rules

## Knowledge Levels

Knowledge levels describe abstraction and responsibility. They are not folder names.

### Level 1: Foundations

Foundational orientation, boundaries, vocabulary, and ecosystem context.

Responsibility: explain what the vault is and how it relates to the UI Foundations ecosystem.

### Level 2: Principles

Durable beliefs, design intent, and quality bars.

Responsibility: define what should remain true across tools, repositories, and implementations.

### Level 3: Governance

Rules for trust, review, precedence, lifecycle, ownership, and change.

Responsibility: define how knowledge becomes authoritative and how conflicts are resolved.

### Level 4: Specifications

Normative requirements, structures, constraints, and validation expectations.

Responsibility: define what other documents, repositories, or tools may implement against.

### Level 5: Workflows

Repeatable human and agent activities.

Responsibility: describe how work is performed without redefining governance or requirements.

### Level 6: Prompts and Agent Capabilities

Reusable agent instructions, roles, and operating knowledge.

Responsibility: operationalize existing vault knowledge for agent sessions and agent-to-agent work.

### Level 7: Examples and Templates

Illustrative material and reusable document shapes.

Responsibility: make the standard easier to apply without creating new authority.

### Level 8: Registries and Export Packs

Machine-readable repository contracts and curated cross-repo packs.

Responsibility: declare how other repositories may consume vault knowledge without turning the vault into runtime automation.

## Normative Model

The vault does not use extra metadata to mark normative content. Normative behavior is derived from document type, lifecycle, and precedence.

Normative by default:

- Governance
- Principles
- Specifications
- Accepted or stable ADRs
- Accepted or stable glossary entries for terminology

Informative by default:

- Workflows
- Patterns
- Prompts
- Agent capabilities
- Templates
- Examples
- Indexes

Informative documents can guide action, but they do not override normative documents.

## Canonical Locations

Use these locations for governed content:

- `principles/`: durable principles
- `foundations/`: immutable design knowledge independent of tools and implementations
- `governance/`: lifecycle, precedence, review, and ownership rules
- `decisions/`: ADRs and durable decisions
- `specifications/`: canonical specifications
- `workflows/`: repeatable activities
- `patterns/`: reusable approaches
- `prompts/`: reusable prompt patterns and session starters
- `agents/`: tool-independent agent capabilities and operating knowledge
- `glossary/`: canonical terms
- `templates/`: reusable document shapes
- `knowledge/`: cross-repo findings and lessons before promotion
- `registry/`: machine-readable repository, artifact, and sync contracts
- `exports/`: curated packs for reviewed consumption by other repositories
- `docs/`: orientation, architecture, and navigation

Specifications belong in `specifications/`. The `docs/` directory should not contain canonical specifications.

## Content Model

Documents should be modular and linkable. A stable topic should live in one clear place, with cross-references only when they improve navigation.

Recommended document types:

- Principles: durable beliefs and quality bars
- Governance: decision rights and verification requirements
- Decisions: dated records of important choices
- Workflows: repeatable procedures
- Prompts: reusable agent session inputs
- Specifications: expected behavior, structure, and constraints
- Glossary: shared vocabulary
- Templates: repeatable document shapes
- Patterns: reusable approaches
