---
id: export-pack.agent
title: Agent Pack
type: export-pack
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-20
authority: derived
summary: Curated agent guidance for reviewed consumption by UI Foundations ecosystem repositories.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - agent-capability.vault-maintainer
    - registry.sync-contract
---

# Agent Pack

## Purpose

The Agent Pack contains reusable agent-facing guidance that can be copied or referenced by UI Foundations ecosystem repositories through a reviewed change.

It is derived from vault governance, prompts, workflows, and agent operating knowledge. It does not override a consuming repository's local `AGENTS.md`.

## Contents

- `agents-additions.md`: suggested additions for consuming-repository agent guidance.
- `assistant-behavior-rules.md`: reusable behavior rules for agents working near UI Foundations systems.
- `projections/perplexity-research.md`: platform-specific derived operating guidance for Perplexity as a research and validation consumer.
- `review-rules.md`: review stance for agents inspecting UI Foundations changes.
- `reusable-prompts.md`: prompt starters for common cross-repo work.

## Consumption Rules

- Consume this pack through `registry/sync-contract.yml`.
- Keep local repository constraints authoritative for local implementation details.
- Do not overwrite repository-owned `AGENTS.md` sections without manual review.
- Treat prompts as operational guidance, not governance.
- Treat platform-specific projections as derived consumer guidance, not as canonical agent roles or governance.
