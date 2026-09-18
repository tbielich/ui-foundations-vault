---
id: export-pack.agent.projection.chatgpt-project
title: ChatGPT UIF Project Instructions Projection
type: export-pack
status: review
owners:
  - ui-foundations
created: 2026-09-18
updated: 2026-09-18
authority: derived
summary: Provides the reviewed ChatGPT Project custom-instructions projection for the private UI Foundations workspace.
consumers:
  - human
  - agent
  - chatgpt
applies_to:
  - ui-foundations
  - ui-foundations-vault
  - ui-foundations-intelligence
  - ui-foundations-studio
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - specification.project-bootstrap
    - docs.architecture
    - registry.sync-contract
    - registry.project-projections
    - export-pack.agent
provenance:
  sources:
    - type: vault-document
      role: derived-from
      id: specification.project-bootstrap
    - type: vault-document
      role: supporting-source
      id: docs.architecture
    - type: vault-document
      role: supporting-source
      id: registry.sync-contract
verification:
  status: partially-verified
assumptions:
  - ChatGPT Project custom instructions currently allow 8000 characters.
---

# ChatGPT UIF Project Instructions Projection

## Purpose

This projection materializes the canonical UIF Project Bootstrap into ChatGPT Project custom instructions for the private UI Foundations workspace.

It is derived and non-canonical. It adapts existing UIF authority, scope, execution, evidence, and state principles to the ChatGPT project surface without making ChatGPT settings a second source of truth.

## Projection target

- Consumer: ChatGPT Project
- Surface: Custom instructions
- Sync mode: `manual_copy`
- Materialization: deterministic generated snapshot
- Projection registry: `registry/project-projections.yml`
- Generated artifact: `.generated/project-projections/chatgpt-project.instructions.md`
- Generator: `ruby scripts/generate-project-projections.rb`
- Character budget: 8000
- Projected block length: validated by the generator

The Project settings surface is treated as a consumer. Canonical changes must originate from governed Vault or repository sources and then be reviewed here before materialization.

The reviewed fragment pack is the projection text source for this consumer. The generator composes and validates the manifest-selected fragments, then writes a disposable snapshot artifact for manual copy into ChatGPT Project settings.

## Authority

- `specification.project-bootstrap` defines the provider-neutral bootstrap contract.
- Applicable accepted or stable UIF-VLT sources remain canonical for durable shared knowledge.
- Repository-local instructions remain authoritative for implementation, build, tests, runtime behavior, and local configuration.
- Current human instructions and bounded Execution Contracts continue to define active task scope.
- ChatGPT memory, prior chats, file-library availability, and web research provide context only and do not become authoritative because this projection can access them.

## Composition source

The generated ChatGPT instructions are no longer stored as one monolithic block in this document.

They are composed from the ordered fragments declared by `registry.project-projections` and stored in:

- fragment pack: `exports/agent-pack/fragments/project-bootstrap.yml`
- projection entry: `chatgpt-project`
- generated artifact: `.generated/project-projections/chatgpt-project.instructions.md`

The fragment pack is derived and non-canonical. Each fragment carries source ids back to the governing UIF knowledge. The manifest selects the ordered fragment set for this consumer.

The generator must reproduce the reviewed ChatGPT instruction artifact deterministically from those fragments and enforce the consumer constraints before materialization.

## Consumption rules

1. Copy the projected block into the private UIF ChatGPT Project custom-instructions field.
2. Review the complete block before replacing existing instructions.
3. Do not add volatile issue state, branch state, credentials, local paths, or current execution status.
4. Keep memory and library access enabled only as context sources; their availability does not change authority.
5. When canonical UIF knowledge changes, update the canonical source first, then review this projection.
6. If the ChatGPT instruction limit or platform behavior changes, adapt this projection without changing the provider-neutral bootstrap contract unless the contract itself needs revision.
7. Do not reuse this projection for TUI UILib or another design system; create a separate consumer projection with its own governed scope if required.

## Intentionally excluded

This projection does not own:

- concrete repository setup or validation commands;
- current GitHub issues or project-board state;
- secrets, tokens, credentials, or environment configuration;
- detailed component, token, or accessibility specifications;
- provider-specific execution semantics that belong in repository adapters;
- TUI UILib / TUI Design System governance or organizational context.

## Validation

This projection is valid when:

- the projected block remains within the target character budget;
- it preserves the UIF/UILib boundary;
- it identifies UIF-VLT as canonical for durable reusable UIF knowledge;
- it preserves repository-local implementation authority;
- it treats memory and conversation as context rather than persisted execution state;
- it contains no volatile task state or credentials;
- it remains derivable from the reviewed fragment pack, `specification.project-bootstrap`, and their referenced authorities.

A change to the projected instructions should be reviewed as a derived projection change, not as an implicit change to canonical UIF governance.
