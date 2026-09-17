---
id: export-pack.agent.projection.uif-int-agents
title: UIF-INT AGENTS.md Projection
type: export-pack
status: review
owners:
  - ui-foundations
created: 2026-09-17
updated: 2026-09-17
authority: derived
summary: Defines the reviewed Vault-managed guidance region projected into the root AGENTS.md of ui-foundations-intelligence.
consumers:
  - human
  - agent
applies_to:
  - ui-foundations-intelligence
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - agent-capability.vault-maintainer
    - docs.architecture
    - registry.sync-contract
    - registry.repos
    - export-pack.agent.agents-additions
    - specification.capability.verification
provenance:
  sources:
    - type: vault-document
      role: derived-from
      id: export-pack.agent.agents-additions
    - type: vault-document
      role: supporting-source
      id: governance.precedence
    - type: vault-document
      role: supporting-source
      id: governance.lifecycle
    - type: vault-document
      role: supporting-source
      id: docs.architecture
    - type: vault-document
      role: supporting-source
      id: registry.sync-contract
    - type: vault-document
      role: supporting-source
      id: registry.repos
    - type: vault-document
      role: supporting-source
      id: specification.capability.verification
verification:
  status: partially-verified
---

# UIF-INT AGENTS.md Projection

## Purpose

This projection defines the Vault-managed shared guidance region consumed by the repository-root `AGENTS.md` in `ui-foundations-intelligence`.

It is derived and non-canonical. It packages existing Vault knowledge for one consuming repository and must not introduce new domain rules, runtime orchestration semantics, or provider-specific behavior.

UIF-INT remains authoritative for its implementation, architecture, contracts, build, tests, runtime behavior, local configuration, and execution policy.

## Projection target

- Repository: `ui-foundations-intelligence`
- Target path: `AGENTS.md`
- Sync mode: `reviewed_patch`
- Managed begin marker: `<!-- UIF-VLT:BEGIN shared-agent-guidance -->`
- Managed end marker: `<!-- UIF-VLT:END shared-agent-guidance -->`

Only the content between these markers is Vault-managed. Content outside the markers is repository-owned and must not be changed by this projection.

## Authority

Apply this projection only as a consumer adaptation layer.

- Canonical Vault sources retain their normal lifecycle, authority, and precedence.
- Repository-local constraints remain authoritative for UIF-INT implementation, build, test, runtime, and local configuration behavior.
- This projection cannot override either canonical Vault sources or applicable repository-local constraints.
- When the two domains appear to conflict, surface the conflict for review rather than silently choosing or rewriting either source.

## Projected block

The following block is the exact shared region intended for `ui-foundations-intelligence/AGENTS.md`.

```markdown
<!-- UIF-VLT:BEGIN shared-agent-guidance -->
## Shared UI Foundations guidance

This managed block is projected from `ui-foundations-vault/exports/agent-pack/projections/ui-foundations-intelligence-agents.md`.

- UIF-VLT is canonical for durable ecosystem governance, principles, decisions, specifications, workflows, prompts, and reusable agent knowledge.
- This repository remains canonical for its implementation, architecture, contracts, build, tests, runtime behavior, and local configuration.
- Apply UIF-VLT lifecycle and precedence when interpreting Vault knowledge; accepted or stable higher-precedence sources override lower-precedence derived guidance.
- Provider- or runtime-specific projections are derived guidance and must not override canonical Vault sources or applicable repository-local constraints.
- Verification claims must be supported by evidence; assumptions, conflicts, and gaps must remain explicit.
- Reusable cross-repository findings should be proposed back to UIF-VLT rather than becoming duplicated durable guidance here.

Do not edit this managed block independently. Changes should arrive through a reviewed Vault projection patch.
<!-- UIF-VLT:END shared-agent-guidance -->
```

## Sync rules

A consumer update should follow `registry.sync-contract`:

1. Read this projection and the target `AGENTS.md`.
2. Locate the exact begin and end markers.
3. Compare only the managed region with the projected block above.
4. If the regions differ, propose a plain-text reviewed patch to the consuming repository.
5. Never modify content outside the managed markers as part of projection sync.
6. If markers are missing, duplicated, malformed, or nested, report `BLOCKED` rather than guessing the owned region.
7. If a source document changes materially, review this projection before updating the consumer.

No silent overwrite is permitted.

## Repository-local guidance intentionally excluded

This projection does not own UIF-INT-specific execution policy, including:

- work eligibility signals such as `agent:ready`
- Execution Contract semantics
- IMPLEMENT / VERIFY / REPAIR session behavior
- provider-neutral executor routing details
- `ExecutionTrace` requirements
- Cline-specific `.clinerules/`
- repository setup, build, or test commands
- stop conditions tied to UIF-INT runtime behavior

Those concerns belong to the consuming repository unless separately promoted into canonical Vault knowledge through normal governance review.

## Change model

When a reusable UIF-INT lesson should become shared ecosystem guidance:

1. Promote the concept into an appropriate canonical Vault document first.
2. Review that source under normal Vault lifecycle and precedence rules.
3. Update this derived projection only after the source is ready to guide consumers.
4. Propose the resulting managed-region diff to UIF-INT as a reviewed patch.

This keeps the Vault as source of reusable knowledge without turning it into runtime orchestration or silently taking ownership of the consuming repository.
