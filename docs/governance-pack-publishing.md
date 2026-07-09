---
id: docs.governance-pack-publishing
title: Governance Pack Publishing
type: workflow
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: supporting
summary: Describes how the vault publishes versioned governance packs for reviewed runtime-repo consumption.
related:
  governed_by:
    - governance.precedence
    - governance.lifecycle
  references:
    - registry.governance-packs
    - registry.sync-contract
    - export-pack.governance.manifest
---

# Governance Pack Publishing

## Goal

Publish governance packs as versioned, reviewable vault artifacts that runtime repositories can consume without giving the vault authority over runtime implementation.

## Pack Model

A governance pack has:

- A registry entry in `registry/governance-packs.yml`.
- A machine-readable manifest in the pack directory.
- Human-readable governance artifacts in `exports/governance-pack/`.
- A changelog that records version changes.
- Schema expectations in `schemas/`.

The pack version identifies governance content and review obligations. Git history remains the source of traceability for exact file content.

## Versioning

Use semantic versioning:

- Major version for breaking governance meaning or required consumer behavior.
- Minor version for added guidance or expanded consuming-repo expectations.
- Patch version for editorial clarification that does not change meaning.

Draft versions may exist before publication. A pack should move to `review` before runtime repositories adopt it and to `stable` only after governance review.

## Publishing Steps

1. Update governance pack artifacts in `exports/governance-pack/`.
2. Update `exports/governance-pack/pack.yml`.
3. Update `exports/governance-pack/CHANGELOG.md`.
4. Update `registry/governance-packs.yml`.
5. Validate schema shape and referenced paths.
6. Open a reviewed vault change.
7. Let consuming repositories adopt the pack through their own reviewed changes.

## Consumption

Runtime repositories may consume the pack by:

- Referencing a pack version in local documentation.
- Copying selected guidance through a reviewed patch.
- Linking to the vault when copying would create drift.

Consumption does not authorize automatic sync or cross-repo writes.

## Boundaries

Governance packs must not include:

- Runtime implementation code.
- Package dependency declarations.
- Lockfiles.
- CI execution workflows.
- Deployment configuration.
- Generated build output.
- Secrets or environment configuration.

## Review Rules

Manual review is required for:

- Governance meaning changes.
- Token semantic changes.
- Component lifecycle or API expectation changes.
- Accessibility baseline changes.
- Package boundary expectation changes.
- Changes to consuming repository expectations.

## Validation

Validation may check YAML shape and referenced paths.

Validation must not:

- Modify consuming repositories.
- Generate runtime code.
- Open pull requests automatically.
- Rewrite local repository files.
