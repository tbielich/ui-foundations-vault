---
id: export-pack.agent.projection.kiro-bootstrap
title: Kiro UIF Bootstrap Projection
type: export-pack
status: review
owners:
  - ui-foundations
created: 2026-09-18
updated: 2026-09-18
authority: derived
summary: Defines the Kiro-specific consumption strategy for UIF bootstrap guidance without duplicating repository-owned AGENTS.md instructions.
consumers:
  - human
  - agent
  - kiro
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
    - registry.sync-contract
    - export-pack.agent
    - export-pack.agent.projection.uif-int-agents
provenance:
  sources:
    - type: vault-document
      role: derived-from
      id: specification.project-bootstrap
    - type: vault-document
      role: supporting-source
      id: export-pack.agent.projection.uif-int-agents
    - type: external-url
      role: supporting-source
      url: https://kiro.dev/docs/steering/
verification:
  status: partially-verified
assumptions:
  - Kiro continues to support repository AGENTS.md files as steering context.
  - Kiro workspace steering remains available under .kiro/steering/.
---

# Kiro UIF Bootstrap Projection

## Purpose

This projection defines how Kiro should consume the UIF Project Bootstrap without creating a second copy of repository guidance.

It is derived and non-canonical. It adapts the provider-neutral bootstrap contract to Kiro's steering model while preserving repository ownership and avoiding duplicated durable instructions.

## Projection target

- Consumer: Kiro IDE, CLI, Web, or equivalent Kiro workspace execution
- Primary repository instruction surface: `AGENTS.md`
- Optional Kiro-specific surface: `.kiro/steering/*.md`
- Sync mode: `documentation_reference` or `reviewed_patch` when a Kiro-specific file is actually required

## Default strategy

### 1. Prefer AGENTS.md

When a UIF repository already contains an applicable `AGENTS.md`, Kiro should consume that file as the primary repository instruction surface.

Do not copy the same shared UIF guidance into `.kiro/steering/`.

This is especially important for UIF-INT, where the root `AGENTS.md` already contains a reviewed Vault-managed shared guidance region plus repository-owned execution policy.

### 2. Keep Kiro steering provider-specific

Create Kiro steering only when the instruction is genuinely specific to Kiro's interaction model or capabilities.

Suitable examples include:

- Kiro-only invocation guidance;
- Kiro-specific inclusion behavior;
- Kiro hook usage guidance;
- Kiro custom-agent resource wiring;
- temporary provider adaptation that cannot be expressed provider-neutrally.

Do not use Kiro steering to redefine:

- UIF governance;
- Execution Contract semantics;
- verification policy;
- repository architecture;
- component or token specifications;
- provider-neutral executor behavior.

### 3. Choose the narrowest inclusion mode

If a Kiro steering file is needed, choose the smallest suitable inclusion scope:

- `manual` for occasional operational guidance;
- `auto` for context that Kiro should include only when the request matches a clear description;
- `fileMatch` for file- or domain-scoped rules;
- `always` only when the guidance is truly universal for every interaction.

Do not use `always` merely to recreate `AGENTS.md`.

### 4. Reference live repository state

Where Kiro-specific steering needs repository context, prefer references to live workspace files over copying their contents.

For example, Kiro supports file references such as:

```markdown
#[[file:AGENTS.md]]
```

A reference does not change the authority of the referenced file.

### 5. Preserve UIF authority routing

Kiro-specific instructions remain subordinate to:

1. explicit current human instruction;
2. applicable bounded Execution Contract;
3. repository-local architecture, contracts, tests, configuration, and `AGENTS.md`;
4. applicable accepted or stable UIF-VLT sources;
5. derived provider projections.

Kiro steering must not silently override a higher-authority source.

## UIF-INT materialization

For `ui-foundations-intelligence`, the current conformant materialization is:

```text
UIF-VLT canonical knowledge
        |
        v
specification.project-bootstrap
        |
        v
UIF-INT AGENTS.md projection
        |
        v
ui-foundations-intelligence/AGENTS.md
        |
        v
Kiro native AGENTS.md consumption
```

No additional Kiro bootstrap steering file is required for UIF-INT merely to repeat the shared bootstrap guidance.

This is intentional.

A future `.kiro/steering/*.md` file should be introduced only when there is a demonstrated Kiro-specific concern that is not already represented by repository-owned or canonical sources.

## Optional adapter pattern

If a repository later needs a Kiro-only adapter, prefer a thin file such as:

```markdown
---
inclusion: manual
---

# Kiro Provider Adapter

Use the repository's AGENTS.md as the primary authority for repository behavior.

#[[file:AGENTS.md]]

This file contains only Kiro-specific operating guidance. It must not redefine UIF governance, repository architecture, task scope, or verification semantics.
```

The example is illustrative. Do not materialize it unless there is an actual Kiro-specific need.

## Custom agents

When Kiro custom agents are used, review their resource configuration explicitly.

Kiro steering files are not automatically included in custom agents unless they are configured as resources. If a custom agent depends on Kiro steering, declare the required resources in that agent's configuration rather than assuming workspace steering is inherited.

This requirement concerns Kiro delivery behavior only. It does not change canonical UIF authority.

## Consumption rules

1. Read the repository's applicable `AGENTS.md` before introducing Kiro-specific steering.
2. If `AGENTS.md` already expresses the needed rule, do not duplicate it.
3. Introduce Kiro steering only for a provider-specific gap.
4. Keep the steering file narrow and choose the least-broad inclusion mode.
5. Prefer live file references where duplication would otherwise occur.
6. Review all generated patches before merge.
7. Promote reusable cross-provider meaning back to UIF-VLT rather than allowing it to remain Kiro-only.
8. Remove obsolete Kiro adapters when the provider-specific need disappears.

## Intentionally excluded

This projection does not define:

- Kiro hooks for a specific repository;
- Kiro credit or usage policy;
- model selection;
- credentials or environment variables;
- repository build and test commands;
- issue intake state;
- current execution status;
- provider-neutral orchestration contracts.

Those concerns remain local to the appropriate repository, execution system, or separate governed source.

## Validation

This projection is conformant when:

- Kiro can consume applicable repository instructions without a duplicated bootstrap copy;
- Kiro-only steering contains only provider-specific adaptation;
- repository-owned and Vault-owned concerns remain distinguishable;
- no volatile execution state or credentials are embedded;
- provider-specific guidance does not become canonical by repetition;
- custom-agent resource dependencies are explicit when steering is required;
- removing the Kiro projection does not remove the canonical UIF knowledge needed by another provider.

## Rationale

Kiro's native support for `AGENTS.md` makes a second always-on UIF bootstrap file unnecessary for repositories that already expose their repository guidance through `AGENTS.md`.

The simplest reusable model is therefore:

> Use the shared repository contract directly; add provider steering only for provider differences.

This keeps Kiro aligned with UIF while minimizing duplicated instructions, context overhead, and drift.
