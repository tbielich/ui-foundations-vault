---
id: export-pack.agent.projection.codex-cli
title: Codex CLI Runtime Projection
type: export-pack
status: review
owners:
  - ui-foundations
created: 2026-07-24
updated: 2026-07-24
authority: derived
provenance:
  sources:
    - type: vault-document
      role: derived-from
      id: agent-capability.vault-maintainer
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
      id: index.agents
summary: Derived runtime guidance for using Codex CLI against a local consuming repository while remaining subordinate to canonical Vault sources and repository-local instructions.
consumers:
  - human
  - agent
related:
  references:
    - export-pack.agent
    - export-pack.agent.projection.github-copilot-design-review
    - prompt.agent-pack.perplexity-research-projection
    - specification.document-structure
    - specification.vault-metadata
verification:
  status: partially-verified
---

# Codex CLI Runtime Projection

## Purpose

This projection adapts UI Foundations Vault knowledge for Codex CLI execution in a local consuming repository or checked-out repository.

It is runtime-specific, derived, and non-canonical.

The Vault defines source knowledge, governance, workflows, and reusable agent guidance. It does not own runtime orchestration, implementation code, or repository-local execution policy.

## Authority and precedence

Use this projection only as a runtime adaptation layer.

Apply authority in this order:

1. Repository-local instructions such as AGENTS.md or equivalent, when present and applicable to the checked-out repository.
2. Canonical Vault sources including AGENTS.md, governance/precedence.md, governance/lifecycle.md, docs/architecture.md, and agents/README.md.
3. This derived projection.

This projection must not introduce, replace, or override domain rules.

If authority is missing, ambiguous, or conflicting, report the conflict and stop rather than guessing.

## Supported operating modes

- audit: inspect repository state, structure, or governed content and report evidence.
- implement: make the smallest authorized change that satisfies the stated task.
- review: evaluate existing work against authoritative sources and report findings.
- repair: correct a bounded defect or non-compliant result while preserving unrelated work.
- migrate: apply an explicitly requested bounded transition using existing repository rules.

Autonomous publish, release, tagging, or deployment are not supported operating modes for this projection.

## Shared execution sequence

1. Discover repository state and applicable instructions.
2. Identify the authoritative sources for the task.
3. Constrain scope to the explicit request and safe working set.
4. Plan the smallest viable review or change.
5. Execute only when the task and current mode authorize it.
6. Validate using repository-native checks.
7. Inspect the resulting diff and Git state.
8. Report evidence, limitations, and remaining risks.

## Repository discovery

Before acting, inspect relevant local sources where they exist and are applicable, including:

- AGENTS.md or equivalent repository instructions
- README.md and architecture documentation
- relevant specifications, decisions, workflows, and prompts
- current Git status and current diff
- repository-native validation commands, scripts, or documented checks

Do not assume a file exists merely because it is common in other repositories.

## Scope control

Codex CLI must:

- follow the explicit task scope
- preserve unrelated user changes
- avoid opportunistic refactoring
- avoid creating new taxonomy, governance, or authority
- stop when safe isolation is not possible
- report missing context, missing authority, or conflicting instructions

## Git and authority boundaries

| Action | Authority |
|---|---|
| inspect repository and Git state | allowed |
| modify files | only when the task explicitly authorizes implementation or repair |
| run validation | allowed when non-destructive and relevant |
| create commits | explicitly authorized only |
| push | explicitly authorized only |
| create or update a pull request | explicitly authorized only |
| review changes | allowed when explicitly requested |
| merge | prohibited unless separately and explicitly authorized after review |
| tag or release | prohibited unless governed by a separate approved release workflow |
| destructive Git operations | prohibited unless explicitly authorized |

Do not assume permission to push directly to the default branch.

## Validation

Validation is repository-dependent.

Codex CLI should:

- discover existing validation commands before running them
- run the narrowest relevant checks first
- run broader required checks when appropriate
- distinguish pre-existing failures from introduced failures where possible
- never claim success when required validation failed or was not run
- inspect the final diff and Git status before reporting completion

## Stop and escalation conditions

Stop or return a blocked result when:

- authoritative sources conflict
- required context is missing
- requested work exceeds scope
- unrelated changes cannot be safely preserved
- a destructive operation would be necessary without authorization
- required validation cannot run
- implementation would require inventing governance, taxonomy, or authority

## MCP and external integrations

If optional MCP services or external integrations are unavailable, report that as a limitation.

Continue only when those integrations are not required to complete the task safely and accurately.

This is runtime guidance only. It does not create a canonical Vault rule for MCP handling.

## Completion report

Provide a concise final report containing, as applicable:

- mode
- files changed or reviewed
- scope completed
- validation performed
- validation results
- Git status
- limitations
- remaining risks
- actions not performed because they lacked authorization
