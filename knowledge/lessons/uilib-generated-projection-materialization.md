---
id: lesson.uilib-generated-projection-materialization
title: Generated Projection Materialization from UILib Proof of Use
type: lesson
status: review
owners:
  - ui-foundations
created: 2026-09-18
updated: 2026-09-18
authority: supporting
summary: Captures the UILib proof-of-use lesson that canonical projection intent should be committed while consumer artifacts are deterministically generated and disposable.
tags:
  - agentic
  - projection
  - materialization
  - lineage
consumers:
  - human
  - agent
related:
  references:
    - docs.reflection-loop
    - specification.project-bootstrap
provenance:
  sources:
    - type: external-url
      role: supporting-source
      url: https://source.tui/osp/tech-enablers/ui/ui-library-knowledge
verification:
  status: partially-verified
assumptions:
  - Evidence is based on a static repository snapshot reviewed on 2026-09-18, not a live verification of the current remote repository.
  - UILib is treated as an external proof-of-use system and does not define UIF governance.
---

# Generated Projection Materialization from UILib Proof of Use

## Source

- External system: TUI UI Library Knowledge
- Repository: `https://source.tui/osp/tech-enablers/ui/ui-library-knowledge`
- Review source: static `ui-library-knowledge-main` snapshot supplied on 2026-09-18
- Primary evidence:
  - `decisions/0008-agents-are-vault-canonical.md`
  - `.gitignore`
  - `scripts/export-kiro.mjs`
  - `scripts/export-copilot.mjs`
  - `scripts/export-figma.mjs`
  - `scripts/export-ollama.mjs`

## Local Fact

UILib keeps canonical definitions in the Vault and treats target-specific configurations as generated outputs.

ADR 0008 states that agent definitions are Vault-canonical and tool configs are generated exports, never sources. Generated target directories such as `.kiro/`, `.copilot/`, `.ollama/`, and `.figma/` are disposable build artifacts rather than authored knowledge.

The exporters compose canonical agent, skill, and steering documents into consumer-specific materializations.

## Generalized Lesson

When a projection can be derived deterministically from canonical sources and explicit consumer constraints, commit the projection intent and generation rules rather than treating the generated consumer artifact as durable knowledge.

Generated projections should be reproducible and disposable. A consumer artifact may be cached, published, or reviewed, but it should not become a second source of truth.

This reduces drift between canonical guidance and provider-specific copies.

## Affected Areas

- Agentic: high
- Governance: source-of-truth boundary
- Runtime: generated consumer artifacts
- Projection/export architecture: high

## Human Perspective

Reviewers inspect canonical changes and deterministic generation rules rather than maintaining multiple hand-edited copies.

## Agent Perspective

Consumers can regenerate target-specific guidance from stable source contracts and do not need to infer which copy is current.

## System Perspective

Projection drift becomes a build/reconciliation problem instead of a knowledge-authoring problem.

## Evidence

Static inspection confirms:

- ADR 0008 explicitly defines tool configs as generated exports and the Vault as source.
- Export scripts generate target folders from canonical Vault documents.
- Generated target folders are gitignored.
- The exporters include generated-from/source-of-truth notices in output.

The evidence demonstrates the materialization pattern, not a requirement that UIF copy UILib's repository structure or scripts.

## Proposed Action

Promote into `specification.project-bootstrap` as a preferred materialization rule:

> Prefer deterministic generation for derived consumer projections when the source inputs and consumer constraints are sufficiently stable. Generated materializations remain derived and replaceable.

Keep the current hand-authored UIF projections as reference implementations until a generator contract is proven. Do not delete them as part of this lesson.

## Open Questions

- What minimal manifest should describe projection source ids, consumer constraints, output shape, and validation?
- At what point should a generated projection stop being committed and become only a build artifact?
