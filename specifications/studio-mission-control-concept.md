---
id: specification.studio-mission-control-concept
title: Studio Mission Control and Quality Intelligence — Concept
type: specification
status: draft
owners:
  - ui-foundations
created: 2026-10-08
updated: 2026-10-08
authority: supporting
summary: Draft capability concept for evidence-backed mission visualization, quality observability, human decisions, and agent efficiency in UIF Studio.
applies_to:
  - ui-foundations-studio
  - ui-foundations-intelligence
  - ui-foundations
consumers:
  - human
  - agent
  - studio
verification:
  status: unverified
provenance:
  sources:
    - type: issue
      role: supporting-source
      repository: ui-foundations-intelligence
      number: 95
---

# Studio Mission Control and Quality Intelligence — Concept

## Purpose

Make the private UI Foundations ecosystem understandable and auditable through an interactive Studio view of **real** task progress, agent work, verification, correction, accessibility quality, and human control. This is a first concept for review, **not** an accepted execution or metrics contract.

## Scope and responsibilities

- **UIF-VLT**: canonical definitions, governance, and reviewed knowledge; no execution-state database.
- **UIF-INT**: bounded execution, provider-neutral routing, verification, persisted traces and operational metric computation.
- **UIF-RUN**: actual design tokens, components, assets, tests and implementation evidence.
- **UIF-STO**: read-first projections, navigation, filtering, replay, and review affordances; no parallel orchestration or independent governance.
- **GitHub**: existing issues, PRs, commits and evidence links where applicable.

No feature in this concept transfers UIF responsibilities to TUI UILib.

## Proposed capabilities

1. **Mission Map**: current missions and evidence-backed transitions across intake, contract, execution, verification, and human decision.
2. **Mission Replay**: deterministic playback of persisted events with links to source traces, timestamps, revisions and verified outcomes.
3. **Self-Correction Observatory**: detect → finding → bounded REPAIR → re-verification; before/after diffs, token references and rule provenance. A hardcoded spacing value is a useful initial test case.
4. **Accessibility Observatory**: explicit compliance **gate** (PASS / FAIL / INCOMPLETE), audit **coverage**, and findings by severity and affected interaction; distinguish automated checks from keyboard, screen reader, and manual evidence. Never turn raw audit pass rates into claims of WCAG conformance.
5. **Agent Performance**: report first-pass verification, repairs per accepted task, verified elapsed time, scope adherence, resource use and costs **only where observed**; identify provider, model, executor version and environment separately.
6. **Intelligence Impact**: compare controlled runs with/without scoped governance or promoted lessons, keeping task, baseline, validation oracle and scope fixed.
7. **Human Gates**: inspect evidence, authorization/scope, exceptions, approvals and escalation; never suggest a human approved work without a persisted decision.
8. **Learning Observatory** (later): connect verified findings to *proposed*, reviewed and accepted lessons/ADRs, with lifecycle labels.

## Experience principles

- Visualization is an **evidence-backed projection**; no synthetic live missions or inferred approvals.
- Distinguish **LIVE**, **last synchronized**, **historical replay**, **unknown**, and **not measured**.
- Animations mean recorded transitions, not independent progress claims. Reduced-motion alternative required.
- Gamification highlights progress and verified quality, never token throughput, leaderboard pressure, or arbitrary activity.
- Users can drill from each card, score and transition to its underlying contract, trace, test command, finding or review decision.
- Read-only first. Future approvals require existing INT-authorized commands/contracts, explicit permission and audit trails.

## Minimal projection sketch (candidate, not yet a schema)

Each observation should retain: `mission_id`, `source_ref`, `event_id`, `event_time`, `observed_time`, `stage`, `status`, `contract_ref`, `trace_ref`, `actor/executor configuration`, `evidence_refs`, and optional `human_decision_ref`.

- Reuse existing INT traces/contracts first; adapt from verified real shapes.
- Do not invent event types or duplicate an execution store.
- Handle incomplete traces, late events, retries, stale reads and offline systems visibly.
- Do not calculate aggregate scores from missing coverage or mix dissimilar task classes.

## MVP sequence

### Slice 0 — Evidence discovery

Inspect current UIF-INT trace and benchmark artifacts, GitHub issue #95 and the existing UIF-STO client proposal. List what can be displayed from real records and what is missing. No fabricated event feed.

### Slice 1 — Mission Journey

Read-only journey for one actual mission (candidate: UIF-INT #95). Show recorded steps, trace links, real status, human gates and a replay of persisted events. An issue alone does not prove a run is live.

### Slice 2 — Token Correction

Use an actual hardcoded-spacing finding and its before/after evidence **if one exists**; otherwise show an explicit evidence gap. Show repair and re-verification only when they were recorded.

### Slice 3 — Accessibility

Select one real UIF-RUN component with available audit evidence. Surface PASS/FAIL/INCOMPLETE, coverage, findings and manual-test gaps; never label untested behavior compliant.

### Later — Performance and Learning

Add comparisons after comparable sample sizes and measurement provenance exist. Avoid premature composite agent ranking.

## Acceptance criteria for the first prototype

- A viewer can identify the task source, allowed scope, involved executor(s), verification result and whether human action is needed.
- Every displayed transition and score links to persisted evidence or says **unavailable / not measured**.
- Recorded failure, bounded repair, and re-verification are distinguishable; no self-healing loop is implied.
- No mutations to RUN/INT, no shadow workflow engine, no assumed live feed.
- Fallback works when streaming is unavailable; snapshot and replay remain useful.
- Keyboard navigation, meaningful labels and reduced-motion behavior are supported.

## Open decisions (not made by this draft)

- Existing INT trace/event read contract and source of truth for refresh timestamps.
- Studio's initial delivery technology and whether the old Streamlit/A2A-only planning proposal remains current.
- Authentication and authorization for eventual human approval controls.
- Metric definitions and benchmark comparability thresholds.

## References

- `tbielich/ui-foundations-intelligence#95` — ADR 0003 real-agent lesson benchmark and hardcoded spacing-token failure condition.
- `ui-foundations-studio/docs/architecture-proposal.md` — existing planning-only thin-client proposal (verify applicability before implementation).
- `ui-foundations-intelligence/AGENTS.md` — repository-local execution, verification and evidence boundaries.
