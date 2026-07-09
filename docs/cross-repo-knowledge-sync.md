---
id: docs.cross-repo-knowledge-sync
title: Cross-Repo Knowledge Sync
type: index
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: supporting
summary: Explains how the vault acts as the central source for reusable cross-repo UI Foundations knowledge.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - registry.repos
    - registry.sync-contract
    - registry.artifact-types
    - knowledge.index
    - docs.reflection-loop
---

# Cross-Repo Knowledge Sync

## Purpose

The UI Foundations Vault is the central, versioned source for reusable UI Foundations knowledge, governance rules, agent guidance, and lessons learned.

It is not runtime code. It does not build packages, execute sync, deploy artifacts, or mutate consuming repositories. It provides reviewed knowledge that other repositories may consume through explicit contracts.

## Why the Vault Is Central

UI Foundations work spans runtime packages, documentation, experiments, agent workflows, and product-facing tools. Without a central knowledge source, each repository can drift into local rules that are hard to compare or reuse.

The vault centralizes what should be stable across repositories:

- Governance and precedence.
- Token and component expectations.
- Accessibility baselines.
- Agent behavior rules.
- Lessons that have generalized beyond one issue or PR.

Runtime repositories remain responsible for their own implementation, tests, package configuration, CI, releases, and deployment.

## Knowledge, Governance, Runtime, and Automation

Knowledge captures reusable understanding. It may be exploratory until it is reviewed and promoted.

Governance defines rules for trust, ownership, review, lifecycle, and decision rights. Governance has higher precedence than workflows, prompts, packs, and examples.

Runtime is executable implementation and repository-local configuration. Runtime belongs in implementation repositories, not in the vault.

Automation executes behavior. The vault may describe automation expectations, but it should not hide automatic sync behavior or mutate repositories without a reviewed contract.

## How Runtime Repositories Consume Knowledge

Runtime repositories consume vault knowledge by:

- Referencing vault documents directly.
- Copying reviewed sections from export packs.
- Selecting a reviewed governance pack version from `registry/governance-packs.yml`.
- Opening reviewed patches that apply selected guidance locally.
- Recording which packs they consume in `registry/repos.yml`.

Consumption must follow `registry/sync-contract.yml`.

Protected local files, runtime implementation, dependency manifests, lockfiles, CI workflows, deployment configuration, and secrets must remain repository-local.

## How Knowledge Flows Back

Reusable insights should flow back into the vault after larger issues, PRs, experiments, reviews, or incidents.

The expected path is:

1. Extract a lesson from concrete work.
2. Document it in `knowledge/lessons/`.
3. Watch for recurrence across repositories.
4. Promote repeated lessons into governance, specifications, workflows, prompts, or export packs.
5. Update `registry/` when consumption expectations change.

## Human Perspective

Humans use the vault to review whether a rule is durable, whether it belongs in the vault, and whether a consuming repository should adopt it.

Human reviewers should check:

- The source and affected repositories are clear.
- The change does not duplicate existing canonical knowledge.
- The proposed rule is tool-independent unless tool specificity is explicitly scoped.
- Runtime code and local configuration remain outside the vault.

## Agent Perspective

Agents use the vault to retrieve stable guidance, resolve conflicts through precedence, and keep cross-repo work traceable.

Agents should:

- Read local repository instructions before applying vault guidance.
- Apply vault precedence when multiple vault documents conflict.
- Keep prompts subordinate to governance, principles, ADRs, and specifications.
- Suggest lessons when runtime work reveals reusable knowledge.
- Avoid automatic overwrites unless a reviewed contract explicitly permits them.

## System Perspective

Systems may later validate registry structure or propose reviewed patches, but they must not silently synchronize changes.

Any future system must:

- Read `registry/repos.yml`.
- Enforce `registry/sync-contract.yml`.
- Produce reviewable plain-text diffs.
- Respect protected local files.
- Refuse runtime mutation from vault sync.

## Risks

- Local implementation detail may be over-generalized into governance too early.
- Runtime repositories may copy stale guidance without source traceability.
- Export packs may be treated as more authoritative than their source documents.
- Automation may create hidden behavior if the sync contract is bypassed.
- Duplicated knowledge may drift across the vault and consuming repositories.

## Review Rules

Manual review is required when a change:

- Alters governance meaning.
- Promotes lessons into governance.
- Changes consumed export packs for a repository.
- Changes a published governance pack version, channel, manifest, or consumer expectation.
- Touches repository agent guidance.
- Affects accessibility baseline, package boundaries, token semantics, or component lifecycle.
- Changes files listed under `never_auto_overwrite` in `registry/sync-contract.yml`.
