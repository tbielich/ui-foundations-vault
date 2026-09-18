---
id: export-pack.agent.fragments.index
title: Agent Pack Projection Fragments
type: index
status: review
owners:
  - ui-foundations
created: 2026-09-18
updated: 2026-09-18
authority: derived
summary: Index for reusable derived text fragments used by deterministic consumer projections.
related:
  references:
    - specification.project-bootstrap
    - registry.project-projections
    - export-pack.agent
---

# Agent Pack Projection Fragments

## Purpose

This directory contains reusable, derived text fragments that deterministic projection manifests can compose into consumer-native artifacts.

Fragments are not canonical UIF knowledge. They translate reviewed canonical meaning into reusable projection text and must preserve traceability to their source ids.

## Rules

- Keep canonical semantics in governed UIF-VLT sources.
- Keep fragment text derived and replaceable.
- Give each fragment a stable id.
- Record source ids for each fragment.
- Let `registry/project-projections.yml` select and order fragments per consumer.
- Do not embed volatile task state, credentials, local paths, or runtime-only configuration.
- Prefer reuse when multiple consumers need the same wording; keep provider-specific wording in consumer-specific fragments or adapters.
- Validate the complete composition before materialization.

## Current packs

- `project-bootstrap.yml`: reusable bootstrap fragments currently composed by the ChatGPT Project projection.

## Materialization

```bash
ruby scripts/generate-project-projections.rb --check
ruby scripts/generate-project-projections.rb
```

Generated outputs live under `.generated/project-projections/` and are disposable.
