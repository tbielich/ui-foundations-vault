---
id: registry.index
title: Registry
type: index
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: supporting
summary: Navigation for machine-readable cross-repo registry files.
related:
  references:
    - registry.repos
    - registry.sync-contract
    - registry.artifact-types
---

# Registry

## Purpose

The registry declares cross-repo knowledge consumption in machine-readable YAML.

It does not execute synchronization. It describes what may be consumed, by which repositories, under which review constraints.

## Files

- `repos.yml`: repository types, consumed packs, sync direction, owners, allowed artifacts, and update policies.
- `sync-contract.yml`: allowed exports, protected local files, local-only files, and manual review requirements.
- `artifact-types.yml`: controlled artifact types used by the registry and sync contract.
