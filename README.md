---
id: index.root
title: UI Foundations Vault
type: index
status: stable
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: supporting
summary: Entry point for the UI Foundations knowledge standard.
related:
  references:
    - docs.architecture
    - governance.precedence
    - governance.lifecycle
    - specification.document-structure
    - specification.vault-metadata
---

# UI Foundations Vault

UI Foundations Vault is the curated agentic knowledge vault for UI Foundations.

It is the source of truth for principles, decisions, governance, workflows, prompts, specifications, and agent knowledge.

It is not:

- The runtime implementation
- The design system package
- The A2A orchestrator
- The visual workspace or dashboard

## UI Foundations Ecosystem

- `ui-foundations`: runtime assets for the UI Foundations ecosystem.
- `ui-foundations-vault`: canonical knowledge for the UI Foundations ecosystem.
- `ui-foundations-intelligence`: reasoning and execution engine for the UI Foundations ecosystem.
- `ui-foundations-studio`: workspace for the UI Foundations ecosystem.

## Repository Shape

- `docs/`: high-level architecture and orientation
- `foundations/`: immutable design knowledge independent of tools and implementations
- `principles/`: durable product, design, engineering, and agent principles
- `governance/`: review rules, decision rights, verification practices
- `decisions/`: architecture and operating decisions
- `workflows/`: repeatable human and agent workflows
- `patterns/`: reusable approaches
- `prompts/`: reusable prompt patterns and session starters
- `agents/`: agent roles, responsibilities, and operating guidance
- `specifications/`: product, component, token, and workflow specifications
- `glossary/`: shared terms and definitions
- `templates/`: reusable markdown templates
- `knowledge/`: cross-repo lessons and reusable findings before promotion
- `registry/`: machine-readable repository, artifact, and sync contracts
- `exports/`: reviewed packs for cross-repo knowledge consumption
- `schemas/`: advisory schemas for registry and export-pack validation

## Working Model

This repository is markdown-first. Content should be easy for humans to review and easy for agents to retrieve, quote, and apply.

Prefer concise, tool-independent documents. Link to concrete decisions and specifications when a topic becomes stable enough to govern implementation elsewhere.

## Knowledge Standard

The vault follows a lightweight Version 1.0 knowledge standard:

- `governance/precedence.md` defines how conflicts between document types are resolved.
- `governance/lifecycle.md` defines document states and review expectations.
- `specifications/document-structure.md` defines canonical document layouts.
- `specifications/vault-metadata.md` defines markdown frontmatter metadata.
- `docs/cross-repo-knowledge-sync.md` defines cross-repo consumption and feedback flow.
- `docs/reflection-loop.md` defines how lessons become durable vault knowledge.
- `docs/governance-pack-publishing.md` defines versioned Governance Pack publication.
