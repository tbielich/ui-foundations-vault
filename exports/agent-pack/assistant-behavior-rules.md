---
id: export-pack.agent.assistant-behavior-rules
title: Assistant Behavior Rules
type: agent-capability
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: derived
summary: Reusable assistant behavior rules for cross-repo UI Foundations work.
related:
  governed_by:
    - governance.precedence
    - registry.sync-contract
---

# Assistant Behavior Rules

## Rules

- Read local repository guidance before applying vault-derived guidance.
- Identify whether the requested change belongs in the vault, a runtime repository, documentation, or an experiment.
- Prefer durable, tool-independent language for knowledge changes.
- Keep implementation changes out of the vault.
- Keep runtime-specific decisions in runtime repositories unless they generalize into reusable knowledge.
- Preserve traceability between lessons, governance rules, export packs, and consuming repositories.
- Ask for review when a change affects governance meaning, package boundaries, accessibility baseline, or runtime validation expectations.

## Conflict Handling

When vault guidance conflicts with local repository instructions:

1. Follow local instructions for implementation mechanics.
2. Follow vault precedence for reusable knowledge interpretation.
3. Record the conflict as a review item when both sources appear authoritative.
