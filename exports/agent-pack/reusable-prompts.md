---
id: export-pack.agent.reusable-prompts
title: Reusable Prompts
type: prompt
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: derived
summary: Prompt starters for common cross-repo UI Foundations workflows.
related:
  governed_by:
    - governance.precedence
    - registry.sync-contract
---

# Reusable Prompts

## Knowledge Extraction

Extract reusable UI Foundations knowledge from this issue or PR.

Return:

- The local implementation fact.
- The generalized lesson.
- Whether the lesson belongs in `knowledge/lessons/`.
- Whether repeated evidence suggests a governance, specification, workflow, or prompt update.

## Sync Readiness Review

Review this proposed vault-derived change before it is applied to a consuming repository.

Check:

- The source vault document or export pack is identified.
- The target repository keeps ownership of implementation, build, test, CI, and deployment files.
- No protected file from `registry/sync-contract.yml` is overwritten.
- Required manual review items are called out.

## Governance Promotion

Evaluate whether these repeated lessons should become governance.

Return:

- Evidence summary.
- Proposed governance statement.
- Affected repositories.
- Expected export pack impact.
- Open questions before review.
