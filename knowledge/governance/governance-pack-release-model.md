---
id: knowledge.governance.governance-pack-release-model
title: Governance Pack Release Model
type: registry
status: draft
owners:
  - ui-foundations
created: 2026-07-09
updated: 2026-07-09
authority: supporting
summary: Working model for turning governance knowledge into versioned export packs.
related:
  references:
    - registry.governance-packs
    - docs.governance-pack-publishing
---

# Governance Pack Release Model

## Purpose

This document captures the working model behind versioned governance packs before it becomes stable governance.

## Model

Governance packs package selected vault guidance for reviewed consumption. They are not the original authority for governance meaning; they are a versioned distribution surface.

The source hierarchy is:

1. Governance, principles, ADRs, and specifications define authority.
2. Export-pack files curate reusable guidance.
3. Pack manifests define versioned publication metadata.
4. Registry files define discoverability and consumption expectations.
5. Runtime repositories review and adopt selected guidance locally.

## Open Questions

- Should stable pack releases be tied to Git tags.
- Whether pack versions should be independently released or aligned to vault releases.
- Whether consuming repositories should record the adopted pack version in local metadata.
