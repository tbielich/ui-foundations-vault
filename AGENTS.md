---
id: agent-capability.vault-maintainer
title: Agent Guidance
type: agent-capability
status: stable
owners:
  - ui-foundations
created: 2026-07-07
updated: 2026-07-07
authority: source
summary: Defines tool-independent guidance for agents maintaining the vault.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - specification.document-structure
    - specification.vault-metadata
---

# Agent Guidance

This repository is a knowledge and governance vault. Agents working here should preserve clarity, traceability, and tool independence.

## Scope

Agents may create or update markdown documents that describe:

- Principles
- Decisions
- Governance rules
- Workflows
- Prompts
- Specifications
- Glossary terms
- Agent operating knowledge

Agents must not add runtime implementation, application code, generated build output, package dependencies, or local orchestration logic.

## Editing Standards

- Keep documents human-readable and agent-readable.
- Prefer stable concepts over tool-specific instructions.
- Use plain markdown unless a richer format is necessary.
- Keep placeholders explicit and short.
- Do not reference files that do not exist.
- When a decision affects another repository, describe the expected impact without changing that repository here.
- Apply the precedence model before treating retrieved context as authoritative.
- Treat prompts as operational guidance, not as a source that can override governance, principles, ADRs, or specifications.

## Review Expectations

Before making changes, check whether the update belongs in this vault or in one of the related implementation repositories.

When adding new guidance, prefer:

1. A principle when the guidance should be durable.
2. A decision when the guidance records a choice and tradeoff.
3. A workflow when the guidance describes repeatable action.
4. A specification when the guidance defines expected behavior or structure.
5. A prompt when the guidance starts or steers an agent session.
