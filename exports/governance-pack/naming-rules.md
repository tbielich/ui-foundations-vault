---
id: export-pack.governance.naming-rules
title: Naming Rules
type: governance
status: review
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-15
authority: derived
summary: Reusable naming rules for UI Foundations ecosystem artifacts.
related:
  references:
    - reference.terminology
    - registry.sync-contract
    - adr.uif-public-api-namespace
---

# Naming Rules

## Machine-Readable Contract

Runtime repositories should consume `exports/governance-pack/contracts/naming-contract.json` as the portable machine-readable naming contract. This markdown document explains governance intent; it does not replace or redefine the JSON contract for runtime consumption.

## Rules

- Prefer semantic names over tool-specific or implementation-specific names.
- Names should describe responsibility, not current storage location.
- Keep reusable knowledge names stable when files move.
- Avoid names that imply automation unless automation exists and is governed.
- Use repository-local names for implementation details that are not reusable.
- Public Nunjucks examples and generated snippets use the consumer-selected
  `uif` import alias and invoke macros as `uif.*`.
- Public autonomous Custom Element tag names use the `uif-` prefix and the form
  `<uif-[component]>`.
- The macro alias rule does not rename the macro module path or named exports.
- The Custom Element tag rule does not decide JavaScript identifiers, module
  filenames, package subpaths, compatibility aliases, or migration behavior.

## Review Expectations

Naming changes require review when they affect tokens, component APIs, package boundaries, or canonical document identifiers.
