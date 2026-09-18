---
id: lesson.uilib-projection-preflight
title: Projection Preflight before Mutation from UILib Proof of Use
type: lesson
status: review
owners:
  - ui-foundations
created: 2026-09-18
updated: 2026-09-18
authority: supporting
summary: Captures the UILib proof-of-use lesson that projection generation should validate the complete plan before replacing the last valid materialization.
tags:
  - agentic
  - verification
  - projection
  - lineage
consumers:
  - human
  - agent
related:
  references:
    - docs.reflection-loop
    - specification.project-bootstrap
    - specification.capability.verification
provenance:
  sources:
    - type: external-url
      role: supporting-source
      url: https://source.tui/osp/tech-enablers/ui/ui-library-knowledge
verification:
  status: partially-verified
assumptions:
  - Evidence is based on a static repository snapshot reviewed on 2026-09-18, not a live verification of the current remote repository.
  - Static inspection verifies the implemented control flow but not a successful execution of every exporter in the reviewed environment.
---

# Projection Preflight before Mutation from UILib Proof of Use

## Source

- External system: TUI UI Library Knowledge
- Repository: `https://source.tui/osp/tech-enablers/ui/ui-library-knowledge`
- Review source: static `ui-library-knowledge-main` snapshot supplied on 2026-09-18
- Primary evidence:
  - `scripts/export-figma.mjs`
  - `scripts/export-ollama.mjs`
  - `_tests/export-figma.test.js`
  - `_tests/export-ollama.test.js`

## Local Fact

The Figma and Ollama exporters perform a preflight before replacing generated output.

Figma builds and validates the planned skill names, detects invalid names and collisions, and exits with the existing output unchanged if preflight fails.

Ollama resolves every targeted agent and required runtime entry before touching `.ollama/`. Its source comment explicitly states that a failed preflight must not delete a valid prior export.

Only after preflight passes do these exporters replace the generated output.

## Generalized Lesson

Projection materialization should validate the complete generation plan before mutating the current valid output.

The safe sequence is:

```text
resolve inputs
    ↓
validate plan
    ↓
gate
    ↓ PASS
materialize replacement
```

A failed projection build should leave the last known valid materialization unchanged whenever the target storage model permits it.

This applies deterministic verification principles to projection generation rather than relying on partial writes and cleanup after failure.

## Affected Areas

- Agentic: medium
- Verification: high
- Runtime/build: high
- Governance: supporting

## Human Perspective

A failed export does not unexpectedly remove a previously usable consumer configuration.

## Agent Perspective

Generators receive a clear fail-before-write boundary and do not need to recover from partially materialized output.

## System Perspective

Projection generation becomes an atomic state transition with explicit validation evidence.

## Evidence

Static inspection confirms:

- `scripts/export-figma.mjs` performs preflight validation before deleting `.figma/`.
- `scripts/export-ollama.mjs` resolves runtime configuration and targeted agents before deleting `.ollama/`.
- Both exporters abort on preflight errors.
- Export tests exist for Figma and Ollama output shape and selected invariants.

The reviewed snapshot does not provide equivalent preflight guarantees for every target exporter. The generalized lesson is based on the two explicit implementations, not on a claim that all UILib exporters already satisfy it.

## Proposed Action

Promote into `specification.project-bootstrap`:

> A projection generator that replaces existing materialization should preflight source resolution and deterministic validation before destructive mutation. Failure should preserve the last valid output when practical.

Do not require a specific filesystem implementation; atomic replacement semantics are the requirement.

## Open Questions

- Should projection validation emit a machine-readable plan/evidence record before materialization?
- Which remote publishing targets can provide equivalent transactional or versioned replacement semantics?
