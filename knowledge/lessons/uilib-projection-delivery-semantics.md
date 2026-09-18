---
id: lesson.uilib-projection-delivery-semantics
title: Service and Snapshot Projection Semantics from UILib Proof of Use
type: lesson
status: review
owners:
  - ui-foundations
created: 2026-09-18
updated: 2026-09-18
authority: supporting
summary: Captures the UILib proof-of-use distinction between live service access and static projection artifacts that require rebuild and redistribution.
tags:
  - agentic
  - delivery
  - projection
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
  - The referenced UILib delivery ADR is proposed rather than accepted; only the service-versus-artifact distinction is treated as implementation learning.
---

# Service and Snapshot Projection Semantics from UILib Proof of Use

## Source

- External system: TUI UI Library Knowledge
- Repository: `https://source.tui/osp/tech-enablers/ui/ui-library-knowledge`
- Review source: static `ui-library-knowledge-main` snapshot supplied on 2026-09-18
- Primary evidence:
  - `decisions/0009-agent-exports-built-and-delivered-via-ci.md`
  - `architecture/design-system-mcp.md`
  - generated export model from ADR 0008

## Local Fact

UILib distinguishes two delivery shapes:

- MCP is a live service that resolves current design-system knowledge at runtime.
- Agent exports are static artifacts that represent a snapshot at build time and must be rebuilt and re-consumed when the source changes.

ADR 0009 is still proposed, so its AWS/registry delivery plan is not treated as established evidence. The durable observation is the semantic difference between a live service and a generated snapshot.

## Generalized Lesson

A projection contract should identify whether the consumer receives:

1. **live service/reference semantics** — current state is resolved at use time; or
2. **snapshot artifact semantics** — state is materialized at build time and can become stale.

These modes have different freshness, provenance, delivery, invalidation, and verification requirements.

Do not silently treat a snapshot as if it were live context.

Volatile values that can be resolved safely at runtime should remain references where practical rather than being copied into durable projection artifacts.

## Affected Areas

- Agentic: medium
- Delivery: high
- Freshness/provenance: high
- Runtime: medium
- Governance: supporting

## Human Perspective

Reviewers can tell whether a consumer sees current knowledge or a time-bounded materialization and can reason about refresh obligations.

## Agent Perspective

Agents can distinguish runtime lookup from embedded snapshot data instead of assuming all context has the same freshness.

## System Perspective

Freshness and invalidation become explicit properties of projection delivery rather than hidden implementation details.

## Evidence

Static inspection confirms:

- ADR 0009 explicitly distinguishes MCP as a live service from agent exports as build-time artifacts.
- ADR 0008 defines generated tool configs as outputs rather than canonical source.
- The concrete exporters write static target artifacts.

The proposed deployment stages in ADR 0009 are not promoted into UIF because they are TUI/UILib-specific and not accepted in the source system.

## Proposed Action

Promote only the delivery-semantics requirement into `specification.project-bootstrap`:

> A projection must declare whether it is a live reference/service or a snapshot materialization. Snapshot consumers require an explicit refresh/rebuild path and must not imply current-state semantics.

Keep AWS, registry, CI, and TUI delivery mechanisms outside UIF.

## Open Questions

- What minimum metadata should identify source revision, generated-at time, and consumer compatibility for snapshot materializations?
- Which UIF consumers actually require published snapshots rather than references to live canonical sources?
