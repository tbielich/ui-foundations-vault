---
id: lesson.uilib-consumer-capability-projection
title: Consumer-Capability Projection from UILib Proof of Use
type: lesson
status: review
owners:
  - ui-foundations
created: 2026-09-18
updated: 2026-09-18
authority: supporting
summary: Captures the UILib proof-of-use lesson that projections should match the consumer's native capability model rather than force one common artifact shape.
tags:
  - agentic
  - projection
  - consumers
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

# Consumer-Capability Projection from UILib Proof of Use

## Source

- External system: TUI UI Library Knowledge
- Repository: `https://source.tui/osp/tech-enablers/ui/ui-library-knowledge`
- Review source: static `ui-library-knowledge-main` snapshot supplied on 2026-09-18
- Primary evidence:
  - `scripts/export-figma.mjs`
  - `scripts/export-copilot.mjs`
  - `scripts/export-kiro.mjs`
  - `scripts/export-ollama.mjs`
  - `decisions/0008-agents-are-vault-canonical.md`

## Local Fact

UILib materializes the same canonical design-system knowledge differently for different consumers.

- Figma receives Agent Skills `SKILL.md` files generated from `skills/`; the exporter explicitly states that there is no agent-prompt export for Figma.
- Copilot Studio receives an instructions field plus separate knowledge files and setup guidance.
- Ollama/A2A receives a structured `agent-card.json` plus a runtime card.
- Kiro receives composed steering-oriented Markdown.

The consumer artifact model is therefore selected by what the target platform can natively consume, not by a requirement to preserve one common projection format.

## Generalized Lesson

A provider-neutral source should project into the artifact model the consumer actually supports.

Provider neutrality does not require identical outputs. It requires stable source semantics and explicit adapters that preserve those semantics while using consumer-native representations.

Forcing heterogeneous consumers into one projection shape creates unnecessary translation layers, duplicated instructions, or loss of platform capability.

## Affected Areas

- Agentic: high
- Governance: supporting
- Runtime: adapter boundary
- Projection/export architecture: high
- Design-system-specific behavior: excluded from UIF promotion

## Human Perspective

Reviewers can evaluate whether a projection fits the target platform instead of reviewing artificial format parity across providers.

## Agent Perspective

Agents and tools receive the smallest native artifact they can reliably interpret rather than a generic prompt wrapper.

## System Perspective

Consumer differences remain isolated in adapters or projection generators while canonical source semantics stay provider-neutral.

## Evidence

Static inspection confirms:

- `scripts/export-figma.mjs` reads `skills/` directly and documents that Figma consumes skills plus live context rather than an agent prompt.
- `scripts/export-copilot.mjs` splits instructions from uploaded knowledge because the consumer has an instructions limit and separate knowledge surface.
- `scripts/export-ollama.mjs` emits structured A2A discovery data separately from runtime prompt material.
- `scripts/export-kiro.mjs` renders Kiro-oriented steering material from the same Vault sources.
- ADR 0008 establishes generated tool configs as outputs from canonical Vault definitions.

No claim is made that these UILib artifacts are authoritative for UIF. They are implementation evidence for a reusable projection principle.

## Proposed Action

Promote the generalized requirement into `specification.project-bootstrap`:

> Select the projection shape from the consumer's native capability model. Do not require one shared artifact format across heterogeneous consumers.

Keep all TUI Design System specifics, provider setup, and UILib export paths local to UILib.

## Open Questions

- Should UIF later define a machine-readable consumer capability manifest?
- Which consumer constraints are stable enough to encode deterministically rather than document as adapter behavior?
