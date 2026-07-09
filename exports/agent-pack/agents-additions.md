---
id: export-pack.agent.agents-additions
title: AGENTS Additions
type: agent-capability
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: derived
summary: Suggested AGENTS.md additions for repositories consuming UI Foundations vault knowledge.
related:
  governed_by:
    - governance.precedence
    - registry.sync-contract
---

# AGENTS Additions

## Purpose

Use these additions when a UI Foundations ecosystem repository needs to consume shared vault knowledge while preserving local repository authority.

## Suggested Text

This repository may consume reviewed guidance from `ui-foundations-vault`.

Agents must:

- Treat local repository instructions as authoritative for implementation, build, test, release, and deployment behavior.
- Treat vault governance, principles, specifications, workflows, and prompts according to vault precedence.
- Never silently overwrite repo-local implementation, package, CI, or deployment files with vault-derived content.
- When a reusable insight is discovered, propose it back to the vault as a lesson or governance candidate.
- Keep copied vault guidance traceable to its source document or export pack.

## Boundaries

Vault guidance may steer reviews, naming, tokens, accessibility expectations, component governance, and agent behavior. It must not introduce runtime implementation code or package dependencies.
